import 'package:flutter/material.dart';
import 'package:campushub/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'package:campushub/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService(); // Instance of the AuthService to handle authentication-related operations
  
  Widget _buildProfileListingCard(String docId, Map<String, dynamic>data){
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
            child: const Icon(Icons.image),
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
                  "\${data['price'] ?? ''}",
                  style: const TextStyle(color:Colors.red),
                ),
              ],
            ),
          ),

          // Actions - Edit and update to add later
          Column(
            children:[
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // to do - allow user to make changes to their listing
                }
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed:() {
                  // to do - allow user to delete their listing
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
      body: Column(
        
          children: [
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

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
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
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    itemCount: listings.length,
                    itemBuilder: (context, index){
                      final data = listings[index].data() as Map<String, dynamic>;

                      return _buildProfileListingCard(listings[index].id, data);
                    },
                  );
                },
              ),
            ),

            ElevatedButton(
              onPressed: () async {
                await _authService.signOut(); // Call the signOut method from AuthService to log the user out
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()), // Navigate to the LoginScreen after logging out
                );
              },
              child: const Text("Logout"), // Text for the logout button
            ),
          ],
        ),  
      );
  }
}