/*
 * Course Module: Advanced Mobile Development (COM640)
 * Student Name: Hasini Piyumika
 * Student ID: 25026164
 * Project: MediTrack - Personal Health & Medication Reminder App
 * File: lib/screens/add_medication_screen.dart
 * Description: Interface Form allowing the creation of new Medication entries, SQLite inserts,
 *              and automatic alarm registrations inside NotificationService.
 */

import 'package:flutter/material.dart';
import 'package:meditrack_app/database/database_helper.dart';
import 'package:meditrack_app/models/user.dart';
import 'package:meditrack_app/models/medication.dart';
import 'package:meditrack_app/services/notification_service.dart';

class AddMedicationScreen extends StatefulWidget {
  final User currentUser;
  const AddMedicationScreen({super.key, required this.currentUser});

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _notesController = TextEditingController();

  String _category = 'Pill'; // Default dropdown item
  TimeOfDay _selectedTime =
      const TimeOfDay(hour: 8, minute: 0); // Default schedule time
  bool _isLoading = false;

  final List<String> _categories = [
    'Pill',
    'Syrup',
    'Injection',
    'Tablet',
    'Capsule'
  ];

  // Trigger standard Flutter Time Picker dialogue
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // Handle form submissions, SQL saves, and local alarm configurations
  void _saveMedication() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Extract details and format hour/minute strings as "HH:mm"
      final String name = _nameController.text.trim();
      final String dosage = _dosageController.text.trim();
      final String notes = _notesController.text.trim();

      final String formattedHour =
          _selectedTime.hour.toString().padLeft(2, '0');
      final String formattedMinute =
          _selectedTime.minute.toString().padLeft(2, '0');
      final String timeString = '$formattedHour:$formattedMinute';

      // Assemble medication model object
      Medication newMed = Medication(
        userId: widget.currentUser.id!,
        name: name,
        dosage: dosage,
        category: _category,
        time: timeString,
        notes: notes.isNotEmpty ? notes : 'Take on time',
      );

      // Write transaction to local SQLite DB
      int medId = await DatabaseHelper.instance.insertMedication(newMed);

      setState(() => _isLoading = false);

      if (medId > 0) {
        // Trigger platform OS alarm registration
        await NotificationService.instance.scheduleMedicationAlarm(
          id: medId,
          title: name,
          body: 'Dosage: $dosage ($notes)',
          timeString: timeString,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Scheduled "$name" daily at $timeString successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // Safe back-navigation popping context
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Error saving medication schedule. Please check inputs.'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Elegant design variables
    final String timeDisplay =
        '${_selectedTime.hour.toString().padLeft(2, "0")}:${_selectedTime.minute.toString().padLeft(2, "0")}';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add Medication'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Schedule New Medicine',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937)),
                ),
                const SizedBox(height: 4),
                const Text(
                    'Set dosage intervals and times for active reminders.',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 28),

                // Medicine Name input field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Medicine Name',
                    prefixIcon:
                        const Icon(Icons.medication, color: Color(0xFF4F46E5)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter medicine name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Dosage input field (e.g. 2 Pills, 1 Teaspoon, etc.)
                TextFormField(
                  controller: _dosageController,
                  decoration: InputDecoration(
                    labelText: 'Dosage Amount (e.g. 2 Pills, 5ml)',
                    prefixIcon: const Icon(Icons.numbers_outlined,
                        color: Color(0xFF4F46E5)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please specify dosage requirements';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Category Selection dropdown
                DropdownButtonFormField<String>(
                  initialValue: _category,
                  decoration: InputDecoration(
                    labelText: 'Medicine Category',
                    prefixIcon: const Icon(Icons.category_outlined,
                        color: Color(0xFF4F46E5)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  items: _categories.map((String cat) {
                    return DropdownMenuItem<String>(
                      value: cat,
                      child: Text(cat),
                    );
                  }).toList(),
                  onChanged: (String? val) {
                    if (val != null) setState(() => _category = val);
                  },
                ),
                const SizedBox(height: 20),

                // Time picker visual button
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.alarm, color: Color(0xFF4F46E5)),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Reminder Time',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey)),
                                Text(
                                  timeDisplay,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () => _selectTime(context),
                          child: const Text('Select Time',
                              style: TextStyle(
                                  color: Color(0xFF4F46E5),
                                  fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Notes input field
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Notes / Special Instructions (Optional)',
                    prefixIcon:
                        const Icon(Icons.notes, color: Color(0xFF4F46E5)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 32),

                // Submission Action button
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveMedication,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Text('Save Medication & Schedule Alarm',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
