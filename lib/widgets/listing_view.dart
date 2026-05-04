import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campushub/services/firestore_service.dart';
import 'package:campushub/widgets/listing_card.dart';
import 'package:campushub/screens/listing_detail_screen.dart';

class ListingsView extends StatelessWidget {
  final int categoryIndex;
  final String searchQuery;

  ListingsView({
    super.key,
    required this.categoryIndex,
    required this.searchQuery,
  });

  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestoreService.getListings(),

      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Error loading listings"));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No listings available"));
        }

        final allListings = snapshot.data!.docs;

        // filter listing by category
        final listings = allListings.where((doc) {
          final data = doc.data() as Map<String, dynamic>;

          final category = (data['category'] ?? '').toString().toLowerCase();

          final matchesCategory = categoryIndex == 0 || (categoryIndex == 1 && category == 'item') || (categoryIndex == 2 && category == 'service');


          // filter based on search
          final title = (data['title'] ?? '').toString().toLowerCase();

          final matchesSearch = title.contains(searchQuery.toLowerCase());

          return matchesCategory && matchesSearch;
        }).toList();

        if (listings.isEmpty) {
          return const Center(child: Text("No listings in this category"));
        }

        return ListView.builder(
          itemCount: listings.length,
          itemBuilder: (context, index) {
            final listing =
                listings[index].data() as Map<String, dynamic>;

            return ListingCard(
              title: listing['title'] ?? 'No Title',
              price: listing['price'] ?? 'No Price',
              imageUrl: listing['imageUrl'],
              docId: listings[index].id,
              isFavourite: false,
              onFavouriteTap: () {
                // favourites later
              },
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ListingDetailScreen(
                      listing: listing,
                      docId: listings[index].id,
                    ), 
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}