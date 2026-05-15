import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campushub/screens/addlisting_screen.dart';
import 'package:campushub/services/listing_service_interface.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

/// Fake service to avoid real Firebase calls during testing
class FakeListingService implements ListingServiceInterface {
  bool submitCalled = false;

  @override
  Future<String?> uploadListingImage(XFile? imageFile,Uint8List? imageBytes, String? existingUrl) async {
    return 'fake_image_url';
  }

  @override
  Future<void> submitListing({
    required String? docId,
    required String title,
    required String description,
    required String price,
    required String category,
    required String contact,
    required String? imageUrl,
  }) async {
    submitCalled = true;
  }
}

void main() {

  // Test 1: Screen renders correctly
  testWidgets('AddListingScreen renders all form fields', (tester) async {

    final fakeService = FakeListingService();

    await tester.pumpWidget(
      MaterialApp(
        home: AddListingScreen(
          listingService: fakeService,
        ),
      ),
    );

    // Check labels exist
    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Category'), findsOneWidget);
    expect(find.text('Price'), findsOneWidget);
    expect(find.text('Contact'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);

    // Check button exists
    expect(find.text('Post Listing'), findsOneWidget);
  });

  // Test 2: User can enter form input
  testWidgets('User can enter listing details', (tester) async {

    final fakeService = FakeListingService();

    await tester.pumpWidget(
      MaterialApp(
        home: AddListingScreen(
          listingService: fakeService,
        ),
      ),
    );

    // Enter text into fields
    await tester.enterText(
      find.byType(TextField).at(0),
      'MacBook Pro',
    );

    await tester.enterText(
      find.byType(TextField).at(1),
      '1500',
    );

    await tester.enterText(
      find.byType(TextField).at(2),
      '0412345678',
    );

    await tester.enterText(
      find.byType(TextField).at(3),
      'Good condition laptop',
    );

    // Verify entered text appears
    expect(find.text('MacBook Pro'), findsOneWidget);
    expect(find.text('1500'), findsOneWidget);
    expect(find.text('0412345678'), findsOneWidget);
    expect(find.text('Good condition laptop'), findsOneWidget);
  });

  // Test 3: Category selection changes UI
  testWidgets('User can switch category buttons', (tester) async {

    final fakeService = FakeListingService();

    await tester.pumpWidget(
      MaterialApp(
        home: AddListingScreen(
          listingService: fakeService,
        ),
      ),
    );

    // Tap Service category
    await tester.tap(find.text('Service'));

    await tester.pumpAndSettle();

    // Verify button still exists after interaction
    expect(find.text('Service'), findsOneWidget);
  });

  // Test 4: Validation snackbar appears for empty form
  testWidgets('Shows validation error when fields are empty', (tester) async {

    final fakeService = FakeListingService();

    await tester.pumpWidget(
      MaterialApp(
        home: AddListingScreen(
          listingService: fakeService,
        ),
      ),
    );

    // Scroll down to button
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -500),
    );

    await tester.pumpAndSettle();

    // Press submit without entering data
    await tester.tap(find.text('Post Listing'));

    await tester.pump();

    // Verify validation message
    expect(
      find.text('Please fill all required fields'),
      findsOneWidget,
    );
  });
}