/*
 * Course Module: Advanced Mobile Development (COM640)
 * Student Name: Hasini Piyumika
 * Student ID: 25026164
 * Project: MediTrack - Personal Health & Medication Reminder App
 * File: lib/screens/medication_list_screen.dart
 * Description: Medication List Screen displaying entries in a list view with swipe-to-dismiss (delete) actions.
 */

import 'package:flutter/material.dart';
import 'package:meditrack_app/database/database_helper.dart';
import 'package:meditrack_app/models/user.dart';
import 'package:meditrack_app/models/medication.dart';
import 'package:meditrack_app/services/notification_service.dart';

class MedicationListScreen extends StatefulWidget {
  final User currentUser;
  const MedicationListScreen({super.key, required this.currentUser});

  @override
  State<MedicationListScreen> createState() => _MedicationListScreenState();
}

class _MedicationListScreenState extends State<MedicationListScreen> {
  late Future<List<Medication>> _medicationsFuture;

  @override
  void initState() {
    super.initState();
    _refreshMedications();
  }

  // Reload medication datasets
  void _refreshMedications() {
    setState(() {
      _medicationsFuture =
          DatabaseHelper.instance.getMedicationsForUser(widget.currentUser.id!);
    });
  }

  // Handles item deletion through SQL databases and Alarms
  Future<void> _deleteMedication(Medication med) async {
    // Delete from SQL database
    await DatabaseHelper.instance.deleteMedication(med.id!);

    // Cancel pending notification triggers
    await NotificationService.instance.cancelNotification(med.id!);

    // Re-query data models
    _refreshMedications();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Removed "${med.name}" and cancelled associated alarms.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        title: const Text('My Medication Schedule'),
      ),
      body: FutureBuilder<List<Medication>>(
        future: _medicationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xFF4F46E5)));
          } else if (snapshot.hasError) {
            return const Center(child: Text('Database extraction error.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.medication_liquid_outlined,
                        size: 72, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No Medication Scheduled',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937)),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'All your scheduled medications will appear here. Press the "+" button on the dashboard to register a new reminder.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }

          final medications = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: medications.length,
            itemBuilder: (context, index) {
              final med = medications[index];

              // Select category-appropriate icons
              IconData icon = Icons.medical_services_outlined;
              if (med.category == 'Pill') icon = Icons.vaccines_outlined;
              if (med.category == 'Syrup') icon = Icons.healing_outlined;
              if (med.category == 'Injection') icon = Icons.biotech_outlined;

              // Swipe to Dismiss (Swipe to Delete) implementation
              return Dismissible(
                key: Key(med.id.toString()),
                direction: DismissDirection.endToStart, // Swipe right-to-left
                onDismissed: (direction) async {
                  await _deleteMedication(med);
                },
                // Red background shown behind cards when swiped
                background: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.only(right: 20),
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Delete Alarm',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Icon(Icons.delete_sweep, color: Colors.white, size: 28),
                    ],
                  ),
                ),
                child: Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            const Color(0xFF4F46E5).withValues(alpha: 0.1),
                        child: Icon(icon, color: const Color(0xFF4F46E5)),
                      ),
                      title: Text(
                        med.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('Dosage: ${med.dosage} (${med.category})',
                              style: const TextStyle(fontSize: 13)),
                          Text('Notes: ${med.notes}',
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey)),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4F46E5)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              med.time,
                              style: const TextStyle(
                                color: Color(0xFF4F46E5),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Optional tap delete fallback for perfect accessibility
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.redAccent),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Delete Medication?'),
                                  content: Text(
                                      'Are you sure you want to remove ${med.name} reminders?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                        _deleteMedication(med);
                                      },
                                      child: const Text('Delete',
                                          style: TextStyle(
                                              color: Colors.redAccent)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
