import 'package:flutter/material.dart';

class ListingDetailScreen extends StatelessWidget {
  final Map<String, dynamic> listing;
  final String docId;

  const ListingDetailScreen({
    super.key,
    required this.listing,
    required this.docId,
  });

  @override
  Widget build(BuildContext context) {
    final title = listing['title'] ?? 'No Title';
    final price = listing['price'] ?? '0';
    final description = listing['description'] ?? 'No description provided';
    final contact = listing['contact'] ?? 'No contact';
    final category = listing['category'] ?? 'Unknown';
    final imageUrl = listing['imageUrl'];
    final sellerName = listing['sellerName'] ?? 'Anonymous';

    final isService =
        (listing['category'] ?? '').toString().toLowerCase() == 'service';

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

            /// ONLY HEART (NO SHARE)
            actions: [
              IconButton(
                onPressed: () {
                  // TODO: toggle favourite
                },
                icon: const Icon(Icons.favorite_border),
              ),
            ],

            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [

                  Hero(
                    tag: docId,
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