import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

import 'package:campushub/screens/profile_screen.dart';
import 'package:campushub/services/auth_service.dart';
import 'package:campushub/models/listing_model.dart';
import 'package:campushub/services/firestore_service_interface.dart';
import 'package:campushub/services/user_profile_service_interface.dart';

// fake firestore
class FakeFirestoreService implements FirestoreServiceInterface {
  final List<ListingModel> listings;

  FakeFirestoreService(this.listings);

  @override
  Stream<List<ListingModel>> getUserListings(String uid) {
    return Stream.value(listings);
  }

  @override
  Future<void> deleteListing(String docId) async {}
}

// fake profile service
class FakeProfileService implements UserProfileServiceInterface {
  @override
  Future<String?> getProfileImageUrl(String uid) async => null;

  @override
  Future<void> saveProfileImageUrl(String uid, String url) async {}

  @override
  Future<String> uploadProfilePicture(file, uid) async => '';
}


Widget makeWidget({required List<ListingModel> listings}) {
  final mockAuth = MockFirebaseAuth(
    signedIn: true,
    mockUser: MockUser(
      uid: '123',
      email: 'john@test.com',
    ),
  );

  final authService = AuthService(auth: mockAuth);

  return MaterialApp(
    home: ProfileScreen(
      authService: authService,
      firestoreService: FakeFirestoreService(listings),
      profileService: FakeProfileService(),
    ),
  );
}

void main() {

  //Test 1: check if UI renders
  testWidgets('renders profile screen with listings', (tester) async {
    await tester.pumpWidget(makeWidget(listings: [
      ListingModel(
        id: '1',
        title: 'Laptop for sale',
        description: 'Good condition',
        price: '500',
        category: 'Electronics',
        contact: '123456',
        imageUrl: '',
        sellerName: 'John',
        sellerEmail: 'john@test.com',
        userId: '123',
      ),
    ]));

    await tester.pumpAndSettle();

    expect(find.text('My Listings'), findsOneWidget);
    expect(find.text('Laptop for sale'), findsOneWidget);
    expect(find.text('john@test.com'), findsOneWidget);
    expect(find.byIcon(Icons.logout), findsOneWidget);
  });

  //Test 2: check empty state
  testWidgets('shows empty state when no listings', (tester) async {
    await tester.pumpWidget(makeWidget(listings: []));

    await tester.pumpAndSettle();

    expect(find.text('No Listings yet'), findsOneWidget);
  });

  // Test 3: check logout button exists and is clickable
  testWidgets('logout button is present and tappable', (tester) async {
    await tester.pumpWidget(makeWidget(listings: []));

    await tester.pumpAndSettle();

    final logoutBtn = find.byIcon(Icons.logout);
    expect(logoutBtn, findsOneWidget);

    await tester.tap(logoutBtn);
    await tester.pumpAndSettle();
  });

  // Test 4: check delete button exists
  testWidgets('delete icon appears for listings', (tester) async {
    await tester.pumpWidget(makeWidget(listings: [
      ListingModel(
        id: '1',
        title: 'Laptop for sale',
        description: 'Good condition',
        price: '500',
        category: 'Electronics',
        contact: '123456',
        imageUrl: '',
        sellerName: 'John',
        sellerEmail: 'john@test.com',
        userId: '123',
      ),
    ]));

    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.delete), findsWidgets);
  });
}