import 'package:campushub/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'addlisting_screen.dart';
import 'package:campushub/widgets/search_bar.dart';
import 'package:campushub/widgets/category_tabs.dart';
import 'package:campushub/widgets/listing_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int bottomIndex = 0; // State variable to track the currently selected index of the bottom navigation bar
  int categoryIndex = 0;
  String searchQuery = ""; // State variable to track the current search query

  Widget _buildPage() {
  if (bottomIndex == 0) {
    return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const SizedBox(height: 40), // Spacing at the top of the home screen

        SearchBarWidget(
          onChanged: (value){
            setState(() {
              searchQuery = value; // Update the search query state variable when the search input changes
            });
          },
        ),

        const SizedBox(height: 20), // Spacing between the search bar and category tabs

        CategoryTabSelector(
          selectedIndex: categoryIndex,
          onTabSelected: (index) {
            setState(() {
              categoryIndex = index;
            });
          },
        ),

        Expanded(
          child: ListingsView(categoryIndex: categoryIndex,searchQuery: searchQuery,),
        ),
      ],
    ),
  );
  } else if (bottomIndex == 1) {
    return const Center(child: Text("Favourites")); // Display "Favourites" text when the second tab is selected
  } else {
    return ProfileScreen(); // Display "Profile" text when the third tab is selected
  }


}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPage(), // Display the content based on the selected index
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children:[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:20, vertical:10),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddListingScreen()),
                  );
                },
                icon: const Icon(Icons.add), // Icon for the "Add Listing" button
                label: const Text("Add Listing", style:TextStyle(color: Colors.white)), // Label for the "Add Listing" button
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA6192E), // Red color for the
                  padding: const EdgeInsets.symmetric(vertical: 14), // Button padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners for the button
                  ),
                  elevation: 5, // Elevation for the button to give it a raised appearance
                ),
              ),
            ),
          ),

          BottomNavigationBar(
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
        ],
      ),
    ); 
  }
}