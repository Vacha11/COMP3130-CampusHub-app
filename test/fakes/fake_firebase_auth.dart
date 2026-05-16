import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:campushub/services/interfaces/auth_service_interface.dart';

class FakeAuthService implements AuthServiceInterface {
  final MockUser _mockUser = MockUser(uid: "test-user");

  @override
  User? get currentUser => _mockUser;

  @override
  Future<User?> signIn(String email, String password) async {
    return _mockUser;
  }

  @override
  Future<User?> signUp(String email, String password, String name) async {
    return _mockUser;
  }

  @override
  Future<void> signOut() async {}
}