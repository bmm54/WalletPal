import 'package:bstable/models/appUser.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on firebase user
  AppUser _userFromFirebaseUser(User user) {
    return AppUser(
        uid: user.uid,
        image: user.photoURL,
        name: user.displayName,
        email: user.email);
  }

  // auth change user stream
  Stream<AppUser> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user!));
  }

  authStateChanges() {
    return _auth.authStateChanges();
  }

  //sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  /*Future signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential user = await _auth.signInWithCredential(credential);
      User _user = user.user!;
      print(_user.displayName);
      return _user;
    } catch (e) {
      print("THE ERROR  :  "+e.toString());
      return null;
    }
  }*/

  Future<void> signInWithGoogle (
    void Function(String errorMessage) errorCallback,
) async {
    try {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication? googleAuth = await googleUser!.authentication;
        final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth!.accessToken,
            idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
    }
    on PlatformException catch (e) {
        if (e.code == GoogleSignIn.kNetworkError) {
            String errorMessage = "A network error (such as timeout, interrupted connection or unreachable host) has occurred.";
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
      print('error signing out');
      return null;
    }
  }
}
