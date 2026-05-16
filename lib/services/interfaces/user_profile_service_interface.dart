import 'package:image_picker/image_picker.dart';

abstract class UserProfileServiceInterface {
  Future<String> uploadProfilePicture(XFile file, String uid);
  Future<void> saveProfileImageUrl(String uid, String url);
  Future<String?> getProfileImageUrl(String uid);
}