import 'package:campushub/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:campushub/services/auth_service.dart';
import 'package:campushub/widgets/common/app_text_fields.dart';
import 'package:campushub/widgets/common/app_label.dart';
import 'package:campushub/widgets/auth/auth_layout.dart';
import 'package:campushub/widgets/auth/auth_header.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers for email and password input fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Instance of the authentication service to handle login
  final AuthService _authService = AuthService();

  // Track whether a login request is currently in progress
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginUser() async {
    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    // Attempt sign in through the authentication service
    final user = await _authService.signIn(email, password);

    setState(() {
      _isLoading = false;
    });
    // If login is successful, navigate to the home screen
    if (user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      // Show error message if authentication fails
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Login failed. Please check your credentials and try again.",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // call reusable AuthLayout page styling created
    return AuthLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children:[
          const SizedBox(height:30),

          // App logo and branding section
          const AuthHeader(),
          const SizedBox(height: 20), 

          // Email input field
          const AppLabel(text: "Email"),
          const SizedBox(height:8),
          AppTextField(
            controller: _emailController, 
            hint: "Enter Email"
          ),
          const SizedBox(height: 30),

          // Password input field
          const AppLabel(text: "Password"),
          const SizedBox(height:8),
          AppTextField(
            controller: _passwordController, 
            hint: "Enter Password",
            obscureText: true,
          ),
          const SizedBox(height: 40),

          // Login button that authenticates users with Firebase
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              // When the login button is pressed, attempt to sign in with the provided email and password
              onPressed: _isLoading ? null : _loginUser,

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA6192E), // red
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14), // button padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), 
                ),
              ),
              child: _isLoading ? const CircularProgressIndicator(color: Colors.white) 
              : const Text(
                "Log In",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: "WorkSans",
                ),
              ),
                      
            ),
          ),
        ],
      ),
    );
  }
}