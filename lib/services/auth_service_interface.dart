import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthServiceInterface {
  User? get currentUser;

  Future<User?> signUp(String email, String password, String name);
  Future<User?> signIn(String email, String password);
  Future<void> signOut();
}