import 'package:campushub/providers/favourite_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListingDetailScreen extends StatefulWidget {
  final Map<String, dynamic> listing;
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

  @override
  Widget build(BuildContext context) {
    final title = widget.listing['title'] ?? 'No Title';
    final price = widget.listing['price'] ?? '0';
    final description = widget.listing['description'] ?? 'No description provided';
    final contact = widget.listing['contact'] ?? 'No contact';
    final category = widget.listing['category'] ?? 'Unknown';
    final imageUrl = widget.listing['imageUrl'];
    final sellerName = widget.listing['sellerName'] ?? 'Anonymous';
    final favouriteProvider = Provider.of<FavouriteProvider>(context);
    final isFav = favouriteProvider.isFavourite(widget.docId); // Check if the listing is in the user's favourites

    final isService =
        (widget.listing['category'] ?? '').toString().toLowerCase() == 'service';

    final formattedPrice = "\$$price${isService ? '/hr' : ''}";

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      body: CustomScrollView(
        slivers: [

          // image + title + price + category
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
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : Colors.white,),
              ),
            ],

            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [

                  Hero(
                    tag: widget.docId,
                    child: imageUrl != null
                        ? Image.network(imageUrl, fit: BoxFit.cover)
                        : Container(color: Colors.grey[300]),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // details section
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
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFA6192E),
                          ),
                        ),
                      ),

                      // category
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFA6192E).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          category.toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFFA6192E),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  _sectionCard(
                    title: "Description",
                    child: Text(
                      description,
                      style: const TextStyle(height: 1.5, fontSize: 15),
                    ),
                  ),

                  const SizedBox(height: 20),

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

   // helper for details sections (description, seller, contact)
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
}