import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campushub/providers/favourite_provider.dart';

class ListingCard extends StatelessWidget {
  // Listing details passed from Firestore model
  final String title;
  final String price;
  final String? category;
  final String? imageUrl;
  final String? docId;
  final VoidCallback? onTap;

  const ListingCard({
    super.key,
    required this.title,
    required this.price,
    required this.category,
    this.imageUrl,
    this.docId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if listing is a service (adds /hr pricing format)
    final isService = (category ?? '').toLowerCase() == 'service';
    final formattedPrice = "\$$price${isService ? '/hr' : ''}";

    return GestureDetector(
      onTap: onTap,
      // Card container styling for marketplace look
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEDEBE5),width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //image with hero animation for smooth transition
            Hero(
              tag: docId ?? title,
                child: (imageUrl != null && imageUrl!.isNotEmpty)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: AspectRatio(
                          aspectRatio: 1.1,
                          child: Image.network(
                            imageUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 50,
                                  color: Color(0xFF373A36),
                                ),
                              );
                            },
                          ),
                        )
                    )
                    : const Icon(Icons.image, size: 50, color: Color(0xFF373A36)),
            ),

            const SizedBox(height: 6),

            //tile
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color:  Color(0xFF373A36),
              ),
            ),

            //price and favourite button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedPrice,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFFA6192E),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                // Favourite toggle button (uses Provider state)
                Builder(
                  builder: (context) {
                    final favouriteProvider = Provider.of<FavouriteProvider>(context);
                    final isFav = favouriteProvider.isFavourite(docId ?? title); // Check if the listing is in the user's favourites

                    return IconButton(
                      onPressed: () {
                        if (docId == null) return;
                        favouriteProvider.toggleFavourite(docId!);
                      },
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? const Color(0xFFD6001C) : const Color(0xFFA6192E).withOpacity(0.6),
                        size: 30,
                      ),
                    );
                  }
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}