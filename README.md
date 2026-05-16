# CampusHub
**Buy, Sell, Connect on Campus**

CampusHub is a student focused mobile marketplace built using Flutter and Firebase. It allows university students to buy and sell items or offer services within the campus community in a simple, secure and inituitive way.

Unlike Facebook marketplace and other traditional market places, CampusHub is designed specifically for students thus the listings are more relevant and users can connect with people in their immediate academica environment. 

This app allows users to create listings, browse items and services, search by category, view seller details and save favourites for later. With inetgrated authentication and cloud storage, CampusHub provides a seamless and responsive user experience across devices. 

## Project Objectives
The goal of Campushub is to create a dedicated marketplace which:
- Fosters student-to-student interaction
- Simplify buying and selling within univeristy campus
- Provide a secure and authenticated platform
- Offer real time updates and a smooth experience

## Key Features
### User Authentication
- Sign up and login using Firebase Authentication
- Secure email and password authentication
- Each user has an unique identity linked to their listings

### Listings (Full CRUD System)
- Create Listings with following information:
  - Title
  - Description
  - Price
  - Category (item/service)
  - Contact details
  - Image upload
- Read: view listings in real-time using Firestore streams
- Update: edit existing listings
- Delete: remove listings when no longer needed

### Search & Filtering
- Search listings by title
- Filter listings by category:
  - All
  - Items
  - Services

### Favourites
- Save listings using the heart icon
- Toggle favourites on/off
- View all favourite listings in a dedicated Favourites page

### Image uplaod (device feature)
- Upload images using:
  - Camera
  - Gallery
- Images stored securely on Firebase Storage
- Supports cross platform rendering (mobile and web handling included)

### Seller information
- listings display seller name
- Linked to Firebase authenticated user profile

## Target Users
CampusHub is designed specifically for university students as the primary user group. This app's focus is affordability, convenience and trust within a closed academic community.
### Student Buyers
- Students who need affordable textbooks, laptops, or other second-hand items
- These studnets make use of CampusHub to save money and find local deals within the campus quickly
### Student Sellers
- Students who want to sell their unused books, or furniture (students living on campus), electronics
- These students make use of CampusHub to reach other students who may requires these items without having to go through multiple marketplaces
### Student Service Providers
- Students who want to offer services to other students in their free time such as tutoring, photography, freelancing
- Make use of CampusHub to advertise services on campus
### Why Users will choose CampusHub:
- Items and services offered are more relevant for the users than public marketplaces
- Safer due to student-only environment
- Simple can clean mobile interface

## Technical Details
### Project Structure
- `/screens`: this folder consists of codes for all screens (UI pages)
- `/services`: this folder holds firebase logic (Firestore and Storage)
- `/models`: This folder has data models (listing model specifically)
- `/providers`: handles statement management for favourites
- `/widgets`: Reusable UI components

This architecture separates UI, logic, and data layers for maintainability.

### Test Login Details
For testing purpose, following credentials can be used:

- Email: alex.johnson@email.com 
- Password: password123  

New user account can also be created.

## Device / Platform Compatibility Notes

### Platform Testing
The application was developed and primarily tested on an **iOS Simulator (MacBook environment)**.

### Image Handling (Web vs Mobile)
Image selection and handling differ between web and mobile platforms. On mobile devices, images are handled using file-based access (`dart:io File`). On web, images are handled in-memory using `Uint8List` due to browser restrictions on file system access.

### Firebase Authentication Dependency
Firebase Storage operations require the user to be authenticated. If the authentication state is not fully initialized (particularly on web after refresh), upload operations may fail with an unauthorized error.

### Platform Permissions
- Android requires runtime permissions for camera and storage access.
- iOS requires configuration in `Info.plist` for camera and photo library access.

## Future Improvements
- In-app chat feature
- Push notifications
- User Profile Pages with ratings
- Admin moderation system

## Known Issues / Limitations
- Firebase Storage requires CORS configuration for web support 
- No direct messaging system between users yet

## Summary
CampusHub is a lightwieght but scalable mobile marketplace app designed specifically for university students using Flutter and Firebase. It demonstrates full CRUD operations, authentication, cloud storage integration, and real-time database usage in student focused environment. 
