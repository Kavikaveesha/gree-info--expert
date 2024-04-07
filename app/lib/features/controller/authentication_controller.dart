import 'package:app/common/widgets/snack_bar/snack_bar.dart';
import 'package:app/features/screen/admin/admin_homePage.dart';
import 'package:app/navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/validators/validation.dart';
import '../screen/authentication/logIn_screen/login_screens.dart';

class AuthenticationController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Sign up method
  Future<void> signUp(String email, String fullName, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send verification email
      User? user = _auth.currentUser;
      await user!.sendEmailVerification();

      // Add user data to Firestore after email verification
      String? imageUrl = await getImageURL();
      user = _auth.currentUser;
      FirebaseFirestore.instance.collection('users').doc(user!.email).set({
        'email': user.email,
        'fullName': fullName,
        'profilePic': imageUrl,
        'mobileNumber': '',
        'address': ''
      });
    } catch (error) {
      print('Error signing up: $error');
      throw error;
    }
  }

  // Sign in method
  Future<void> signIn(String email, String password) async {
    try {
      // Check if the entered credentials match the admin credentials
      if (email == 'admin@gmail.com' && password == 'Admin123') {
        // Redirect to the admin page directly
        Get.offAll(() => AdminHomePage());
        return;
      }

      // For regular users, sign in using Firebase Authentication
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Navigate to home page after successful sign-in
      SnackbarHelper.showSnackbar(
        title: 'Login success!',
        message: 'Welcome back ',
      );

      // Redirect to another page after 3 seconds
      Future.delayed(const Duration(seconds: 2), () {
        Get.offAll(() => const NavigationMenu());
      });
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred.';
      // Check error code and set appropriate error message
      if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email address.';
      } else if (e.code == 'user-not-found') {
        errorMessage = 'User not found. Please check your email address.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password. Please try again.';
      }
      SnackbarHelper.showSnackbar(
        title: 'Login Error!',
        message: errorMessage,
        backgroundColor: Colors.red,
      );
    } catch (e) {
      print('Error occurred: $e');
      SnackbarHelper.showSnackbar(
        title: 'Login Error!',
        message: 'An unexpected error occurred',
        backgroundColor: Colors.red,
      );
    }
  }

  // Change Password method
  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    try {
      // Re-authenticate the user with their current credentials
      AuthCredential credential = EmailAuthProvider.credential(
        email: _auth.currentUser!.email!,
        password: currentPassword,
      );
      await _auth.currentUser!.reauthenticateWithCredential(credential);

      // Update the user's password
      await _auth.currentUser!.updatePassword(newPassword);
      SnackbarHelper.showSnackbar(
        title: 'Success',
        message: 'Successfully changed your password!',
      );
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuthException
      SnackbarHelper.showSnackbar(
          backgroundColor: Colors.red,
          title: 'Error',
          message: e.message.toString());
    } on FirebaseException catch (e) {
      // Handle FirebaseException
      SnackbarHelper.showSnackbar(
          backgroundColor: Colors.red,
          title: 'Error',
          message: e.message.toString());
    } catch (error) {
      // Handle other errors
      SnackbarHelper.showSnackbar(
          backgroundColor: Colors.red,
          title: 'Error',
          message: error.toString());
    }
  }

  Future<bool> isEmailVerified() async {
    User? user = _auth.currentUser;
    await user!.reload();
    user = _auth.currentUser;
    return user!.emailVerified;
  }

  // Upload defauld profile image
  Future<String?> getImageURL() async {
    final ref = FirebaseStorage.instance.ref().child('profile_images/user.png');
    String downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
  }

  // Password reset using email
  // Function to handle password reset
  Future<void> passwordReset(String email) async {
    try {
      // Send password reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      SnackbarHelper.showSnackbar(
          title: 'Password Recovery',
          message: 'Password reset link sent. Check your email.');

      // Redirect to login page after 3 seconds
      Future.delayed(Duration(milliseconds: 5), () {
        Get.to(() => const LogInScreen());
      });
    } on FirebaseException catch (e) {
      // Show error dialog if FirebaseException occurs
      SnackbarHelper.showSnackbar(
          backgroundColor: Colors.red, title: 'Eoorr', message: e.toString());
    }
  }
}
