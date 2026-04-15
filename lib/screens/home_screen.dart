import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int bottomIndex = 0; // State variable to track the currently selected index of the bottom navigation bar

  Widget _buildPage() {
  if (bottomIndex == 0) {
    return const Center(child: Text("Home")); // Display "Home" text when the first tab is selected
  } else if (bottomIndex == 1) {
    return const Center(child: Text("Favourites")); // Display "Favourites" text when the second tab is selected
  } else {
    return const Center(child: Text("Profile")); // Display "Profile" text when the third tab is selected
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPage(), // Display the content based on the selected index
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomIndex, // Set the current index of the bottom navigation bar
        onTap: (index){
          setState(() {
            bottomIndex = index; // Update the selected index when a navigation item is tapped
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}