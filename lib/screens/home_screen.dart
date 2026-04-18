import 'package:campushub/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:campushub/widgets/search_bar.dart';
import 'package:campushub/widgets/category_tabs.dart';
import 'package:campushub/widgets/listing_card.dart';
import 'package:campushub/services/firestore_service.dart';
import 'addlisting_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int bottomIndex = 0; // State variable to track the currently selected index of the bottom navigation bar
  int categoryIndex = 0; // State variable to track the currently selected index of the category tabs
  final FirestoreService _firestoreService = FirestoreService(); // Instance of the FirestoreService to interact with Firestore database

  Widget _buildPage() {
  if (bottomIndex == 0) {
    return Padding(
      padding: const EdgeInsets.all(16),
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30), // Spacing at the top of the home screen
          SearchBarWidget(), // Custom search bar widget for searching content on the home screen
          SizedBox(height: 20), // Spacing between the search bar and the main content
          CategoryTabSelector(
            selectedIndex: categoryIndex, 
            onTabSelected: (index){
              setState(() {
                categoryIndex = index; // Update the selected category index when a tab is selected
              });
            },
          ),
          SizedBox(height:10), // Custom category tab selector widget for filtering content by category
          Expanded(
            child:StreamBuilder<QuerySnapshot>(
              stream:_firestoreService.getListings(), // StreamBuilder to listen to real-time updates from the Firestore database for listings
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator()); // Display a loading indicator while waiting for data from Firestore
                }

                if (snapshot.hasError){
                  return const Center(child: Text("Error loading listings")); // Display an error message if there is an issue loading the listings from Firestore
                }

                final listings = snapshot.data!.docs; // Get the list of listings from the Firestore snapshot

                if (listings.isEmpty){
                  return const Center(child: Text("No listings available")); // Display a message if there are no listings available in Firestore
                }

                return ListView.builder(
                  itemCount: listings.length, // Set the number of items in the list to the number of listings retrieved from Firestore
                  itemBuilder: (context, index){
                    final listing = listings[index].data() as Map<String, dynamic>; // Get the data for each listing and cast it to a Map
                    return ListingCard(
                      title: listing['title'] ?? 'No Title', // Display the title of the listing or a default message if the title is not available
                      price: listing['price'] ?? 'No Price', // Display the price of the listing or a default message if the price is not available
                    );
                  },
                );
              },
            ),
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