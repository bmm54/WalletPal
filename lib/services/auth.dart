import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  

  authStateChanges() {
    return _auth.authStateChanges();
  }

  //sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      if (user != null) {
        final String uid = user.uid;
        final String? name = user.displayName;
        final String? photoURL = user.photoURL;

        // Save name and email to Firestore under the document with the user's UID
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'id': uid,
          'name': name,
          'image': photoURL,
        });
      }
      return user;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<void> signInWithGoogle(
    void Function(String errorMessage) errorCallback,
  ) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth!.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user != null) {
        final String uid = user.uid;
        final String? name = user.displayName;
        final String? photoURL = user.photoURL;

        // Save name and email to Firestore under the document with the user's UID
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'id': uid,
          'name': name,
          'image': photoURL,
        });
      }
    } on PlatformException catch (e) {
      if (e.code == GoogleSignIn.kNetworkError) {
        String errorMessage =
            "A network error (such as timeout, interrupted connection or unreachable host) has occurred.";
        errorCallback(errorMessage);
      } else {
        String errorMessage = "Something went wrong.";
        errorCallback(errorMessage);
      }
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      debugPrint('error signing out');
      return null;
    }
  }
}
