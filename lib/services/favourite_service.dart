import 'package:cloud_firestore/cloud_firestore.dart';
import 'interfaces/favourite_service_interface.dart';

class FavouriteService implements FavouriteServiceInterface {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add or remove a listing from user's favourites (toggle behaviour)
  Future<void> toggleFavourites(String userId, String listingId) async {
    final userRef = _firestore.collection('users').doc(userId);
    final doc = await userRef.get();

    // If user document does not exist, create it with empty favourites list
    if (!doc.exists){
      await userRef.set({'favourites': [],
      });
    }

    final data = doc.data();

    List favourites = data?['favourites'] ?? [];

    // if listing already exists in favourites, remove it
    // if it doesn't then add it
    if (favourites.contains(listingId)) {
      favourites.remove(listingId);
    } else {
      favourites.add(listingId);
    }
    // Save updated favourites list back to Firestore
    await userRef.set({'favourites': favourites}, SetOptions(merge: true));
  }

  // Retrieve list of favourite listing IDs for a user
  Future<List<String>> getFavourites(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();

    return List<String>.from(doc.data()?['favourites'] ?? []);
  }
}