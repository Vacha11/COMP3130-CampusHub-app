import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart';
import 'providers/favourite_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'services/favourite_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:campushub/services/user_profile_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (_) => FavouriteProvider(
        favouriteService: FavouriteService(),
        auth: FirebaseAuth.instance,
      ), // Provide the FavouriteProvider to the widget tree
      child:const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusHub',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFA6192E)),
        fontFamily: "WorkSans",
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(profileService: UserProfileService(
        firestore: FirebaseFirestore.instance,
        storage: FirebaseStorage.instance,
      )),
    );
  }
}


