import 'package:campushub/services/interfaces/firestore_service_interface.dart';
import 'package:campushub/services/interfaces/user_profile_service_interface.dart';
import 'package:flutter/material.dart';
import 'package:campushub/screens/favourites_screen.dart';
import 'package:campushub/screens/profile_screen.dart';
import 'package:campushub/widgets/home/search_bar.dart';
import 'package:campushub/widgets/home/category_tabs.dart';
import 'package:campushub/widgets/listings/listing_view.dart';
import 'package:campushub/services/interfaces/auth_service_interface.dart';

// acts as the main point for the Home screen UI and switches between Home, Favourites, and Profile views based on bottom navigation.
class HomeContent extends StatelessWidget {
  final int bottomIndex; // Bottom navigation index (0 = Home, 1 = Favourites, 2 = Profile)
  final int categoryIndex; // Selected category tab index (All / Items / Services)
  final String searchQuery; // Current search input from user
  final Function(int) onCategoryChanged;
  final Function(String) onSearchChanged;
  // Service dependencies for data access
  final FirestoreServiceInterface firestoreService;
  final AuthServiceInterface authService;
  final UserProfileServiceInterface profileService;

  const HomeContent({
    super.key,
    required this.bottomIndex,
    required this.categoryIndex,
    required this.searchQuery,
    required this.onCategoryChanged,
    required this.onSearchChanged,
    required this.firestoreService,
    required this.authService,
    required this.profileService,
  });

  @override
  Widget build(BuildContext context) {
    // If user selects "Favourites" tab in bottom nav
    if (bottomIndex == 1) {
      return FavouritesScreen(firestoreService: firestoreService);
    }

    // If user selects "Profile" tab in bottom nav
    if (bottomIndex == 2) {
      return ProfileScreen(authService: authService,firestoreService: firestoreService,profileService: profileService);
    }

    // Default view = Home screen content
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),

        // Search + Category container card
        Material(
          elevation: 6,
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SearchBarWidget(
                  onChanged: onSearchChanged,
                ),

                const SizedBox(height: 20),

                CategoryTabSelector(
                  selectedIndex: categoryIndex,
                  onTabSelected: onCategoryChanged,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Listing results based on category + search filter
        Expanded(
          child: ListingsView(
            categoryIndex: categoryIndex,
            searchQuery: searchQuery,
            firestoreService: firestoreService,
            authService: authService,
          ),
        ),
      ],
    );
  }
}