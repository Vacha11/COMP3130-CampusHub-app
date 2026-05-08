import 'package:campushub/screens/favourites_screen.dart';
import 'package:campushub/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'addlisting_screen.dart';
import 'package:campushub/widgets/search_bar.dart';
import 'package:campushub/widgets/category_tabs.dart';
import 'package:campushub/widgets/listing_view.dart';
import 'package:provider/provider.dart';
import 'package:campushub/providers/favourite_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int bottomIndex = 0; // State variable to track the currently selected index of the bottom navigation bar
  int categoryIndex = 0;
  String searchQuery = ""; // State variable to track the current search query

  @override
  void initState(){
    super.initState();
    // Load the user's favourite listings when the home screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FavouriteProvider>(context, listen: false).loadFavourites();
    });
  }

  Widget _buildPage() {
  if (bottomIndex == 0) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const SizedBox(height: 40), // Spacing at the top of the home screen

        Material(
          elevation: 6,
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        Expanded(
          child: ListingsView(categoryIndex: categoryIndex,searchQuery: searchQuery),
        ),
      ],
    );
  } else if (bottomIndex == 1) {
    return const FavouritesScreen(); // Display "Favourites" text when the second tab is selected
  } else {
    return ProfileScreen(); // Display "Profile" text when the third tab is selected
  }


}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: _buildPage(), // Display the content based on the selected index
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: bottomIndex, // Set the current index of the bottom navigation bar
          onTap: (index){
            setState(() {
              bottomIndex = index; // Update the selected index when a navigation item is tapped
            });
          },
          selectedItemColor: const Color(0xFFA6192E),
          unselectedItemColor: const Color(0xFF373A36).withOpacity(0.6),
          backgroundColor: Colors.white,
          elevation:0,
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
      ),
      floatingActionButton: SizedBox(
        width: 150,
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddListingScreen()),
            );
          },
          backgroundColor: const Color(0xFFA6192E),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            "Add Listing",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    ); 
  }
}