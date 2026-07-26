/*
 * Course Module: Advanced Mobile Development (COM640)
 * Student Name: Hasini Piyumika
 * Student ID: 25026164
 * Project: MediTrack - Personal Health & Medication Reminder App
 * File: lib/screens/about_screen.dart
 * Description: About Project Screen presenting the official Academic Declaration for the assignment.
 */

import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        title: const Text('About Project'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            // Decorative Header Logo/Banner
            const Center(
              child: Icon(
                Icons.school_outlined,
                size: 80,
                color: Color(0xFF4F46E5),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Academic Assignment',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const Text(
              'COM640 - Advanced Mobile Development',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),

            // Academic Submission Details Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Submission Metadata',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4F46E5),
                      ),
                    ),
                    const Divider(height: 24),
                    _buildMetaRow('Project Title', 'MediTrack App'),
                    _buildMetaRow('App Version', 'v1.0.0 (Release-Build)'),
                    _buildMetaRow('Student Name', 'Hasini Piyumika'),
                    _buildMetaRow('Student ID', '25026164'),
                    _buildMetaRow('Module Code', 'COM640'),
                    _buildMetaRow('Database Engine', 'SQLite (sqflite v2.3)'),
                    _buildMetaRow('Target OS', 'Android / iOS (Universal)'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Student Academic Declaration block
            Card(
              color: Colors.teal[50],
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Color(0xFF4F46E5), width: 1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.verified_user, color: Color(0xFF4F46E5)),
                        SizedBox(width: 8),
                        Text(
                          'Academic Declaration',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4F46E5),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      'I, Hasini Piyumika, hereby declare that the MediTrack application codebase, database schemas, and notifications schedules are entirely my own original work. No part of this submission has been copied or plagiarized from other sources, and all referenced libraries have been credited within the pubspec metadata file.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Submitted By: Hasini Piyumika\nStudent ID: 25026164',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Row formatter for metadata lists
  Widget _buildMetaRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
          ),
        ],
      ),
    );
  }
}
