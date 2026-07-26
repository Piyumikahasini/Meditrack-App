/*
 * Course Module: Advanced Mobile Development (COM640)
 * Student Name: Hasini Piyumika
 * Student ID: 25026164
 * Project: MediTrack - Personal Health & Medication Reminder App
 * File: lib/screens/help_screen.dart
 * Description: Help and FAQ Screen using Flutter ExpansionTiles to provide interactive help articles.
 */

import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        title: const Text('Help & FAQs'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            // Help Icon Header
            const Center(
              child: Icon(
                Icons.support_agent_outlined,
                size: 80,
                color: Color(0xFF4F46E5),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'How can we help you?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const Text(
              'Find quick answers about schedules, notifications, and databases below.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),

            // Accordion FAQ Block
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    _buildFaqItem(
                      question: 'How do I add a new medication reminder?',
                      answer: 'Navigate to the "Add Medication" screen using either the floating "+" action button on the dashboard or the Navigation Drawer. Fill in the medicine name, dosage, category, select a reminder time, and click "Save Medication & Schedule Alarm" to activate your daily reminder.',
                    ),
                    const Divider(height: 1),
                    _buildFaqItem(
                      question: 'How do I delete or dismiss a medication?',
                      answer: 'Go to the "Medication List" screen from the drawer. You can either swipe any medication card from right to left to perform a "Swipe-To-Dismiss" deletion, or click on the red trash icon on the right side of the card to delete it. This will automatically erase the record from the SQLite database and cancel any registered system alarms.',
                    ),
                    const Divider(height: 1),
                    _buildFaqItem(
                      question: 'How does the water tracker progress work?',
                      answer: 'The dashboard features a circular progress ring representing your daily water intake. You can log water consumption by tapping the "+" button to add a glass or the "-" button to remove one. The app syncs this data in the "water_log" table in SQLite, and resets each day based on the calendar date.',
                    ),
                    const Divider(height: 1),
                    _buildFaqItem(
                      question: 'Will I receive alarms if the application is closed?',
                      answer: 'Yes! MediTrack uses "flutter_local_notifications" to register alarms directly within the Android or iOS operating system kernels. Your alarms will ring on time even if the app is suspended in the background or completely closed.',
                    ),
                    const Divider(height: 1),
                    _buildFaqItem(
                      question: 'Where is my medical and account data stored?',
                      answer: 'All data (users, scheduled medications, and water intake histories) is stored locally on your device in a secure SQLite file database ("meditrack.db"). This guarantees absolute privacy since no medical details are transmitted to external cloud servers.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Emergency / Support Info footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                border: Border.all(color: Colors.red[100]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
                      SizedBox(width: 8),
                      Text(
                        'Disclaimer & Emergency Notice',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent, fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'MediTrack is an academic prototype for assignment COM640. It is not intended for real-world critical clinical use. For critical medical concerns, always consult with certified healthcare professionals.',
                    style: TextStyle(fontSize: 11, color: Colors.black87, height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Interactive ExpansionTile generator representing FAQ accordions
  Widget _buildFaqItem({
    required String question,
    required String answer,
  }) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1F2937),
        ),
      ),
      iconColor: const Color(0xFF4F46E5),
      collapsedIconColor: Colors.grey,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          child: Text(
            answer,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
