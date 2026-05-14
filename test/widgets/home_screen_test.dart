import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:campushub/screens/home_screen.dart';
import '../fakes/fake_firebase_auth.dart';
import '../fakes/fake_firestore_service.dart';
import '../fakes/fake_profile_service.dart';
import '../helpers/test_wrappers.dart';

void main() {

  // Test 1: check basic rendering of home screen
  testWidgets('HomeScreen renders', (tester) async {
    await tester.pumpWidget(
      wrapWithFavProvider(
        child: HomeScreen(
          firestoreService: FakeFirestoreService(),
          authService: FakeAuthService(),
          profileService: FakeProfileService(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
  });

  // test 2: check bottom navigation is displayed
  testWidgets('bottom navigation is displayed', (tester) async {
    await tester.pumpWidget(
      wrapWithFavProvider(
        child: HomeScreen(
          firestoreService: FakeFirestoreService(),
          authService: FakeAuthService(),
          profileService: FakeProfileService(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });

  // test 3: ensure search bar is displayed
  testWidgets('search bar is visible', (tester) async {
    await tester.pumpWidget(
      wrapWithFavProvider(
        child: HomeScreen(
          firestoreService: FakeFirestoreService(),
          authService: FakeAuthService(),
          profileService: FakeProfileService(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
  });

 // test 4: make sure category tabs are rendered
  testWidgets('category tabs are shown', (tester) async {
    await tester.pumpWidget(
      wrapWithFavProvider(
        child: HomeScreen(
          firestoreService: FakeFirestoreService(),
          authService: FakeAuthService(),
          profileService: FakeProfileService(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.textContaining('All'), findsWidgets);
  });

  // test 5: Interaction test:
  // switch to profile tab and UI should update accordingly
  testWidgets('profile tab opens profile screen', (tester) async {
    await tester.pumpWidget(
      wrapWithFavProvider(
        child: HomeScreen(
          firestoreService: FakeFirestoreService(),
          authService: FakeAuthService(),
          profileService: FakeProfileService(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // tap profile tab
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    // verify profile content appears
    expect(find.textContaining('Profile'), findsWidgets);
  });
}