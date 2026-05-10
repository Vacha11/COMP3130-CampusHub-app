import 'dart:io';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final File? profileImage;
  final String? profileImageUrl;
  final String username;
  final String email;
  final VoidCallback onEditPhoto;

  const ProfileHeader({
    super.key,
    required this.profileImage,
    required this.profileImageUrl,
    required this.username,
    required this.email,
    required this.onEditPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Profile image with edit button
        GestureDetector(
          onTap: onEditPhoto,

          child: Stack(
            children: [
              CircleAvatar(
                radius: 55,
                backgroundColor: Colors.grey[300],

                // Display local image first, otherwise network image
                backgroundImage: profileImage != null
                    ? FileImage(profileImage!)
                    : (profileImageUrl != null
                        ? NetworkImage(profileImageUrl!)
                        : null) as ImageProvider?,

                child: profileImage == null && profileImageUrl == null
                    ? const Icon(
                        Icons.person,
                        size: 55,
                        color: Color(0xFF373A36),
                      )
                    : null,
              ),

              // Edit icon
              Positioned(
                bottom: 0,
                right: 0,

                child: Container(
                  padding: const EdgeInsets.all(6),

                  decoration: const BoxDecoration(
                    color: Color(0xFFA6192E),
                    shape: BoxShape.circle,
                  ),

                  child: const Icon(
                    Icons.edit,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Username
        Text(
          username,

          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF373A36),
          ),
        ),

        const SizedBox(height: 5),

        // Email
        Text(
          email,

          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}