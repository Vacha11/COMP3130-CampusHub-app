import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _firstNameController = TextEditingController(); // Controller for first name input
  final TextEditingController _lastNameController = TextEditingController(); // Controller for last name input
  final TextEditingController _emailController = TextEditingController(); // Controller for email input
  final TextEditingController _passwordController = TextEditingController(); // 
  final AuthService _authService = AuthService(); // Initialize the authentication service

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [ 
          Container( // Background container with white color
            color:Colors.white
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container( // Decorative container at the bottom with a gradient background
              height: 75,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors:[
                    Color(0xFFD6001C), // bright red
                    Color(0xFFA6192E), // red
                    Color(0xFF76232F), // deep red
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:40),
            child: Column( // Main column containing the input fields and sign-up button
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height:120),
                Row(
                  children:[
                    Expanded(
                      child: _buildInputField(label:"First Name", controller: _firstNameController), // First name input field
                    ),
                    const SizedBox(width:12),
                    Expanded(
                      child: _buildInputField(label:"Last Name", controller: _lastNameController), // Last name input field
                    ),
                  ],
                ),
                // Spacing between the name fields and the email field
                const SizedBox(height:20), 
                _buildInputField(label:"Email", controller: _emailController), // Email input field
                const SizedBox(height:20),
                _buildInputField(label:"Password", controller: _passwordController, obscureText:true), // Password input field with obscured text
                const SizedBox(height:30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton( // Sign-up button
                    onPressed:() async {
                      String email = _emailController.text.trim(); 
                      String password = _passwordController.text.trim(); 
                      var user = await _authService.signUp(email, password); // Attempt to sign up the user with the provided email and password
                      if (user != null) { 
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Sign up successful!')), // Show success message if sign-up is successful
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar( 
                          const SnackBar(content: Text('Sign up failed. Please try again.')), // Show error message if sign-up fails
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA6192E), // red
                      padding: const EdgeInsets.symmetric(vertical: 14), // button padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), 
                      ),
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build input fields for the sign-up form
  Widget _buildInputField({required String label, required TextEditingController controller, bool obscureText = false }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        Text( // Label for the input field
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField( // Text field for user input
          controller: controller,
          obscureText: label == "password",
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

}