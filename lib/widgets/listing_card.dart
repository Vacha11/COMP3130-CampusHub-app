import 'package:flutter/material.dart';

class ListingCard extends StatelessWidget {
  final String title; // Title of the listing
  final String price; // Price of the listing

  const ListingCard({
    super.key,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
         // IMAGE
         Container(
           height: 140,
           width: double.infinity,
           decoration: BoxDecoration(
             color: Colors.grey[300],
             borderRadius: BorderRadius.circular(12),
           ),
           child: const Icon(Icons.image, size: 50),
         ),


         const SizedBox(height: 10),


         // TITLE
         Text(
           title,
           style: const TextStyle(
             fontSize: 16,
             fontWeight: FontWeight.bold,
           ),
         ),


         const SizedBox(height: 6),


         // PRICE + HEART
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
             const Icon(Icons.favorite_border),
           ],
         ),
       ],
     ),
   );
 }
}