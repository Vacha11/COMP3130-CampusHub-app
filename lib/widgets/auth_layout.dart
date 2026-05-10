import 'package:flutter/material.dart';

class AuthLayout extends StatelessWidget {
  final Widget child;

  const AuthLayout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      body: Stack(
        children: [
          // bottom gradient branding bar
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 75,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFD6001C),
                    Color(0xFFA6192E),
                    Color(0xFF76232F),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}