abstract class FavouriteServiceInterface {
  Future<void> toggleFavourites(String userId, String listingId);

  Future<List<String>> getFavourites(String userId);
}