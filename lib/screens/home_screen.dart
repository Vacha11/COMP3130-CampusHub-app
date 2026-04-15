import 'package:flutter/material.dart';
import 'package:campushub/widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int bottomIndex = 0; // State variable to track the currently selected index of the bottom navigation bar

  Widget _buildPage() {
  if (bottomIndex == 0) {
    return Padding(
      padding: const EdgeInsets.all(16),
      
      child: Column(
        children: const [
          SizedBox(height: 30), // Spacing at the top of the home screen
          SearchBarWidget(), // Custom search bar widget for searching content on the home screen
          SizedBox(height: 20), // Spacing between the search bar and the main content
          Text("Home Screen Content"), // Placeholder for the main content of the home screen
        ],
      ),
    );
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
            icon: Icon(Icons.home), // Home icon for the first tab
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite), // Favorite icon for the second tab
            label: 'Favourite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Person icon for the third tab
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}