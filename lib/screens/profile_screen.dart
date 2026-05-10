import 'package:campushub/screens/addlisting_screen.dart';
import 'package:flutter/material.dart';
import 'package:campushub/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'package:campushub/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:campushub/services/user_profile_service.dart';
import 'package:campushub/widgets/profile_listing_card.dart';
import 'package:campushub/widgets/confirmation_dialog.dart';



class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage; 
  final ImagePicker _picker = ImagePicker(); 
  final UserProfileService _profileService = UserProfileService();

  // Function to pick an image from the gallery or take a photo using the camera
  Future<void> _pickProfileImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source); // Open the image picker to select an image from the gallery or take photo using the camera
    if (pickedFile == null) return; 
    final file = File (pickedFile.path); // Create a File object from the selected image path
    final user = FirebaseAuth.instance.currentUser; 
    if(user == null) return;
    final url = await _profileService.uploadProfilePicture(file, user.uid); 
    
    await _profileService.saveProfileImageUrl(user.uid, url); // Upload the selected image to Firebase Storage and save the download URL to Firestore under the user's document

    final imageUrl = await _profileService.getProfileImageUrl(user.uid); // Get the download URL of the uploaded image

    setState(() {
      _profileImage = file; // Update the state with the selected image file to display it in the UI
      _profileImageUrl = imageUrl; // Update the state with the retrieved image URL to display it in the UI
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
                  Navigator.pop(context); 
                  _pickProfileImage(ImageSource.gallery); 
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context); 
                  _pickProfileImage(ImageSource.camera); 
                },
              ),
            ],
          ),
        );
      }
    ); 
  }

  String? _profileImageUrl; 
  @override
  void initState() {
    super.initState();
    _loadProfileImage(); // Load the profile image when the widget is initialized
  }

  Future<void> _loadProfileImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if(user == null) return;
    final url = await _profileService.getProfileImageUrl(user.uid); // Get the profile image URL from Firestore for the current user
    setState(() {
      _profileImageUrl = url; // Update the state with the retrieved profile image URL to display it in the UI
    });
  }

  final AuthService _authService = AuthService(); // Instance of the AuthService to handle authentication-related operations
  
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      
      //logout in top right corner
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F7),
        automaticallyImplyLeading: false, // Remove the default back button from the AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF373A36)),
            onPressed: () async {
              final confirmLogout = await showDialog(
                context: context,
                builder: (context) => const ConfirmationDialog(
                  title: "Logout",
                  content: "Are you sure you want to logout?",
                  confirmText: "Logout",
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
                        child: _profileImageUrl == null && _profileImage == null ? const Icon(Icons.person, size: 55, color: Color(0xFF373A36)) : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Color(0xFFA6192E),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit, size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20), 
                Text(
                  user?.email?.split('@')[0] ?? 'User', // Display the username (part of the email before '@') or 'User' if email is not available
                  style: TextStyle(
                    fontSize: 24, 
                    fontWeight: FontWeight.bold,
                    color:Color(0xFF373A36),
                  ), 
                ),
            
                const SizedBox(height: 5), 

                Text(
                  user?.email ?? 'No email', // Display the user's email or 'No email' if email is not available
                  style: TextStyle(fontSize: 16, color: Colors.grey), 
                ),

                const SizedBox(height: 30), 
            
                const Divider(),
                const Text (
                  "My Listings", 
                  style:TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF373A36),
                  ),
                ),
                const Divider(),

                // User's listings
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
                        return ProfileListingCard(
                          title: data['title'] ?? '',
                          price: data['price'] ?? '',
                          category: data['category'] ?? '',
                          imageUrl: data['imageUrl'],

                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddListingScreen(
                                  docId: listings[index].id,
                                  title: data['title'],
                                  price: data['price'],
                                  description: data['description'],
                                  category: data['category'],
                                  contact: data['contact'],
                                  imageUrl: data['imageUrl'],
                                ),
                              ),
                            );
                          },
                          onDelete: () async {
                            final confirm = await showDialog(
                              context: context,

                              builder: (context) => const ConfirmationDialog(
                                title: "Delete Listing",
                                content: "Are you sure?",
                                confirmText: "Delete",
                              ),
                            );

                            if (confirm == true) {
                              await FirestoreService().deleteListing(
                                listings[index].id,
                              );
                            }
                          },
                        ); 
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