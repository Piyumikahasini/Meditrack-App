/*
 * Course Module: Advanced Mobile Development (COM640)
 * Student Name: Hasini Piyumika
 * Student ID: 25026164
 * Project: MediTrack - Personal Health & Medication Reminder App
 * File: lib/main.dart
 * Description: The main entrance file initializing the Flutter application runtime, 
 *              setting up OS-level service hooks, and defining the global Material 3 theme.
 */

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meditrack_app/screens/splash_screen.dart';
import 'package:meditrack_app/services/notification_service.dart';

void main() async {
  // Ensure framework services are initialized prior to launching app components
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the local notification service (alarms)
  await NotificationService.instance.init();
  await NotificationService.instance.requestPermissions();

  runApp(const MediTrackApp());
}

class MediTrackApp extends StatelessWidget {
  const MediTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediTrack',
      debugShowCheckedModeBanner: false,

      // Global UI Theme Config matching Material 3 specifications
      theme: ThemeData(
        useMaterial3: true,

        // Modern healthcare primary color scheme (Indigo-based)
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5), // Indigo Primary
          primary: const Color(0xFF4F46E5),
          secondary: const Color(0xFF7C3AED), // Violet Accent
          surface: const Color(0xFFF7F9FB), // Off-White background
          onPrimary: Colors.white,
        ),

        // Elegant medical typography using Google Fonts (Poppins)
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),

        // Default design for Card layouts
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
        ),

        // AppBar global styling
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF4F46E5),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),

        // Floating action button styling
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF7C3AED),
          foregroundColor: Colors.white,
        ),
      ),

      // Redirect to Splash Screen (2-second logo display on startup)
      home: const SplashScreen(),
    );
  }
}
