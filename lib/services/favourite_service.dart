import 'package:cloud_firestore/cloud_firestore.dart';

class FavouriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> toggleFavourites(String userId, String listingId) async {
    final userRef = _firestore.collection('users').doc(userId);
    final doc = await userRef.get();

    if (!doc.exists){
      await userRef.set({'favourites': [],
      });
    }

    final data = doc.data();

    List favourites = data?['favourites'] ?? [];

    if (favourites.contains(listingId)) {
      favourites.remove(listingId);
    } else {
      favourites.add(listingId);
    }
    await userRef.set({'favourites': favourites}, SetOptions(merge: true));
  }

  Future<List<String>> getFavourites(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();

    return List<String>.from(doc.data()?['favourites'] ?? []);
  }
}