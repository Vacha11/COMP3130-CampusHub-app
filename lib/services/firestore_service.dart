import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addListing(Map<String, dynamic> listingData) async {
    try {
      await _db.collection('listings').add(listingData); // Add a new listing to the 'listings' collection in Firestore
    } catch (e) {
      print('Error adding listing: $e'); // Print an error message if there is an issue adding the listing
    }
  }
  
  
  Stream<QuerySnapshot> getListings() { // Read all listings
    return _db.collection('listings')
     .orderBy('createdAt', descending: true)
     .snapshots();
  }

  Stream<QuerySnapshot> getUserListings(String userID){ // Read user specific listings
    return _db.collection('listings')
      .where('userId', isEqualTo: userID)
      .snapshots();
  }
}