/*
 * Course Module: Advanced Mobile Development (COM640)
 * Student Name: Hasini Piyumika
 * Student ID: 25026164
 * Project: MediTrack - Personal Health & Medication Reminder App
 * File: lib/screens/profile_screen.dart
 * Description: Profile Screen presenting registered student accounts in read-only form.
 */

import 'package:flutter/material.dart';
import 'package:meditrack_app/models/user.dart';

class ProfileScreen extends StatelessWidget {
  final User currentUser;
  const ProfileScreen({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Image / Avatar
            const Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Color(0xFF4F46E5),
                    child: Icon(Icons.person, size: 70, color: Colors.white),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.orange,
                      radius: 18,
                      child: Icon(Icons.lock,
                          size: 16,
                          color: Colors
                              .white), // Lock signifies read-only profile state
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              currentUser.username.toUpperCase(),
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937)),
            ),
            const Text(
              'Patient Account (Read-Only)',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 32),

            // Profile Detail Cards
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildProfileItem(
                      icon: Icons.person_outline,
                      title: 'Username',
                      value: currentUser.username,
                    ),
                    const Divider(),
                    _buildProfileItem(
                      icon: Icons.assignment_ind_outlined,
                      title: 'Student Name',
                      value: 'Hasini Piyumika',
                    ),
                    const Divider(),
                    _buildProfileItem(
                      icon: Icons.badge_outlined,
                      title: 'Student ID',
                      value: '25026164',
                    ),
                    const Divider(),
                    _buildProfileItem(
                      icon: Icons.school_outlined,
                      title: 'Course Module',
                      value: 'COM640 - Advanced Mobile Dev',
                    ),
                    const Divider(),
                    _buildProfileItem(
                      icon: Icons.help_center_outlined,
                      title: 'Recovery Question Answer',
                      value: currentUser.securityAnswer,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Informational Banner explaining editing limits
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                border: Border.all(color: Colors.amber[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.amber[800]),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Information: Profile details and assignments are compiled as read-only to guarantee static academic evaluation criteria.',
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Row builder for card records
  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4F46E5), size: 24),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
