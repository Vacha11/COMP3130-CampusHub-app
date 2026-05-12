import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // upload profile picture to Firebase Storage and return the download URL
  Future<String> uploadProfilePicture(File imageFile, String uid) async {
    final storageref = _storage
      .ref()
      .child('profile_pictures')
      .child('$uid.jpg'); // store as uid.jpg for easy retrieval
    await storageref.putFile(imageFile);
    final downloadURL = await storageref.getDownloadURL();
    return downloadURL;
  }

  // save profile image url in Firestore
  Future<void> saveProfileImageUrl(String uid, String imageUrl) async {
    await _firestore.collection('users').doc(uid).set({
      'profileImageUrl': imageUrl,
    }, SetOptions(merge: true)); // merge to avoid overwriting other fields
  }

  // get profile image url from Firestore
  Future<String?> getProfileImageUrl(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null; 
    
    return doc.data()?['profileImageUrl'];
  }
      
}