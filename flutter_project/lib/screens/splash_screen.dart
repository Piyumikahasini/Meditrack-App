/*
 * Course Module: Advanced Mobile Development (COM640)
 * Student Name: Hasini Piyumika
 * Student ID: 25026164
 * Project: MediTrack - Personal Health & Medication Reminder App
 * File: lib/screens/splash_screen.dart
 * Description: Splash Screen displaying an animated healthcare logo with a 2-second delayed transition.
 */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meditrack_app/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Transition timer for academic requirements (2-second delay)
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4F46E5), // Indigo background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Healthcare visual branding
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  )
                ],
              ),
              child: const Icon(
                Icons.health_and_safety,
                size: 80,
                color: Color(0xFF4F46E5), // Indigo color
              ),
            ),
            const SizedBox(height: 24),
            // Application Title
            const Text(
              'MediTrack',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your Personal Health Companion',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 48),
            // Circular Progress Indicator representing loading state
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
