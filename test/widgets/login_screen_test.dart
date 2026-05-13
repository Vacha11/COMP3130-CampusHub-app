import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:campushub/screens/login_screen.dart';
import 'package:campushub/services/auth_service.dart';
import 'package:campushub/services/user_profile_service_interface.dart';

class FakeProfileService implements UserProfileServiceInterface {
  @override
  Future<String?> getProfileImageUrl(String uid) async => null;

  @override
  Future<void> saveProfileImageUrl(String uid, String url) async {}

  @override
  Future<String> uploadProfilePicture(file, uid) async => '';
}

void main() {
  // Test 1: check UI renders

  testWidgets('LoginScreen renders and accepts input', (tester) async {

    // Fake Firebase auth (no real backend)
    final mockAuth = MockFirebaseAuth();

    // Inject mock into service
    final authService = AuthService(auth: mockAuth);

    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(authService: authService,profileService: FakeProfileService()),
      ),
    );

    await tester.pumpAndSettle();

    // Check branding/logo renders
    expect(find.byType(Image), findsOneWidget);

    // Check branding text
    expect(find.text('CampusHub'), findsOneWidget);

    // Check UI elements
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
  });

  // Test 2: Check if user can input credentials in textfield
  testWidgets('User can enter login credentials', (tester) async {

    final mockAuth = MockFirebaseAuth();
    final authService = AuthService(auth: mockAuth);

    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(authService: authService,profileService: FakeProfileService(),),
      ),
    );

    await tester.pumpAndSettle();

    // Enter text
    await tester.enterText(find.byType(TextField).at(0), 'test@test.com');
    await tester.enterText(find.byType(TextField).at(1), 'password123');

    // Verify input
    expect(find.text('test@test.com'), findsOneWidget);
  });
}