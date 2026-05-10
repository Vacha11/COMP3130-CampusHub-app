import 'package:flutter/material.dart';
import 'package:campushub/services/firestore_service.dart';
import 'package:campushub/widgets/listings/listing_card.dart';
import 'package:campushub/screens/listing_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:campushub/models/listing_model.dart';

class ListingsView extends StatefulWidget {
  final int categoryIndex;
  final String searchQuery;

  ListingsView({
    super.key,
    required this.categoryIndex,
    required this.searchQuery,
  });

  @override
  State<ListingsView> createState() => _ListingsViewState();
}

class _ListingsViewState extends State<ListingsView> {
  final FirestoreService _firestoreService = FirestoreService();

  final user = FirebaseAuth.instance.currentUser;


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ListingModel>>(
      stream: _firestoreService.getListings(),

      builder: (context, snapshot) {
        // loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // error state
        if (snapshot.hasError) {
          return const Center(child: Text("Error loading listings"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No listings available"));
        }

        final allListings = snapshot.data!;

        // convert firestore to ListingModel + filtering
        final listings = allListings.where((listing){
          // category filter
          final category = listing.category.toLowerCase();

          final matchesCategory = widget.categoryIndex == 0 || (widget.categoryIndex == 1 && category == 'item') || (widget.categoryIndex == 2 && category == 'service');

          // filter based on search
          final title = listing.title.toLowerCase();

          // search filter
          final matchesSearch = title.contains(widget.searchQuery.toLowerCase());

          return matchesCategory && matchesSearch;
        }).toList();

        if (listings.isEmpty) {
          return const Center(child: Text("No listings in this category"));
        }

        return ListView.builder(
          itemCount: listings.length,
          itemBuilder: (context, index) {
            final listing = listings[index];

            return ListingCard(
              title: listing.title,
              price: listing.price,
              category: listing.category,
              imageUrl: listing.imageUrl,
              docId: listing.id,
              onTap: () {
                // navigate to detailed listing screen 
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ListingDetailScreen(
                      listing: listing,
                      docId: listing.id,
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