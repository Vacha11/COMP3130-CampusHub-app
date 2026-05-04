import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campushub/services/favourite_service.dart';
import 'package:campushub/widgets/listing_card.dart';
import 'package:campushub/screens/listing_detail_screen.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  final FavouriteService favouriteService = FavouriteService();
  final user = FirebaseAuth.instance.currentUser;

  List<String> favouriteIds = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavourites();
  }

  Future<void> _loadFavourites() async {
    if (user == null) return;

    final favs = await favouriteService.getFavourites(user!.uid);

    setState(() {
      favouriteIds = favs;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Center(child: Text("Please log in"));
    }

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (favouriteIds.isEmpty) {
      return const Center(
        child: Text(
          "No favourites yet 💔\nStart saving listings!",
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

        final listings = snapshot.data!.docs.where((doc) {
          return favouriteIds.contains(doc.id);
        }).toList();

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 40),

              // PAGE TITLE
              const Text(
                "Your Favourites",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // LIST
              Expanded(
                child: ListView.builder(
                  itemCount: listings.length,
                  itemBuilder: (context, index) {
                    final listing =
                        listings[index].data() as Map<String, dynamic>;

                    return ListingCard(
                      title: listing['title'] ?? 'No Title',
                      price: listing['price'] ?? '0',
                      imageUrl: listing['imageUrl'],
                      docId: listings[index].id,
                      isFavourite: true,
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
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}