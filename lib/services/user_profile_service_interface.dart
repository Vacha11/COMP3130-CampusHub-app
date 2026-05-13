import 'dart:io';

abstract class UserProfileServiceInterface {
  Future<String> uploadProfilePicture(File file, String uid);
  Future<void> saveProfileImageUrl(String uid, String url);
  Future<String?> getProfileImageUrl(String uid);
}