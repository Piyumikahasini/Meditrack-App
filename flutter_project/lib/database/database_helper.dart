/*
 * Course Module: Advanced Mobile Development (COM640)
 * Student Name: Hasini Piyumika
 * Student ID: 25026164
 * Project: MediTrack - Personal Health & Medication Reminder App
 * File: lib/database/database_helper.dart
 * Description: SQLite Database Helper utilizing the Singleton pattern. Handles schemas, user registration, 
 *              authentication, credential recovery, medication storage, and water tracking.
 */

import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:meditrack_app/models/user.dart';
import 'package:meditrack_app/models/medication.dart';

class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  // Getter with lazy-loading initialization
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize SQLite database connection in the secure system path
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'meditrack.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Set up relational tables on first execution
  Future<void> _onCreate(Database db, int version) async {
    // 1. Users Table for secure login
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        security_answer TEXT NOT NULL
      )
    ''');

    // 2. Medications Table linked with Foreign Keys to Users
    await db.execute('''
      CREATE TABLE medications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        dosage TEXT NOT NULL,
        category TEXT NOT NULL,
        time TEXT NOT NULL,
        notes TEXT,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // 3. Water Tracker Log Table to record intake on a per-day, per-user basis
    await db.execute('''
      CREATE TABLE water_log (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        log_date TEXT NOT NULL,
        glasses INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
  }

  // ==================== USER AUTHENTICATION METHODS ====================

  // Save new user details (Registration)
  Future<int> registerUser(User user) async {
    final db = await instance.database;
    try {
      return await db.insert('users', user.toMap());
    } catch (e) {
      // Username exists (UNIQUE constraint violated)
      return -1;
    }
  }

  // Validate credentials during Login. Returns User object if successful
  Future<User?> loginUser(String username, String password) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // Recover account password by verifying security questions (Forgot Password)
  Future<bool> verifySecurityAnswer(String username, String answer) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      columns: ['id'],
      where: 'username = ? AND security_answer = ?',
      whereArgs: [username, answer],
    );
    return result.isNotEmpty;
  }

  // Update password for verified user recovery flows
  Future<int> resetPassword(String username, String newPassword) async {
    final db = await instance.database;
    return await db.update(
      'users',
      {'password': newPassword},
      where: 'username = ?',
      whereArgs: [username],
    );
  }

  // ==================== MEDICATION OPERATIONS ====================

  // Add a medication record
  Future<int> insertMedication(Medication medication) async {
    final db = await instance.database;
    return await db.insert('medications', medication.toMap());
  }

  // Fetch all medications associated with a specific user ID
  Future<List<Medication>> getMedicationsForUser(int userId) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medications',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'time ASC',
    );
    return List.generate(maps.length, (i) {
      return Medication.fromMap(maps[i]);
    });
  }

  // Delete medication item (swipe to dismiss triggers this)
  Future<int> deleteMedication(int medId) async {
    final db = await instance.database;
    return await db.delete(
      'medications',
      where: 'id = ?',
      whereArgs: [medId],
    );
  }

  // ==================== WATER TRACKER OPERATIONS ====================

  // Get current water glasses logged for a user on a given date (formatted YYYY-MM-DD)
  Future<int> getWaterIntake(int userId, String date) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'water_log',
      columns: ['glasses'],
      where: 'user_id = ? AND log_date = ?',
      whereArgs: [userId, date],
    );

    if (maps.isNotEmpty) {
      return maps.first['glasses'] as int;
    }
    return 0; // Return zero if no log is found for the day
  }

  // Increment or update logged water intake glasses
  Future<void> updateWaterIntake(int userId, String date, int glasses) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'water_log',
      columns: ['id'],
      where: 'user_id = ? AND log_date = ?',
      whereArgs: [userId, date],
    );

    if (maps.isNotEmpty) {
      // Record exists, run standard update statement
      await db.update(
        'water_log',
        {'glasses': glasses},
        where: 'user_id = ? AND log_date = ?',
        whereArgs: [userId, date],
      );
    } else {
      // No log entries, initialize water log for the current day
      await db.insert('water_log', {
        'user_id': userId,
        'log_date': date,
        'glasses': glasses,
      });
    }
  }
}
