import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'interfaces/user_profile_service_interface.dart';
import 'package:flutter/foundation.dart';

class UserProfileService implements UserProfileServiceInterface {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  UserProfileService({
    required this.firestore,
    required this.storage,
  });

  // upload profile picture to Firebase Storage and return the download URL
  Future<String> uploadProfilePicture(XFile imageFile, String uid) async {
    final storageref = storage
      .ref()
      .child('profile_pictures/$uid/profile.jpg');  // stores profile image under a user-specific folder for secure access control

    if(kIsWeb){
      // Web: use bytes
      final bytes = await imageFile.readAsBytes();
      await storageref.putData(bytes);
    } else {
      // Mobile: use File
      final file = File(imageFile.path);
      await storageref.putFile(file);
    }
    final downloadURL = await storageref.getDownloadURL();
    return downloadURL;
  }

  // save profile image url in Firestore
  Future<void> saveProfileImageUrl(String uid, String imageUrl) async {
    await firestore.collection('users').doc(uid).set({
      'profileImageUrl': imageUrl,
    }, SetOptions(merge: true)); // merge to avoid overwriting other fields
  }

  // get profile image url from Firestore
  Future<String?> getProfileImageUrl(String uid) async {
    final doc = await firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null; 
    
    return doc.data()?['profileImageUrl'];
  }
      
}