import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campushub/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Screen where users can create a new marketplace listing
class AddListingScreen extends StatefulWidget {
  final String? title;
  final String? description;
  final String? price;
  final String? category;
  final String? contact;

  const AddListingScreen({
    super.key,
    this.title,
    this.description,
    this.price,
    this.category,
    this.contact,
  });

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController contactController = TextEditingController();

  // Tracks selected category (0 = Item, 1 = Service)
  int selectedCategory = 0;

  @override
  void dispose() { // Clean up controllers when screen is closed to avoid memory leaks
   titleController.dispose();
   descriptionController.dispose();
   priceController.dispose();
   contactController.dispose();
   super.dispose();
 }

  // Builds category selection buttons (Item / Service)
  Widget _buildCategoryButton(String title, int index) { 
   final isSelected = selectedCategory == index;


   return Expanded(
     child: GestureDetector(
       onTap: () {
         setState(() {
           selectedCategory = index; // update selected category
         });
       },
       child: Container(
         padding: const EdgeInsets.symmetric(vertical: 12),
         decoration: BoxDecoration(
           color: isSelected ? Colors.red : Colors.grey[200],
           borderRadius: BorderRadius.circular(10),
         ),
         alignment: Alignment.center,
         child: Text(
           title,
           style: TextStyle(
             color: isSelected ? Colors.white : Colors.black,
             fontWeight: FontWeight.bold,
           ),
         ),
       ),
     ),
   );
 }

  // Called when user presses "Post Listing"
  void _submitListing() async {
    final user = FirebaseAuth.instance.currentUser;
    final data = {
      "title": titleController.text,
      "description": descriptionController.text,
      "price": priceController.text,
      "category": selectedCategory == 0 ? "Item" : "Service",
      "contact": contactController.text,
      "createdAt": Timestamp.now(),
      "userId": user?.uid,
    };
    await FirestoreService().addListing(data);

    if (mounted) {
      Navigator.pop(context); // go back after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // Top bar with back button
      appBar: AppBar( 
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color:Colors.black),
          onPressed: (){
            Navigator.pop(context); // go back to previous screen
          },
        ),
      ),

      // Main form content
      body: SingleChildScrollView( 
        child:Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              // Title Input
              const Text("Title"),
              const SizedBox(height: 5),
              TextField(
                controller: titleController,
                decoration:const InputDecoration(
                  hintText: "Enter Title",
                  border:OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              
              // Select Category
              const Text("Category"), 
              const SizedBox(height: 7),
              Row(
                children: [
                  _buildCategoryButton("Item", 0),
                  const SizedBox(width: 10),
                  _buildCategoryButton("Service", 1),
                ],
              ),


              const SizedBox(height: 15),

              // Price Input
              const Text("Price"),
              const SizedBox(height: 5),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Enter Price",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              // Upload Image Placeholder
              const Text("Add Photo"),
              const SizedBox(height: 7),
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Icon(Icons.add_a_photo, size: 30),
                ),
              ),
              const SizedBox(height: 15),
              
              // Contact Input
              const Text("Contact"),
              TextField(
                controller: contactController,
                decoration: const InputDecoration(
                  hintText:"Enter contact number",
                  border:OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              // Description Input
              const Text("Description"),
              const SizedBox(height: 5),
              TextField(
                controller: descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText:"Enter Description",
                  border:OutlineInputBorder(),
                ),
              ),
              const SizedBox(height:20),

              // submit form - Post Listing button
              SizedBox(
                width:double.infinity,
                child: ElevatedButton(
                  onPressed:_submitListing,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    "Post Listing",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }             
}