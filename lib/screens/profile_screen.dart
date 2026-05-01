import 'package:campushub/screens/addlisting_screen.dart';
import 'package:flutter/material.dart';
import 'package:campushub/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'package:campushub/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage; // Variable to hold the selected image file
  final ImagePicker _picker = ImagePicker(); // Image picker instance to handle image selection

  // Function to pick an image from the gallery or take a photo using the camera
  Future<void> _pickProfileImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source); // Open the image picker to select an image from the gallery or take photo using the camera
    if (pickedFile == null) return; // If no image is selected, return early
    final file = File (pickedFile.path); // Create a File object from the selected image path
    final user = FirebaseAuth.instance.currentUser; 
    if(user == null) return;
    final storageref = FirebaseStorage.instance
      .ref()
      .child('profile_images')
      .child('${user.uid}.jpg');
    print("START UPLOAD");
    await storageref.putFile(file); // Upload the selected image file to Firebase Storage
    print("UPLOAD DONE");
    final imageUrl = await storageref.getDownloadURL(); // Get the download URL of

    print("UPLOAD COMPLETE: $imageUrl");

    // save to Firestore
    await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .set({
        'profileImage':imageUrl,
      }, SetOptions(merge: true)); // Save the download URL of the uploaded image to Firestore under the user's document, merging with existing data if necessary
    setState(() {
      _profileImage = file; // Update the state with the selected image file to display it in the UI
    });
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  _pickProfileImage(ImageSource.gallery); // Open the image picker for gallery selection
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  _pickProfileImage(ImageSource.camera); // Open the image picker for camera capture
                },
              ),
            ],
          ),
        );
      }
    ); // Show a bottom sheet with options to choose between gallery and camera for image selection
  }

  String? _profileImageUrl; // Variable to hold the URL of the profile image
  @override
  void initState() {
    super.initState();
    _loadProfileImage(); // Load the profile image when the widget is initialized
  }

  Future<void> _loadProfileImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if(user == null) return;
    final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .get(); // Fetch the user's document from Firestore to retrieve the profile image URL
    if(doc.exists){
      setState(() {
        _profileImageUrl = doc['profileImage']; // Update the state with the retrieved profile
      });
    }
  }

  final AuthService _authService = AuthService(); // Instance of the AuthService to handle authentication-related operations
  
  Widget _buildProfileListingCard(String docId, Map<String, dynamic>data){
    final imageUrl = data['imageUrl'] ?? '';
    return Container(
      margin: const EdgeInsets.only(bottom:12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children:[
          //Image placeholder
          
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: imageUrl != null && imageUrl != ''
              ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              )
            : const Icon(Icons.image),
          ),
          const SizedBox(width:12),

          // title + price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['title'] ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "${data['price'] ?? ''}",
                  style: const TextStyle(color:Colors.red),
                ),
              ],
            ),
          ),

          // Actions - Edit and update 
          Column(
            children:[
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddListingScreen(
                        docId: docId,
                        title: data['title'],
                        price: data['price'],
                        description: data['description'],
                        category: data['category'],
                        contact: data['contact'],
                        imageUrl: data['imageUrl'],
                      ),
                    ),
                  );
                }
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed:() async {
                  final confirm = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text(
                        "Delete Listing"
                      ),
                      content: const Text(
                        "Are you sure?"
                      ),
                      actions:[
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Delete"),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await FirestoreService().deleteListing(docId);
                  }
                }
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      //logout in top right corner
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the default back button from the AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirmLogout = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Logout"),
                  content: const Text("Are you sure you want to logout?"),
                  actions:[
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Logout"),
                    ),
                  ],
                ),
              );
              if (confirmLogout == true) {
                await _authService.signOut(); // Call the signOut method from AuthService to log the user out
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()), // Navigate to the Login
                  // Screen after logging out
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(        
              children: [
                // Profile image
                GestureDetector(
                  onTap: _showImagePickerOptions, 
                  child: Stack(
                    children:[
                      CircleAvatar(
                        radius:55,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: _profileImage != null ? NetworkImage(_profileImageUrl!) : (_profileImageUrl != null ? FileImage(_profileImage!) : null) as ImageProvider?, // Display the selected profile image if available, otherwise display the image from the URL if available
                        child: _profileImage == null && _profileImage == null ? const Icon(Icons.person, size: 55, color: Colors.white) : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit, size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  user?.email?.split('@')[0] ?? 'User', // Display the username (part of the email before '@') or 'User' if email is not available
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Styling for the username text
                ),
            
                const SizedBox(height: 10), // Spacing between the username and email

                Text(
                  user?.email ?? 'No email', // Display the user's email or 'No email' if email is not available
                  style: TextStyle(fontSize: 16, color: Colors.grey), // Styling for the email text
                ),

                const SizedBox(height: 30), // Spacing between the email and the listings 
            
                const Divider(),
                const Text ("My Listings", style:TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Divider(),

              
                StreamBuilder<QuerySnapshot>(
                  stream: FirestoreService().getUserListings(user!.uid),
                  builder:(context, snapshot){
                    if (snapshot.connectionState == ConnectionState.waiting){
                      return const Center(child: CircularProgressIndicator());
                    }
                    if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
                      return const Center(child: Text("No Listings yet"));
                    }
                    final listings = snapshot.data!.docs;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listings.length,
                      itemBuilder: (context, index){
                        final data = listings[index].data() as Map<String, dynamic>;
                        return _buildProfileListingCard(listings[index].id, data);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),  
    );
  }
}