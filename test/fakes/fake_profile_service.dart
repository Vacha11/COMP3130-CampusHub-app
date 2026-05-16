import 'package:campushub/services/interfaces/user_profile_service_interface.dart';

class FakeProfileService implements UserProfileServiceInterface {
  @override
  Future<String?> getProfileImageUrl(String uid) async => null;

  @override
  Future<void> saveProfileImageUrl(String uid, String url) async {}

  @override
  Future<String> uploadProfilePicture(file, uid) async => '';
}