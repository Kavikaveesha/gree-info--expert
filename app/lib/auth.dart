import 'package:app/navigation.dart';
import 'package:app/utils/constants/image_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'features/screen/authentication/splash_screen/splsh.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulating a delay for splash screen
    Future.delayed(Duration(seconds: 3), () async {
      // Check if the user is logged in or not using Firebase Auth
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // If user is logged in, navigate to home page
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => NavigationMenu(),
          ),
        );
      } else {
        // If user is not logged in, navigate to login screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => SplashScreen(),
          ),
        );
      }
    });
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(
                MyImages.appLogo,
              ),
              radius: 40,
            )
          ],
        ),
      ),
    );
  }
}
