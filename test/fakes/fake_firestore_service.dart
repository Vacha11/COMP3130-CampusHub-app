import 'package:campushub/services/interfaces/firestore_service_interface.dart';
import 'package:campushub/models/listing_model.dart';

class FakeFirestoreService implements FirestoreServiceInterface {
  final List<ListingModel> _listings = [
    ListingModel(
      id: 'listing_1',
      title: 'Laptop for sale',
      description: 'A good laptop',
      price: '500',
      category: 'Electronics',
      contact: '123',
      sellerName: 'Test User',
      imageUrl: null,
      sellerEmail: 'test@test.com',
      userId: 'test-user',
    ),
  ];

  @override
  Stream<List<ListingModel>> getListings() {
    return Stream.value(_listings);
  }

  @override
  Stream<List<ListingModel>> getUserListings(String uid) {
    return Stream.value(
      _listings.where((l) => l.userId == uid).toList(),
    );
  }

  @override
  Future<void> deleteListing(String docId) async {
    _listings.removeWhere((l) => l.id == docId);
  }
}