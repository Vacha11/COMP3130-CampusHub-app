import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:campushub/screens/listing_detail_screen.dart';
import 'package:campushub/models/listing_model.dart';
import 'package:campushub/providers/favourite_provider.dart';
import '../fakes/favourite_fakes.dart';

Widget buildTestApp() {
  final favProvider = FavouriteProvider.test(
    favouriteService: FakeFavouriteService(),
    initialFavourites: [],
  );

  return MaterialApp(
    home: ChangeNotifierProvider<FavouriteProvider>.value(
      value: favProvider,
      child: ListingDetailScreen(
        docId: 'listing_1',
        listing: ListingModel(
          id: 'listing_1',
          title: 'Laptop for sale',
          description: 'A good laptop in working condition',
          price: '500',
          category: 'Item',
          contact: '0456724924',
          sellerName: 'Test User',
          imageUrl: null,
          sellerEmail: 'test@test.com',
          userId: 'test-user',
        ),
      ),
    ),
  );
}

void main() {
  //basic check to make sure screen loads
  testWidgets('ListingDetailScreen renders correctly', (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    expect(find.text('Laptop for sale'), findsOneWidget);
  });

  //make sure all important listing details are displayed on screen
  testWidgets('renders all listing details correctly', (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    expect(find.text('Laptop for sale'), findsOneWidget);
    expect(find.text('A good laptop in working condition'), findsOneWidget);
    expect(find.textContaining('500'), findsOneWidget);
    // category is shown in uppercase in the UI
    expect(find.text('ITEM'), findsOneWidget);
    expect(find.text('Test User'), findsOneWidget);
    expect(find.text('0456724924'), findsOneWidget);
  });

  // Test the favourite button toggle behaviour (off to on to off)
  testWidgets('Favourite button toggles correctly', (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    // initially off
    final favOff = find.byIcon(Icons.favorite_border);
    expect(favOff, findsOneWidget);

    // tap to turn ON
    await tester.tap(favOff);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite), findsOneWidget);

    // tap again to turn OFF
    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
  });
}