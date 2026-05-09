import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campushub/widgets/listing_card.dart';
import 'package:campushub/screens/listing_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:campushub/providers/favourite_provider.dart';
import 'package:campushub/models/listing_model.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {

  @override
  Widget build(BuildContext context) {
    final favouriteProvider = Provider.of<FavouriteProvider>(context);
    final favouriteIds = favouriteProvider.favouriteIds; // Get the list of favourite listing IDs

    if (favouriteIds.isEmpty) {
      return const Center(
        child: Text(
          "No favourites yet\nStart saving listings!",
          textAlign: TextAlign.center,
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('listings').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        // Filter only favourited listings
        final listings = snapshot.data!.docs.where((doc) {
          return favouriteIds.contains(doc.id);
        }).toList();

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 40),

              // Page header
              const Text(
                "Your Favourites",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // favourite listings
              Expanded(
                child: ListView.builder(
                  itemCount: listings.length,
                  itemBuilder: (context, index) {
                    // Convert Firestore document into ListingModel
                    final listing = ListingModel.fromMap(
                      listings[index].id,
                      listings[index].data() as Map<String, dynamic>,
                    );

                    return ListingCard(
                      title: listing.title,
                      price: listing.price,
                      category: listing.category,
                      imageUrl: listing.imageUrl,
                      docId: listing.id,
                      onTap: () {
                        // navigate to the detailed listing view screen 
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
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}