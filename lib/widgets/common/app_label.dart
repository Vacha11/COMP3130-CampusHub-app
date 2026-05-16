import 'package:flutter/material.dart';

// Ensure consistent styling for field labels like "Title", "Price", etc.
class AppLabel extends StatelessWidget {
  final String text;

  const AppLabel({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'WorkSans',
        fontWeight: FontWeight.bold,
        fontSize: 15,
        color: Color(0xFF373A36),
      ),
    );
  }
}