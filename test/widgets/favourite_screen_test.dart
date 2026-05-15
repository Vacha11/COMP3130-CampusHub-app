import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:campushub/screens/favourites_screen.dart';
import 'package:campushub/providers/favourite_provider.dart';
import '../fakes/fake_firestore_service.dart';
import '../fakes/favourite_fakes.dart';
import 'package:campushub/screens/listing_detail_screen.dart';

Widget buildTestApp({
  required List<String> favouriteIds,
}) {
  final favouriteProvider = FavouriteProvider.test(
    favouriteService: FakeFavouriteService(),
    initialFavourites: favouriteIds,
  );

  return ChangeNotifierProvider<FavouriteProvider>.value(
    value: favouriteProvider,
    child: MaterialApp(
      home: FavouritesScreen(
        firestoreService: FakeFirestoreService(),
      ),
    ),
  );
}

void main() {

  // Test 1: check initial empty state message appears when no favourites
  testWidgets('shows empty message when no favourites exist',
      (tester) async {

    await tester.pumpWidget(
      buildTestApp(favouriteIds: []),
    );

    await tester.pumpAndSettle();

    expect(find.textContaining('No favourites yet'), findsOneWidget);
  });

  //Test 2: check favourite listing is displayed properly
  testWidgets('shows favourite listings correctly',
      (tester) async {

    await tester.pumpWidget(
      buildTestApp(
        favouriteIds: ['listing_1'],
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Laptop for sale'), findsOneWidget);
  });

  // Test 3: render screen header
  testWidgets('displays favourites header',
      (tester) async {

    await tester.pumpWidget(
      buildTestApp(
        favouriteIds: ['listing_1'],
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Your Favourites'), findsOneWidget);
  });

  //Test 4: listing card is tappable to open detail screen
  testWidgets('listing card can be tapped', (tester) async {
    await tester.pumpWidget(buildTestApp(favouriteIds: ['listing_1']));

    await tester.pumpAndSettle();

    // tap listing
    await tester.tap(find.text('Laptop for sale'));

    await tester.pumpAndSettle();

    // verify navigation happened
    expect(find.byType(ListingDetailScreen), findsOneWidget);

    // verify listing details are shown
    expect(find.text('Laptop for sale'), findsWidgets);
  });
}