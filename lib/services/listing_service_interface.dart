
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';


abstract class ListingServiceInterface {

  Future<String?> uploadListingImage(
    XFile? imageFile,
    Uint8List? imageBytes,
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