import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future signInWithGoogle(BuildContext context) async {
  try {
    // Trigger the Google Sign-In flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      // User canceled the sign-in
      return;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential for Firebase
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in to Firebase with the credential
    await FirebaseAuth.instance.signInWithCredential(credential);

    // Navigate to the home screen on success
    Navigator.of(context).pushReplacementNamed('home');
  } catch (e) {
    // Log and handle the error
    print('Google Sign-In failed: $e');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sign-In Failed'),
        content: Text('$e'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
