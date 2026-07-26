/*
 * Course Module: Advanced Mobile Development (COM640)
 * Student Name: Hasini Piyumika
 * Student ID: 25026164
 * Project: MediTrack - Personal Health & Medication Reminder App
 * File: lib/models/user.dart
 * Description: Data Model representing a Registered User in the system.
 */

class User {
  final int? id;
  final String username;
  final String password;
  final String securityAnswer; // Security question answer for Password Recovery

  User({
    this.id,
    required this.username,
    required this.password,
    required this.securityAnswer,
  });

  // Convert a User object into a Map for SQLite insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'security_answer': securityAnswer,
    };
  }

  // Extract a User object from an SQLite query Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      username: map['username'] as String,
      password: map['password'] as String,
      securityAnswer: map['security_answer'] as String,
    );
  }
}
