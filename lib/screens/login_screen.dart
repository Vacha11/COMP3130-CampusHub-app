import 'package:campushub/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:campushub/services/auth_service.dart';
import 'package:campushub/widgets/app_text_fields.dart';
import 'package:campushub/widgets/app_label.dart';

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
    // login screen UI for user authentication
    return Scaffold(
       backgroundColor: const Color(0xFFF7F7F7),
      body: Stack(
        children: [
          // Decorative gradient footer matching the app branding
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
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children:[
                const SizedBox(height:80),
                // App logo and branding section
                Row(
                  children: [
                    Image.asset(
                      "assets/images/lighthouse.png", 
                      height: 30,
                      color: const Color(0xFFA6192E),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const[
                        Text(
                          "CampusHub",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'WorkSans',
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFA6192E), // red
                          ),
                        ),
                            
                        Text(
                          "Buy, Sell, Connect",
                          style: TextStyle(
                            fontSize: 8,
                            fontFamily: 'WorkSans',
                            color: Color(0xFFA6192E), // red
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    // to do
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Color(0xFFA6192E), // red
                      fontSize: 14,
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
}