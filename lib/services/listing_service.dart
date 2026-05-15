import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:campushub/services/firestore_service.dart';
import 'listing_service_interface.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ListingService implements ListingServiceInterface {
  final FirestoreService _firestoreService;
  final FirebaseAuth _auth;

  ListingService({FirestoreService? firestoreService,FirebaseAuth? auth})
    : _firestoreService = firestoreService ?? FirestoreService(),
      _auth = auth ?? FirebaseAuth.instance;

  // upload new image if selected else reuse existing image if editing listing
  Future<String?> uploadListingImage(XFile? imageFile, Uint8List? imageBytes, String? existingUrl) async {
    if (imageFile == null && imageBytes == null) {
      return existingUrl;
    }

    final ref = FirebaseStorage.instance
      .ref()
      .child('listing_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
    
    if (imageBytes != null) {
      await ref.putData(imageBytes);
      return await ref.getDownloadURL();
    }

    final bytes = await imageFile!.readAsBytes();
    await ref.putData(bytes);
    return await ref.getDownloadURL();
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
    final user = _auth.currentUser;

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