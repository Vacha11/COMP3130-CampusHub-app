import 'package:campushub/screens/addlisting_screen.dart';
import 'package:flutter/material.dart';
import 'package:campushub/services/interfaces/auth_service_interface.dart';
import 'login_screen.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:campushub/widgets/profile/profile_listing_card.dart';
import 'package:campushub/widgets/common/confirmation_dialog.dart';
import 'package:campushub/widgets/profile/profile_header.dart';
import 'package:campushub/models/listing_model.dart';
import 'package:campushub/services/interfaces/firestore_service_interface.dart';
import 'package:campushub/services/interfaces/user_profile_service_interface.dart';



class ProfileScreen extends StatefulWidget {
  final FirestoreServiceInterface firestoreService;
  final AuthServiceInterface authService;
  final UserProfileServiceInterface profileService;

  const ProfileScreen({
    super.key,
    required this.firestoreService, 
    required this.authService,
    required this.profileService,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  // Stores locally selected profile image (from camera/gallery)
  XFile? _profileImage; 
  Uint8List? _webImage;
  final ImagePicker _picker = ImagePicker(); 



  // Uploads image to Firebase Storage and updates Firestore
  Future<void> _pickProfileImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source); 
    if (pickedFile == null) return; 

    final user = widget.authService.currentUser;

    if(user == null) return;
    final url = await widget.profileService.uploadProfilePicture(pickedFile, user.uid); 
    
    await widget.profileService.saveProfileImageUrl(user.uid, url); 

    final imageUrl = await widget.profileService.getProfileImageUrl(user.uid); 

    setState(() {
      _profileImage = pickedFile; 
      _profileImageUrl = imageUrl;

      // web support
      if (kIsWeb) {
        pickedFile.readAsBytes().then((bytes) {
          setState(() {
            _webImage = bytes;
          });
        });
      } 
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

  // Open bottom sheet for choosing image source (camera/gallery)
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

  // Fetche existing profile image URL from Firestore
  Future<void> _loadProfileImage() async {
    final user = widget.authService.currentUser;
    if(user == null) return;
    final url = await widget.profileService.getProfileImageUrl(user.uid); // Get the profile image URL from Firestore for the current user
    setState(() {
      _profileImageUrl = url; // Update the state with the retrieved profile image URL to display it in the UI
    });
  }
  
  // Handles user logout after confirmation dialog
Future<void> _logoutUser() async {

  // Show logout confirmation dialog
  final confirmLogout = await showDialog(
    context: context,

    builder: (context) => const ConfirmationDialog(
      title: "Logout",
      content: "Are you sure you want to logout?",
      confirmText: "Logout",
    ),
  );

  // Stop if user cancels logout
  if (confirmLogout != true) return;

  // Sign out the current user
  await widget.authService.signOut();

  // Navigate back to login screen
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => LoginScreen(
        authService: widget.authService,
        profileService: widget.profileService
      ),
    ),
  );
}

// Handle deleting a listing after confirmation
Future<void> _deleteListing(String docId) async {

  // Show delete confirmation dialog
  final confirm = await showDialog(
    context: context,

    builder: (context) => const ConfirmationDialog(
      title: "Delete Listing",
      content: "Are you sure?",
      confirmText: "Delete",
    ),
  );

  // Stop if user cancels delete
  if (confirm != true) return;

  // Delete listing from Firestore
  await widget.firestoreService.deleteListing(docId);
}

  @override
  Widget build(BuildContext context) {
    final user = widget.authService.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      
      //logout in top right corner
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F7),
        automaticallyImplyLeading: false, // Remove the default back button from the AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF373A36)),
            onPressed: _logoutUser,
          ),
        ],
      ),
      // Main profile screen content
      body: SafeArea(
        child:user == null ? const Center(child: Text("Not logged in")) : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(        
              children: [
                // Profile header section (image + username + email)
                ProfileHeader(
                  profileImage: kIsWeb ? null : (_profileImage != null ? File(_profileImage!.path) : null),
                  profileImageUrl: _profileImageUrl,

                  username: user.email?.split('@')[0] ?? 'User',

                  email: user.email ?? 'No email',

                  onEditPhoto: _showImagePickerOptions,
                ),

                const SizedBox(height: 30), 
            
                const Divider(),
                // Listings section title
                const Text (
                  "My Listings", 
                  style:TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF373A36),
                  ),
                ),
                const Divider(),

                // Real-time user listings from Firestore
                StreamBuilder<List<ListingModel>>(
                  stream: widget.firestoreService.getUserListings(user.uid),
                  builder: (context, snapshot){
                    if (snapshot.connectionState == ConnectionState.waiting){
                      return const Center(child: CircularProgressIndicator());
                    }
                    if(!snapshot.hasData || snapshot.data!.isEmpty){
                      return const Center(child: Text("No Listings yet"));
                    }
                    final listings = snapshot.data!;

                    // Builds list of user's listings
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listings.length,
                      itemBuilder: (context, index){
                        final listing = listings[index];
                        return ProfileListingCard(
                          title: listing.title,
                          price: listing.price,
                          category: listing.category,
                          imageUrl: listing.imageUrl,

                          // Navigate to edit listing screen
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddListingScreen(
                                  docId: listing.id,
                                  title: listing.title,
                                  price: listing.price,
                                  description: listing.description,
                                  category: listing.category,
                                  contact: listing.contact,
                                  imageUrl: listing.imageUrl,
                                ),
                              ),
                            );
                          },
                          // Delete listing with confirmation
                          onDelete:() => _deleteListing(listing.id),
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