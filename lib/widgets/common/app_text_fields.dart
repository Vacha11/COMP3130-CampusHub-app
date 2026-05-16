import 'package:flutter/material.dart';

// Provides consistent UI for inputs like title, price, contact, description
class AppTextField extends StatelessWidget {
  final TextEditingController controller; // Controller to manage and read input text
  final String hint; 
  final bool obscureText; // Whether the text should be hidden (used for passwords if needed)
  final int maxLines;
  final TextInputType? keyboardType; // Keyboard type (number, email, text, etc.)

  const AppTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        // Background styling
        filled: true,
        fillColor: Colors.white,
        // Padding inside the input box
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        // Default border (inactive state)
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFEDEBE5)),
        ),
        // Border when enabled but not focused
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFEDEBE5)),
        ),
        // Border when field is active/focused
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFFA6192E),
            width: 2,
          ),
        ),
      ),
    );
  }
}