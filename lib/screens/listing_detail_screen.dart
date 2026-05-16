import 'package:campushub/providers/favourite_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campushub/models/listing_model.dart';

class ListingDetailScreen extends StatefulWidget {
  final ListingModel listing;
  final String docId;

  const ListingDetailScreen({
    super.key,
    required this.listing,
    required this.docId,
  });

  @override
  State<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> {
  
  // If issue loading image, load broken image icon instead of crashing page
  Widget buildSafeImage(String? url) {
    if (url == null || url.isEmpty) {
      return Container(
        color: Colors.grey[300],
        child: const Icon(Icons.image, size: 60, color: Colors.grey),
      );
    }

    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image, size: 60),
        );
      },
    );
  }

  // reusable UI builder for details sections (description, seller, contact)
  Widget _sectionCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // extract listing data from firestore with safe fallbacks
    final title = widget.listing.title;
    final price = widget.listing.price;
    final description = widget.listing.description;
    final contact = widget.listing.contact;
    final category = widget.listing.category;
    final imageUrl = widget.listing.imageUrl;
    final sellerName = widget.listing.sellerName;

    final favouriteProvider = Provider.of<FavouriteProvider>(context);
     // Check if the listing is in the user's favourites
    final isFav = favouriteProvider.isFavourite(widget.docId);

    // Determine if the listing is a service to adjust price formatting
    final isService = (widget.listing.category).toString().toLowerCase() == 'service';
    final formattedPrice = "\$$price${isService ? '/hr' : ''}";

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      body: CustomScrollView(
        slivers: [

          // image + title + price + category
          // a top expandable header showcasing the image with a favourite action button
          SliverAppBar(
            expandedHeight: 340,
            pinned: true,
            backgroundColor: const Color(0xFFA6192E),

            // heart icon to add to favourites
            actions: [
              IconButton(
                onPressed: () async {
                  await favouriteProvider.toggleFavourite(widget.docId); // Toggle the favourite status of the listing
                },
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, 
                size: 40,
                color: isFav ? const Color(0xFFD6001C) : const Color(0xFFA6192E).withOpacity(0.6),
                ),
              ),
            ],

            flexibleSpace: FlexibleSpaceBar(
              background:
                  // hero animation for a smoother image transition
                  Hero(
                    tag: widget.docId,
                    child: buildSafeImage(widget.listing.imageUrl),
                  ),
                
                
              ),
            ),
          

          // Main details section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      // price
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          formattedPrice,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFA6192E),
                          ),
                        ),
                      ),

                      // category
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFA6192E).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          category.toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFFA6192E),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // description
                  _sectionCard(
                    title: "Description",
                    child: Text(
                      description,
                      style: const TextStyle(height: 1.5, fontSize: 15),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Seller name
                  _sectionCard(
                    title: "Seller",
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 22,
                          backgroundColor: Color(0xFFA6192E),
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            sellerName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  
                  // contact number
                  _sectionCard(
                    title: "Contact",
                    child: Text(
                      contact,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}