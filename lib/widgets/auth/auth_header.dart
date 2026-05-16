import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      // App logo icon
      children: [
        Image.asset(
          "assets/images/lighthouse.png",
          height: 30,
          color: const Color(0xFFA6192E),
        ),

        const SizedBox(width: 10),

        // App name and tagline
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App title
            Text(
              "CampusHub",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFFA6192E),
                fontFamily: "WorkSans",
              ),
            ),
            //tagline
            Text(
              "Buy, Sell, Connect on Campus",
              style: TextStyle(
                fontSize: 8,
                color: Color(0xFFA6192E),
                fontFamily: "WorkSans",
              ),
            ),
          ],
        ),
      ],
    );
  }
}