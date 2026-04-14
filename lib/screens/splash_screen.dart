import 'package:flutter/material.dart';
import 'signup_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        // background gradient (use of MQ colours for branding)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFD6001C), // bright red
              Color(0xFFA6192E), // red
              Color(0xFF76232F), // deep red
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children:[
            // first background rectangle
            Positioned(
              top: 250,
              left: -300,
              child: Transform.rotate(
                angle: 0.8, // rotate for dynamic look
                child: Container(
                  width: 1000, 
                  height: 300, 
                  color: Colors.white.withOpacity(0.075),  
                ),
              ),
            ),

            // second background rectangle
            Positioned(
              top: 400,
              left: -300,
              child: Transform.rotate(
                angle: 0.8,
                child: Container(
                  width: 1000,
                  height: 300,
                  color: Colors.white.withOpacity(0.075),
                ),
              ),
            ),

            // logo and text
            Align(
              alignment: Alignment(0,-0.3),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:[
                  Image.asset(
                    'assets/images/lighthouse.png',
                    height:250,
                  ),

                  SizedBox(height:15),

                  Text(
                    'CampusHub', // app name
                    style: TextStyle(
                      fontSize: 40,
                      fontFamily: 'WorkSans',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  Text(
                    'Buy, Sell, Connect on Campus', // tagline
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'WorkSans',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              bottom: 60,
              left: 50,
              right: 50,
              child: ElevatedButton(
                onPressed:(){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // white button
                  foregroundColor: Color(0xFFD6001C), // red text
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // rounded corners
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), // button
                ),
                  child: const Text(
                    'Get Started',
                    style:TextStyle(
                      fontSize: 16,
                      fontFamily: 'WorkSans',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ),
            ),
          ],
        ),
      )
    );
  }
}