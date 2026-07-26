/*
 * Course Module: Advanced Mobile Development (COM640)
 * Student Name: Hasini Piyumika
 * Student ID: 25026164
 * Project: MediTrack - Personal Health & Medication Reminder App
 * File: lib/screens/forgot_password_screen.dart
 * Description: Forgot Password Screen verifying answer credentials and allowing SQLite password resets.
 */

import 'package:flutter/material.dart';
import 'package:meditrack_app/database/database_helper.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _securityAnswerController = TextEditingController();
  final _newPasswordController = TextEditingController();

  bool _isVerified = false; // Toggled after successfully answering security questions
  bool _isLoading = false;

  // Handle identity verification phase
  void _handleVerification() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final String username = _usernameController.text.trim();
      final String answer = _securityAnswerController.text.trim();

      bool isValid = await DatabaseHelper.instance.verifySecurityAnswer(username, answer);

      setState(() => _isLoading = false);

      if (isValid) {
        setState(() {
          _isVerified = true;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Identity verified! Please enter your new password below.'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Verification Failed. Incorrect username or answer.'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    }
  }

  // Handle password reset write phase
  void _handlePasswordReset() async {
    if (_newPasswordController.text.trim().length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final String username = _usernameController.text.trim();
    final String newPass = _newPasswordController.text;

    int rowsUpdated = await DatabaseHelper.instance.resetPassword(username, newPass);
    setState(() => _isLoading = false);

    if (rowsUpdated > 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password Reset Successful! Proceeding to Login.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Safe pop back to login state
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error updating password. Try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Reset Password'),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF1F2937),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Password Recovery',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
                ),
                const SizedBox(height: 8),
                Text(
                  _isVerified
                      ? 'Please choose a strong and memorable new password.'
                      : 'Verify your profile answers to configure new database credentials.',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 32),

                // USERNAME AND ANSWER FORM (Shown initially)
                if (!_isVerified) ...[
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF4F46E5)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Please enter your username';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Security Question: "What is your favorite pet\'s name?"',
                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _securityAnswerController,
                    decoration: InputDecoration(
                      labelText: 'Your Security Answer',
                      prefixIcon: const Icon(Icons.help_outline, color: Color(0xFF4F46E5)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Answer is required';
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleVerification,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Verify Identity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ]

                // RESET NEW PASSWORD FORM (Shown after identity validation success)
                else ...[
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF4F46E5)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handlePasswordReset,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Save New Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
