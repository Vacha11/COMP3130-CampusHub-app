import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addListing(Map<String, dynamic> listingData) async {
    try {
      await _db.collection('listings').add(listingData); // Add a new listing to the 'listings' collection in Firestore
    } catch (e) {
      print('Error adding listing: $e'); // Print an error message if there is an issue adding the listing
    }
  }

  Future<void> updateListing(String docId, Map<String, dynamic> data) async {
    await _db.collection('listings').doc(docId).update(data);
  }

  Future<void> deleteListing(String docId) async{
    await _db.collection('listings').doc(docId).delete();
  }

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