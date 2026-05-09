import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campushub/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

// Screen where users can create a new marketplace listing
class AddListingScreen extends StatefulWidget {
  final String? docId;
  final String? title;
  final String? description;
  final String? price;
  final String? category;
  final String? contact;
  final String? imageUrl;

  const AddListingScreen({
    super.key,
    this.docId,
    this.title,
    this.description,
    this.price,
    this.category,
    this.contact,
    this.imageUrl,
  });

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  File? selectedImage;
  final ImagePicker picker = ImagePicker();

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

 @override
 void initState(){
  super.initState();

  // prefill data
  titleController.text = widget.title ?? '';
  descriptionController.text = widget.description ?? '';
  priceController.text = widget.price ?? '';
  contactController.text = widget.contact ?? '';

  // set category when editing
  if (widget.category != null){
    selectedCategory = widget.category == "Service" ? 1:0;
  }
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
           color: isSelected ? const Color(0xFFA6192E) :  Colors.white,
           borderRadius: BorderRadius.circular(10),
           border: Border.all(
            color: isSelected ? const Color(0xFFA6192E) : const Color(0xFFEDEBE5),
            width: 1,
           ),
         ),
         alignment: Alignment.center,
         child: Text(
           title,
           style: TextStyle(
             color: isSelected ? Colors.white : Color(0xFF373A36),
             fontWeight: FontWeight.bold,
             fontSize: 15,
           ),
         ),
       ),
     ),
   );
 }

  // Called when user presses "Post Listing"
  void _submitListing() async {
    final user = FirebaseAuth.instance.currentUser;
    String? uploadedUrl;

    if (selectedImage != null) {
      uploadedUrl = await FirestoreService().uploadImage(selectedImage!);
    }

    String? imageUrl = uploadedUrl ?? widget.imageUrl;

    final data = {
      "title": titleController.text,
      "description": descriptionController.text,
      "price": priceController.text,
      "category": selectedCategory == 0 ? "Item" : "Service",
      "contact": contactController.text,
      "createdAt": Timestamp.now(),
      "userId": user?.uid,
      "sellerName": user?.displayName ?? user?.email ?? "Anonymous",
      "sellerEmail": user?.email,
      "imageUrl": imageUrl,
    };
    if (widget.docId != null){
      // update
      await FirestoreService().updateListing(widget.docId!, data);
    } else {
      await FirestoreService().addListing(data);
    }
    
    if (mounted) {
      Navigator.pop(context); // go back after saving
    }
  }

  Future<void> selectImage(ImageSource source) async{
    final selectedFile = await picker.pickImage(source: source);

    if(selectedFile != null){
      setState(() {
        selectedImage = File(selectedFile.path);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            source == ImageSource.camera
            ? "Photo captured successfully"
            : "Image selected from gallery",
          ),
          backgroundColor: const Color(0xFFA6192E),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showImagePickerOptions() {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                selectImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                selectImage(ImageSource.camera);
              },
            ),
          ],
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      // Top bar with back button
      appBar: AppBar( 
        backgroundColor: const Color(0xFFF7F7F7),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color:Color(0xFF373A36)),
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
              const Text(
                "Title",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF373A36),
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "Enter Title",
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xFFEDEBE5),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xFFEDEBE5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xFFA6192E),
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              
              // Select Category
              const Text(
                "Category",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF373A36),
                ),
              ), 
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
              const Text(
                "Price",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF373A36),
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter Price",
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xFFEDEBE5),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xFFEDEBE5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xFFA6192E),
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Upload Image 
              const Text(
                "Add Photo",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF373A36),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _showImagePickerOptions,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFEDEBE5)),
                  ),
                  child: selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.file(
                            selectedImage!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        )
                      : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo, size: 30),
                              SizedBox(height: 6),
                              Text("Tap to add image"),
                            ],
                          ),
                        ),
                ),
              ),
            
              const SizedBox(height: 15),
              
              // Contact Input
              const Text(
                "Contact",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF373A36),
                ),
              ),
              TextField(
                controller: contactController,
                decoration: InputDecoration(
                  hintText: "Enter Contact Number",
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xFFEDEBE5),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xFFEDEBE5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xFFA6192E),
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Description Input
              const Text(
                "Description",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF373A36),
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Enter Description",
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xFFEDEBE5),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xFFEDEBE5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xFFA6192E),
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height:20),

              // submit form - Post Listing button
              SizedBox(
                width:double.infinity,
                child: ElevatedButton(
                  onPressed:_submitListing,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:const Color(0xFFA6192E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    widget.docId != null ? "Update Listing" : "Post Listing",
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