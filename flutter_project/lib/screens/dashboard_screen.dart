/*
 * Course Module: Advanced Mobile Development (COM640)
 * Student Name: Hasini Piyumika
 * Student ID: 25026164
 * Project: MediTrack - Personal Health & Medication Reminder App
 * File: lib/screens/dashboard_screen.dart
 * Description: Dashboard showing calendar date, circular water intake percentage meter, 
 *              dynamic "Today's Medications" overview lists, and Drawer navigation menus.
 */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_percent_indicator/flutter_percent_indicator.dart';
import 'package:meditrack_app/database/database_helper.dart';
import 'package:meditrack_app/models/user.dart';
import 'package:meditrack_app/models/medication.dart';
import 'package:meditrack_app/screens/add_medication_screen.dart';
import 'package:meditrack_app/screens/medication_list_screen.dart';
import 'package:meditrack_app/screens/profile_screen.dart';
import 'package:meditrack_app/screens/about_screen.dart';
import 'package:meditrack_app/screens/help_screen.dart';
import 'package:meditrack_app/screens/login_screen.dart';

class DashboardScreen extends StatefulWidget {
  final User currentUser;
  const DashboardScreen({super.key, required this.currentUser});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _waterGlasses = 0;
  final int _waterGoal = 8;
  late String _currentDate;
  late Future<List<Medication>> _medicationsFuture;

  @override
  void initState() {
    super.initState();
    _currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _loadDailyWaterIntake();
    _refreshMedicationList();
  }

  // Load water data from local storage
  void _loadDailyWaterIntake() async {
    int glasses = await DatabaseHelper.instance.getWaterIntake(
      widget.currentUser.id!,
      _currentDate,
    );
    setState(() {
      _waterGlasses = glasses;
    });
  }

  // Increments / Updates water intake
  void _updateWaterIntake(int offset) async {
    int newCount = _waterGlasses + offset;
    if (newCount < 0) newCount = 0;
    if (newCount > 15) newCount = 15; // Set safe limit

    await DatabaseHelper.instance.updateWaterIntake(
      widget.currentUser.id!,
      _currentDate,
      newCount,
    );

    setState(() {
      _waterGlasses = newCount;
    });
  }

  // Fetch updated medication rows
  void _refreshMedicationList() {
    setState(() {
      _medicationsFuture =
          DatabaseHelper.instance.getMedicationsForUser(widget.currentUser.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    double waterPercentage = _waterGlasses / _waterGoal;
    if (waterPercentage > 1.0) waterPercentage = 1.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        title: const Text('MediTrack Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshMedicationList,
          )
        ],
      ),

      // Standard Navigation Menu System (Hamburger Drawer)
      drawer: NavigationDrawerWidget(
          currentUser: widget.currentUser,
          refreshDashboard: _refreshMedicationList),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Calendar Banner Header
            Card(
              elevation: 0,
              color: const Color(0xFF4F46E5).withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        color: Color(0xFF4F46E5), size: 28),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('EEEE, d MMMM yyyy')
                              .format(DateTime.now()),
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937)),
                        ),
                        const SizedBox(height: 4),
                        const Text('Keep track of your health updates daily',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Water Intake Tracker (Circular Percent Indicator)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      '💧 Daily Water Tracker',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937)),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Aim for 8 glasses of water every day to stay hydrated',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    CircularPercentIndicator(
                      radius: 80.0,
                      lineWidth: 12.0,
                      percent: waterPercentage,
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$_waterGlasses / $_waterGoal',
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4F46E5)),
                          ),
                          const Text('Glasses',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                      progressColor: Colors.blueAccent,
                      backgroundColor:
                          Colors.blueAccent.withValues(alpha: 0.15),
                      circularStrokeCap: CircularStrokeCap.round,
                      animateFromLastPercent: true,
                      animation: true,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton.filled(
                          onPressed: () => _updateWaterIntake(-1),
                          icon: const Icon(Icons.remove),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.blue[100],
                            foregroundColor: Colors.blue[800],
                          ),
                        ),
                        const SizedBox(width: 32),
                        IconButton.filled(
                          onPressed: () => _updateWaterIntake(1),
                          icon: const Icon(Icons.add),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.blue[100],
                            foregroundColor: Colors.blue[800],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Today's Medications List Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '💊 Today\'s Medications',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MedicationListScreen(
                            currentUser: widget.currentUser),
                      ),
                    ).then((_) => _refreshMedicationList());
                  },
                  child: const Text('View All',
                      style: TextStyle(
                          color: Color(0xFF4F46E5),
                          fontWeight: FontWeight.bold)),
                )
              ],
            ),
            const SizedBox(height: 8),

            // Dynamic SQL Loader using FutureBuilder
            FutureBuilder<List<Medication>>(
              future: _medicationsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFF4F46E5)));
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text('Error retrieving medication updates.'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          const Icon(Icons.check_circle_outline,
                              size: 48, color: Colors.grey),
                          const SizedBox(height: 12),
                          const Text('No medications scheduled for today!',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 4),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddMedicationScreen(
                                      currentUser: widget.currentUser),
                                ),
                              ).then((_) => _refreshMedicationList());
                            },
                            child: const Text('Add Medication'),
                          )
                        ],
                      ),
                    ),
                  );
                }

                // Render Medication schedules on cards
                final medications = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: medications.length > 3
                      ? 3
                      : medications
                          .length, // Cap items shown on home dashboard at 3
                  itemBuilder: (context, index) {
                    final med = medications[index];
                    IconData icon = Icons.medical_services;
                    if (med.category == 'Pill') icon = Icons.vaccines;
                    if (med.category == 'Syrup') icon = Icons.healing;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              const Color(0xFF4F46E5).withValues(alpha: 0.1),
                          child: Icon(icon, color: const Color(0xFF4F46E5)),
                        ),
                        title: Text(med.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                            '${med.dosage} • ${med.category} • ${med.notes}'),
                        trailing: Text(
                          med.time,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4F46E5)),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),

      // Floating shortcut button to instantly navigate to "Add Medication" screen
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    AddMedicationScreen(currentUser: widget.currentUser)),
          ).then((_) => _refreshMedicationList());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Global Drawer Component - Satisfies assignment menu routing conditions
class NavigationDrawerWidget extends StatelessWidget {
  final User currentUser;
  final VoidCallback refreshDashboard;

  const NavigationDrawerWidget({
    super.key,
    required this.currentUser,
    required this.refreshDashboard,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drawer Header Design block
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF4F46E5)),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Color(0xFF4F46E5)),
            ),
            accountName: Text(
              currentUser.username.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            accountEmail: const Text('Student ID: 25026164'),
          ),

          // Drawer Navigation Items list
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.dashboard_outlined,
                      color: Color(0xFF4F46E5)),
                  title: const Text('Dashboard'),
                  onTap: () {
                    Navigator.pop(context); // close drawer
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.medical_information_outlined,
                      color: Color(0xFF4F46E5)),
                  title: const Text('Medication List'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              MedicationListScreen(currentUser: currentUser)),
                    ).then((_) => refreshDashboard());
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.add_circle_outline,
                      color: Color(0xFF4F46E5)),
                  title: const Text('Add Medication'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              AddMedicationScreen(currentUser: currentUser)),
                    ).then((_) => refreshDashboard());
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.account_circle_outlined,
                      color: Color(0xFF4F46E5)),
                  title: const Text('My Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              ProfileScreen(currentUser: currentUser)),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading:
                      const Icon(Icons.help_outline, color: Color(0xFF4F46E5)),
                  title: const Text('Help & FAQs'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HelpScreen()),
                    );
                  },
                ),
                ListTile(
                  leading:
                      const Icon(Icons.info_outline, color: Color(0xFF4F46E5)),
                  title: const Text('About Academic Project'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AboutScreen()),
                    );
                  },
                ),
              ],
            ),
          ),

          // Drawer Footer Logout Section
          Container(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () {
                // Return safely to login screens
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[50],
                foregroundColor: Colors.red[700],
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
