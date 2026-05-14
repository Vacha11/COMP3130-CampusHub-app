import 'package:campushub/services/favourite_service_interface.dart';

class FakeFavouriteService implements FavouriteServiceInterface {
  final List<String> _favs = [];

  @override
  Future<List<String>> getFavourites(String userId) async {
    return _favs;
  }

  @override
  Future<void> toggleFavourites(String userId, String listingId) async {
    if (_favs.contains(listingId)) {
      _favs.remove(listingId);
    } else {
      _favs.add(listingId);
    }
  }
}