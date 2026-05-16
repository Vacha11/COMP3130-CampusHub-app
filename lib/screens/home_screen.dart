import 'package:campushub/services/interfaces/firestore_service_interface.dart';
import 'package:flutter/material.dart';
import 'addlisting_screen.dart';
import 'package:provider/provider.dart';
import 'package:campushub/providers/favourite_provider.dart';
import 'package:campushub/widgets/home/home_content.dart';
import 'package:campushub/services/interfaces/user_profile_service_interface.dart';
import 'package:campushub/services/interfaces/auth_service_interface.dart';

class HomeScreen extends StatefulWidget {
  final FirestoreServiceInterface firestoreService;
  final AuthServiceInterface authService;
  final UserProfileServiceInterface profileService;

  const HomeScreen({super.key, required this.firestoreService,required this.authService,required this.profileService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Track which bottom navigation tab is selected (Home / Favourites / Profile)
  int bottomIndex = 0; 

  // Track which category is selected for listings (All / Items / Services)
  int categoryIndex = 0;

  // Stores search input for filtering listings in real time
  String searchQuery = ""; 

  @override
  void initState(){
    super.initState();
    // Load the user's favourite listings when the home screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider =
        Provider.of<FavouriteProvider>(context, listen: false);
      provider.loadFavourites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      // Main dynamic body controlled by bottom navigation state
      body: HomeContent(
        firestoreService: widget.firestoreService,
        authService: widget.authService,
        profileService: widget.profileService,
        bottomIndex: bottomIndex, 
        categoryIndex: categoryIndex, 
        searchQuery: searchQuery, 
        // Callback: updates category filter when user taps tabs
        onCategoryChanged: (index) {
          setState(() => categoryIndex = index);
        }, 
        // Callback: updates search filter in real time
        onSearchChanged: (value) {
          setState(() => searchQuery = value);
        },
      ),

      // Bottom navigation bar controlling main app sections
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            // subtle elevation effect for modern UI feel
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: bottomIndex, 
          // updates screen based on tab selection
          onTap: (index){
            setState(() {
              bottomIndex = index; 
            });
          },
          selectedItemColor: const Color(0xFFA6192E),
          unselectedItemColor: const Color(0xFF373A36).withOpacity(0.6),
          backgroundColor: Colors.white,
          elevation:0,
          // Main app navigation structure
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

      // Floating action button only shown on Home + Profile screens
      floatingActionButton: (bottomIndex == 0 || bottomIndex == 2) ? SizedBox(
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
      )
      :null,

      // centers button above bottom navigation
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    ); 
  }
}