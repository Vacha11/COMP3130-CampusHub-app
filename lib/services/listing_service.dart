import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:campushub/services/firestore_service.dart';

class ListingService {
  final FirestoreService _firestoreService = FirestoreService();

  // upload new image if selected else reuse existing image if editing listing
  Future<String?> uploadListingImage(File? imageFile, String? existingUrl) async {
    if (imageFile != null) {
      return await _firestoreService.uploadImage(imageFile);
    }
    return existingUrl;
  }

  // Create or update listing
  Future<void> submitListing({
    required String? docId,
    required String title,
    required String description,
    required String price,
    required String category,
    required String contact,
    required String? imageUrl,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    //listing scheme stored in Firestore
    // also includes metadata for filtering, user ownership and display
    final data = {
      "title": title,
      "description": description,
      "price": price,
      "category": category,
      "contact": contact,
      "createdAt": Timestamp.now(),
      "userId": user?.uid,
      "sellerName": user?.displayName ?? user?.email ?? "Anonymous",
      "sellerEmail": user?.email,
      "imageUrl": imageUrl,
    };

    if (docId != null) {
      await _firestoreService.updateListing(docId, data);
    } else {
      await _firestoreService.addListing(data);
    }
  }
}