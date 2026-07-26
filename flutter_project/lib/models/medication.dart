/*
 * Course Module: Advanced Mobile Development (COM640)
 * Student Name: Hasini Piyumika
 * Student ID: 25026164
 * Project: MediTrack - Personal Health & Medication Reminder App
 * File: lib/models/medication.dart
 * Description: Data Model for Medication records containing names, dosage, category, schedules, and custom notes.
 */

class Medication {
  final int? id;
  final int userId; // Relational foreign key linked to the logged-in User
  final String name;
  final String dosage;
  final String category; // Dropdown value: Pill, Syrup, Injection, etc.
  final String time; // Stored as "HH:mm" for notification parsing
  final String notes;

  Medication({
    this.id,
    required this.userId,
    required this.name,
    required this.dosage,
    required this.category,
    required this.time,
    required this.notes,
  });

  // Convert a Medication object into a Map for SQLite database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'dosage': dosage,
      'category': category,
      'time': time,
      'notes': notes,
    };
  }

  // Create a Medication object from an SQLite query Map
  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      name: map['name'] as String,
      dosage: map['dosage'] as String,
      category: map['category'] as String,
      time: map['time'] as String,
      notes: map['notes'] as String,
    );
  }
}
