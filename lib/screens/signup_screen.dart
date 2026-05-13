import 'package:campushub/screens/login_screen.dart';
import 'package:campushub/widgets/auth/auth_layout.dart';
import 'package:flutter/material.dart';
import 'package:campushub/services/auth_service.dart';
import 'home_screen.dart';
import 'package:campushub/widgets/common/app_label.dart';
import 'package:campushub/widgets/common/app_text_fields.dart';
import 'package:campushub/widgets/auth/auth_header.dart';
import 'package:campushub/services/firestore_service.dart';
import 'package:campushub/services/user_profile_service_interface.dart';

// Screen for creating a new CampusHub account
class SignupScreen extends StatefulWidget {
  final AuthService authService;
  final UserProfileServiceInterface profileService;
  const SignupScreen({super.key, required this.authService,required this.profileService});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  late final AuthService _authService;

@override
void initState() {
  super.initState();
  _authService = widget.authService;
}

  // Controllers for managing user input fields
  final TextEditingController _firstNameController = TextEditingController(); 
  final TextEditingController _lastNameController = TextEditingController(); 
  final TextEditingController _emailController = TextEditingController(); 
  final TextEditingController _passwordController = TextEditingController(); 

  bool _isLoading = false;

  // Handle user sign up with Firebase Authentication
  Future<void> _signup() async {
    setState(() {
      _isLoading = true;
    });
    // Retrieve and clean input values
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();

    String name = "$firstName $lastName".trim(); // Combine first and last name

    String email = _emailController.text.trim(); 
    String password = _passwordController.text.trim(); 
    // Attempt to sign up the user with the provided email and password and name
    var user = await _authService.signUp(email, password, name);
    setState(() {
      _isLoading = false;
    });
    // Navigate to home screen if signup succeeds
    if (user != null) { 
      Navigator.pushReplacement( 
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(
          firestoreService: FirestoreService(),
          authService: widget.authService,
          profileService: widget.profileService,
          ),
        ),
      );
    } else {
      // Show error message if signup fails
      ScaffoldMessenger.of(context).showSnackBar( 
        const SnackBar(content: Text('Sign up failed. Please try again.')), // Show error message if sign-up fails
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height:30),
          const AuthHeader(),
          const SizedBox(height: 20), 
          // First + last name fields displayed side-by-side
          Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppLabel(text: "First Name"),
                    const SizedBox(height: 8),
                    AppTextField(
                      controller: _firstNameController,
                      hint: "First",
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppLabel(text: "Last Name"),
                    const SizedBox(height: 8),
                    AppTextField(
                      controller: _lastNameController,
                      hint: "Last",
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height:20),

          // Email field
          const AppLabel(text: "Email"),
          const SizedBox(height: 8),
          AppTextField(
            controller: _emailController,
            hint: "Enter Email",
          ),

          const SizedBox(height: 20),

          // Password field
          const AppLabel(text: "Password"),
          const SizedBox(height: 8),
          AppTextField(
            controller: _passwordController,
            hint: "Enter Password",
            obscureText: true,
          ),

          const SizedBox(height:20),

          // Signup button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton( // Sign-up button
              onPressed: _isLoading ? null : _signup,
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
                "Sign Up",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "WorkSans",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          Column(
            children: [
              Center(
                // Navigation prompt for existing users
                child: Text(
                  "Already have an account?",
                ),
              ),
            ],
          ),
          Center(
            child: TextButton(
              // Navigate to login screen if existing user
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(
                      authService: _authService,
                      profileService: widget.profileService,
                    ),
                  ),
                );
              },
              child: const Text(
                "Log In",
                style: TextStyle(
                  color: Color(0xFFA6192E),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}