import 'package:flutter/material.dart';
import 'package:campushub/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService(); // Instance of the AuthService to handle authentication-related operations
  final User? _currentUser = FirebaseAuth.instance.currentUser; // Get the currently authenticated user from FirebaseAuth
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _currentUser?.email?.split('@')[0] ?? 'User', // Display the username (part of the email before '@') or 'User' if email is not available
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Styling for the username text
            ),
            
            const SizedBox(height: 10), // Spacing between the username and email

            Text(
              _currentUser?.email ?? 'No email', // Display the user's email or 'No email' if email is not available
              style: TextStyle(fontSize: 16, color: Colors.grey), // Styling for the email text
            ),

            const SizedBox(height: 30), // Spacing between the email and the logout button
            ElevatedButton(
              onPressed: () async {
                await _authService.signOut(); // Call the signOut method from AuthService to log the user out
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()), // Navigate to the LoginScreen after logging out
                );
              },
              child: const Text("Logout"), // Text for the logout button
            ),
          ],
        ),  
      ),
    );
  }
}