import 'package:flutter/material.dart';

// display their own listings in profile page with edit and delete actions
class ProfileListingCard extends StatelessWidget {
  final String title;
  final String price;
  final String category;
  final String? imageUrl;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProfileListingCard({
    super.key,
    required this.title,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Add hourly suffix for service listings
    final formattedPrice =
        "\$$price${category.toLowerCase() == 'service' ? '/hr' : ''}";

    return Container(
      // Ensure card has minimum height for consistent layout
      constraints: const BoxConstraints(
        minHeight: 120,
      ),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        // Light border for separation between cards
        border: Border.all(
          color: const Color(0xFFEDEBE5),
          width: 1,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        children: [
          // Listing image preview
          Container(
            height: 100,
            width: 100,

            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            // Show image if available, otherwise fallback icon
            child: imageUrl != null && imageUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),

                    child: Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  )
                : const Icon(Icons.image),
          ),

          const SizedBox(width: 12),

          // Listing title and price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF373A36),
                    fontSize: 17,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  formattedPrice,

                  style: const TextStyle(
                    color: Color(0xFFA6192E),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // Edit and delete actions
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            children: [
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Color(0xFF373A36),
                ),

                onPressed: onEdit,
              ),

              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Color(0xFF373A36),
                ),

                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}