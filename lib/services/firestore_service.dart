import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a new listing to Firestore with the provided listing data
  Future<void> addListing(Map<String, dynamic> listingData) async {
    try {
      await _db.collection('listings').add(listingData); // Add a new listing to the 'listings' collection in Firestore
    } catch (e) {
      print('Error adding listing: $e'); // Print an error message if there is an issue adding the listing
    }
  }

  // Update an existing listing in Firestore based on the document ID and the new data
  Future<void> updateListing(String docId, Map<String, dynamic> data) async {
    await _db.collection('listings').doc(docId).update(data);
  }

  // Delete a listing from Firestore based on the document ID
  Future<void> deleteListing(String docId) async{
    await _db.collection('listings').doc(docId).delete();
  }

  // Upload an image to Firebase Storage and return the download URL
  Future<String?> uploadImage(File image) async {
    try{
      final fileName = DateTime.now().millisecondsSinceEpoch.toString(); // Generate a unique filename based on the current timestamp

      final ref = FirebaseStorage.instance
        .ref()
        .child('listing_images')
        .child('$fileName.jpg'); // Create a reference to the location in Firebase Storage where the image will be stored

        await ref.putFile(image);

        return await ref.getDownloadURL();
    } catch (e){
      print('Error uploading image: $e');
      return null;
    }
  }
  
  // Read all listings
  Stream<QuerySnapshot> getListings() { // Read all listings
    return _db.collection('listings')
     .orderBy('createdAt', descending: true)
     .snapshots();
  }
  // user specific listings
  Stream<QuerySnapshot> getUserListings(String userID){ // Read user specific listings
    return _db.collection('listings')
      .where('userId', isEqualTo: userID)
      .snapshots();
  }

  // listing by category
  Stream<QuerySnapshot> getListingsByCategory(String category){
    if(category == 'All'){
      return getListings();
    }

    return _db
      .collection('listings')
      .where('category', isEqualTo: category)
      .orderBy('createdAt', descending:true)
      .snapshots();
  }

  Stream<QuerySnapshot> searchListings(String query){
    return _db
      .collection('listings')
      .orderBy('title')
      .startAt([query])
      .endAt([query + '\uf8ff'])
      .snapshots();
  }
}