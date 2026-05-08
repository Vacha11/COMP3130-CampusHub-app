import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campushub/providers/favourite_provider.dart';

class ListingCard extends StatelessWidget {
  final String title;
  final String price;
  final String? imageUrl;
  final String? docId;
  final VoidCallback? onTap;

  const ListingCard({
    super.key,
    required this.title,
    required this.price,
    this.imageUrl,
    this.docId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //image
            Hero(
              tag: docId ?? title,
              child: Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 140,
                        ),
                      )
                    : const Icon(Icons.image, size: 50),
              ),
            ),

            const SizedBox(height: 10),

            //tile
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            //price and favourite button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),

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
                        color: isFav ? Colors.red : Colors.grey,
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