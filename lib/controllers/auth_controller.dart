import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> getCurrentUserId() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user == null) return null;
    return user.uid;
  }

  // sign in anonymously
  Future signInAnonymously() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email & password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password).then((currentUser) {
        if (currentUser == null) {
          print("null current user");
        } else {
          Firestore.instance
              .collection("users")
              .document(currentUser.user.uid)
              .setData({"uid": currentUser.user.uid, "name": 'Root Admin', "email": email, "role": 'Admin'});
        }
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      FirebaseUser previousUser = await FirebaseAuth.instance.currentUser();
      if (previousUser.isAnonymous) previousUser.delete();

      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e);
      return null;
    }
  }

  // delete user
  Future deleteUser() async {
    try {
      FirebaseUser user = await _auth.currentUser();
      if (user != null) await user.delete();
      return null;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
