import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:campushub/models/listing_model.dart';
import 'firestore_service_interface.dart';

class FirestoreService implements FirestoreServiceInterface {
  final FirebaseFirestore db;
  FirestoreService({FirebaseFirestore? db}) : db = db ?? FirebaseFirestore.instance;

  // Add a new listing to Firestore with the provided listing data
  Future<void> addListing(Map<String, dynamic> listingData) async {
    try {
      await db.collection('listings').add(listingData); // Add a new listing to the 'listings' collection in Firestore
    } catch (e) {
      print('Error adding listing: $e'); // Print an error message if there is an issue adding the listing
    }
  }

  // Update an existing listing in Firestore based on the document ID and the new data
  Future<void> updateListing(String docId, Map<String, dynamic> data) async {
    await db.collection('listings').doc(docId).update(data);
  }

  // Delete a listing from Firestore based on the document ID
  Future<void> deleteListing(String docId) async{
    await db.collection('listings').doc(docId).delete();
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

  // Get a list of DocumentSnapshots for the listings that are in the user's favourites based on their IDs
  Future<List<DocumentSnapshot>> getFavouriteListings(List<String> ids) async {
    if (ids.isEmpty) return [];
    
    final querySnapshot = await db.collection('listings')
      .where(FieldPath.documentId, whereIn: ids)
      .get();

    return querySnapshot.docs;
  }
  
  // Read all listings
  Stream<List<ListingModel>>getListings() { // Read all listings
    return db.collection('listings')
     .orderBy('createdAt', descending: true)
     .snapshots()
     .map((snapshot){
        return snapshot.docs.map((doc) {
          return ListingModel.fromMap(
            doc.id,
            doc.data() as Map<String, dynamic>,
          );
        }).toList();
     });
  }
  // user specific listings
  Stream<List<ListingModel>> getUserListings(String userID){ // Read user specific listings
    return db.collection('listings')
      .where('userId', isEqualTo: userID)
      .snapshots()
      .map((snapshot){
        return snapshot.docs.map((doc) {
          return ListingModel.fromMap(
            doc.id,
            doc.data() as Map<String, dynamic>,
          );
        }).toList();
      });
  }

  // listing by category
  Stream<List<ListingModel>> getListingsByCategory(String category){
    if(category == 'All'){
      return getListings();
    }

    return db
      .collection('listings')
      .where('category', isEqualTo: category)
      .orderBy('createdAt', descending:true)
      .snapshots()
      .map((snapshot){
        return snapshot.docs.map((doc) {
          return ListingModel.fromMap(
            doc.id,
            doc.data() as Map<String, dynamic>,
          );
        }).toList();
      });
  }

  Stream<List<ListingModel>> searchListings(String query){
    return db
      .collection('listings')
      .orderBy('title')
      .startAt([query])
      .endAt([query + '\uf8ff'])
      .snapshots()
      .map((snapshot){
        return snapshot.docs.map((doc) {
          return ListingModel.fromMap(
            doc.id,
            doc.data() as Map<String, dynamic>,
          );
        }).toList();
      });
  }
}