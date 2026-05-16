import 'package:firebase_auth/firebase_auth.dart';
import 'interfaces/auth_service_interface.dart';

class AuthService implements AuthServiceInterface {
  final FirebaseAuth _auth;

  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  // Returns the currently signed-in user
  User? get currentUser => _auth.currentUser;

  // Register a new user account using email and password
  Future<User?> signUp(String email, String password, String name) async {
    try {
      // Create Firebase user account
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Save user's display name
      await userCredential.user?.updateDisplayName(name);
      // Refresh user data to apply updated display name
      await userCredential.user?.reload();

      return _auth.currentUser;
    } catch (e) {
      print('Error signing up: $e');
      return null;
    }
  }

  // Sign in an existing user
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  // Sign out the currently logged-in user
  Future<void> signOut() async {
    await _auth.signOut();
  }
}