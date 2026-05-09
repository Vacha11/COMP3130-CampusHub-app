import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:campushub/services/listing_service.dart';
import 'package:campushub/widgets/app_label.dart';
import 'package:campushub/widgets/app_text_fields.dart';

// Screen where users can create a new marketplace listing
class AddListingScreen extends StatefulWidget {
  // This screen acts as both create + edit screen 
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
  // Controllers manage the text input state for form fields
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController contactController = TextEditingController();

  // store the selected image first 
  File? selectedImage;
  
  final ImagePicker picker = ImagePicker();
  // listing service handles Firestore and image upload logic
  final ListingService _listingService = ListingService();

  // Tracks selected category (Item,Service)
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

  // prefill data when editing and existing listing
  titleController.text = widget.title ?? '';
  descriptionController.text = widget.description ?? '';
  priceController.text = widget.price ?? '';
  contactController.text = widget.contact ?? '';

  // set category when editing
  if (widget.category != null){
    selectedCategory = widget.category == "Service" ? 1:0;
  }
 }

  // Build a reusable category selection button (Item / Service)
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

  // handles submit for create and edit listing
  void _submitListing() async {
    final category = selectedCategory == 0 ? "Item" : "Service";
    
    // upload image if new image is selected
    final imageUrl = await _listingService.uploadListingImage(
      selectedImage,
      widget.imageUrl,
    );

    await _listingService.submitListing(
      docId: widget.docId,
      title: titleController.text,
      description: descriptionController.text,
      price: priceController.text,
      category: category,
      contact: contactController.text,
      imageUrl: imageUrl,
    );
    // return to the previous screen aftr submitting
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

      // a scrollable Main form content to avoid overflow on smaller screens
      body: SingleChildScrollView( 
        child:Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              // Title Input
              const AppLabel(text: "Title"),
              const SizedBox(height: 5),
              AppTextField(
                controller: titleController, 
                hint: "Enter Title",
              ),
              
              const SizedBox(height: 15),
              
              // Select Category
              const AppLabel(text: "Category"),
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
              const AppLabel(text: "Price"),
              const SizedBox(height: 5),
              AppTextField(
                controller: priceController, 
                hint: "Enter Price",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),

              // Upload Image 
              const AppLabel(text: "Add Photo"),
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
                  child: selectedImage != null ? ClipRRect(

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
              const AppLabel(text: "Contact"),
              const SizedBox(height: 5),
              AppTextField(
                controller: contactController, 
                hint: "Enter Contact Number",
              ),

              const SizedBox(height: 15),

              // Description Input
              const AppLabel(text: "Description"),
              const SizedBox(height: 5),
              AppTextField(
                controller: descriptionController, 
                hint: "Enter Description",
                maxLines: 4,
              ),
              const SizedBox(height:20),

              // submit form - Post Listing button and update listing button
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