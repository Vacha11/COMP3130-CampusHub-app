import 'package:campushub/models/listing_model.dart';

abstract class FirestoreServiceInterface {
  Stream<List<ListingModel>> getUserListings(String userId);
  Future<void> deleteListing(String docId);
}