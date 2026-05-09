import 'package:flutter/material.dart';
import 'package:campushub/screens/favourites_screen.dart';
import 'package:campushub/screens/profile_screen.dart';
import 'package:campushub/widgets/search_bar.dart';
import 'package:campushub/widgets/category_tabs.dart';
import 'package:campushub/widgets/listing_view.dart';

class homeContent extends StatelessWidget {
  final int bottomIndex;
  final int categoryIndex;
  final String searchQuery;
  final Function(int) onCategoryChanged;
  final Function(String) onSearchChanged;

  const homeContent({
    super.key,
    required this.bottomIndex,
    required this.categoryIndex,
    required this.searchQuery,
    required this.onCategoryChanged,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    // If user selects "Favourites" tab in bottom nav
    if (bottomIndex == 1) {
      return const FavouritesScreen();
    }

    // If user selects "Profile" tab in bottom nav
    if (bottomIndex == 2) {
      return const ProfileScreen();
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
          ),
        ),
      ],
    );
  }
}