import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:campushub/providers/favourite_provider.dart';
import 'package:campushub/services/interfaces/favourite_service_interface.dart';

// Fake service to avoid real Firestore usage in tests
class FakeFavouriteService implements FavouriteServiceInterface {

  List<String> fakeFavourites = [];

  @override
  Future<List<String>> getFavourites(String userId) async {
    return fakeFavourites;
  }

  @override
  Future<void> toggleFavourites(String userId, String listingId) async {
    if (fakeFavourites.contains(listingId)) {
      fakeFavourites.remove(listingId);
    } else {
      fakeFavourites.add(listingId);
    }
  }
}

void main() {

  group('FavouriteProvider Tests', () {

    late FavouriteProvider provider;
    late FakeFavouriteService fakeService;
    late MockFirebaseAuth mockAuth;

    setUp(() {

      // Fake logged in user
      mockAuth = MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(
          uid: '123',
          email: 'test@test.com',
        ),
      );

      // Fake Firestore service
      fakeService = FakeFavouriteService();

      // Provider using mocked dependencies
      provider = FavouriteProvider(
        favouriteService: fakeService,
        auth: mockAuth,
      );
    });

    // Test initial favourites list
    test('initial favourites list is empty', () {
      expect(provider.favouriteIds.isEmpty, true);
    });

    // Test loading favourites
    test('loadFavourites loads favourite IDs', () async {

      fakeService.fakeFavourites = ['item1', 'item2'];

      await provider.loadFavourites();

      expect(provider.favouriteIds.length, 2);
      expect(provider.isFavourite('item1'), true);
    });

    // Test adding favourite
    test('toggleFavourite adds item', () async {

      await provider.toggleFavourite('item1');

      expect(provider.isFavourite('item1'), true);
    });

    // Test removing favourite
    test('toggleFavourite removes item', () async {

      await provider.toggleFavourite('item1');
      await provider.toggleFavourite('item1');

      expect(provider.isFavourite('item1'), false);
    });
  });
}