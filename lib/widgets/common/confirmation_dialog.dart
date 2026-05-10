import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    required this.confirmText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFF7F7F7),

      title: Text(title),

      content: Text(content),

      actions: [
        // Cancel button
        TextButton(
          onPressed: () => Navigator.pop(context, false),

          child: const Text(
            "Cancel",

            style: TextStyle(
              color: Color(0xFF373A36),
            ),
          ),
        ),

        // Confirm action button
        TextButton(
          onPressed: () => Navigator.pop(context, true),

          child: Text(
            confirmText,

            style: const TextStyle(
              color: Color(0xFFA6192E),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}