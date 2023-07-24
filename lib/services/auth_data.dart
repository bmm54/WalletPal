import 'package:firebase_auth/firebase_auth.dart';

class AuthData {
  final user = FirebaseAuth.instance.currentUser;
  get getUserData {
    //a map of user data
    if (user == null) {
      return null;
    }
    Map<String, dynamic> userData = {
      "name": user!.displayName,
      "email": user!.email,
      "image": user!.photoURL,
      "id": user!.uid,
    };
    return userData;
  }
}
