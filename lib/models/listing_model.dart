import 'package:cloud_firestore/cloud_firestore.dart';

class ListingModel {
  final String id;
  final String title;
  final String description;
  final String price;
  final String category;
  final String contact;
  final String? imageUrl;
  final String sellerName;
  final String? sellerEmail;
  final String? userId;
  final Timestamp? createdAt;

  ListingModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.contact,
    this.imageUrl,
    required this.sellerName,
    this.sellerEmail,
    this.userId,
    this.createdAt,
  });

  // Convert Firestore into Model
  factory ListingModel.fromMap(String id, Map<String, dynamic> data) {
    return ListingModel(
      id: id,
      title: data['title'] ?? 'No Title',
      description: data['description'] ?? 'No Description',
      price: data['price'] ?? '0',
      category: data['category'] ?? 'Item',
      contact: data['contact'] ?? 'No Contact',
      imageUrl: data['imageUrl'],
      sellerName: data['sellerName'] ?? 'Anonymous',
      sellerEmail: data['sellerEmail'],
      userId: data['userId'],
      createdAt: data['createdAt'],
    );
  }

  //  Model to Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'contact': contact,
      'imageUrl': imageUrl,
      'sellerName': sellerName,
      'sellerEmail': sellerEmail,
      'userId': userId,
      'createdAt': createdAt,
    };
  }
}