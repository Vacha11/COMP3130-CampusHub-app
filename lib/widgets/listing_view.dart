import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campushub/services/firestore_service.dart';
import 'package:campushub/widgets/listing_card.dart';
import 'package:campushub/screens/listing_detail_screen.dart';
import 'package:campushub/services/favourite_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final FavouriteService _favouriteService = FavouriteService();
  final user = FirebaseAuth.instance.currentUser;

  List<String> favouriteIds = [];

  @override
  void initState() {
    super.initState();
    _loadFavourites();
  }

  Future<void> _loadFavourites() async {
    if (user == null) return;

    final favs = await _favouriteService.getFavourites(user!.uid);

    setState(() {
      favouriteIds = favs;
    });
  }

  void _toggleFavourite(String listingId) async {
    if (user == null) return;

    await _favouriteService.toggleFavourites(user!.uid, listingId);

    setState(() {
      if (favouriteIds.contains(listingId)) {
        favouriteIds.remove(listingId);
      } else {
        favouriteIds.add(listingId);
      }
    });
  }


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

          final matchesCategory = widget.categoryIndex == 0 || (widget.categoryIndex == 1 && category == 'item') || (widget.categoryIndex == 2 && category == 'service');


          // filter based on search
          final title = (data['title'] ?? '').toString().toLowerCase();

          final matchesSearch = title.contains(widget.searchQuery.toLowerCase());

          return matchesCategory && matchesSearch;
        }).toList();

        if (listings.isEmpty) {
          return const Center(child: Text("No listings in this category"));
        }

        return ListView.builder(
          itemCount: listings.length,
          itemBuilder: (context, index) {
            final listing = listings[index].data() as Map<String, dynamic>;
            final docId = listings[index].id;
            final isFav = favouriteIds.contains(docId);

            return ListingCard(
              title: listing['title'] ?? 'No Title',
              price: listing['price'] ?? 'No Price',
              imageUrl: listing['imageUrl'],
              docId: docId,
              isFavourite: isFav,
              onFavouriteTap: () {
                _toggleFavourite(docId);
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