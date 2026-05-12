import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:campushub/services/favourite_service_interface.dart';

class FavouriteProvider extends ChangeNotifier {
  final FavouriteServiceInterface favouriteService;
  final FirebaseAuth auth;

  FavouriteProvider({
    required this.favouriteService,
    required this.auth,
  });
  
  List<String> favouriteIds = []; // List to store the IDs of favourite listings

  // Load the favourite listing IDs for the current user
  Future<void> loadFavourites() async {
    final user = auth.currentUser;
    if (user == null) return; 
    favouriteIds = await favouriteService.getFavourites(user.uid); // Load the favourite listing IDs for the current user
    notifyListeners(); // Notify listeners to update the UI
  }

  // Toggle the favourite status of a listing for the current user
  Future<void> toggleFavourite(String listingId) async {
    final user = auth.currentUser;
    if (user == null) return; 
    await favouriteService.toggleFavourites(user.uid, listingId);

    if (favouriteIds.contains(listingId)) {
      favouriteIds.remove(listingId); // Remove from favourites if it's already a favourite
    } else {
      favouriteIds.add(listingId); // Add to favourites if it's not already a favourite
    }
    notifyListeners(); 
  }

  // Check if a listing is in the user's favourites
  bool isFavourite(String listingId) {
    return favouriteIds.contains(listingId); 
  }
}