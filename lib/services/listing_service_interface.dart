import 'dart:io';

abstract class ListingServiceInterface {

  Future<String?> uploadListingImage(
    File? imageFile,
    String? existingUrl,
  );

  Future<void> submitListing({
    required String? docId,
    required String title,
    required String description,
    required String price,
    required String category,
    required String contact,
    required String? imageUrl,
  });
}