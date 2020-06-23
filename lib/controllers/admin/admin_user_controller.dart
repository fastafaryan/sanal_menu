import 'package:flutter/cupertino.dart';
import 'package:sanal_menu/controllers/base_controller.dart';
import 'package:sanal_menu/models/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminUserController extends ChangeNotifier with BaseController {
  User user;
  AsyncSnapshot snapshot;

  void setName(String value) {
    user.name = value;
    notifyListeners();
  }

  void setEmail(String value) {
    user.email = value;
    notifyListeners();
  }

  void setRole(String value) {
    user.role = value;
    notifyListeners();
  }

  Future<FunctionFeedback> addEditUser() async {
    // update user if user.id exists
    if (user.id != null) {
      usersCollection.document(user.id).updateData({'email': user.email, 'name': user.name, 'role': user.role});
        return FunctionFeedback(type: MessageTypes.success, message: "User has been edited successfully.");

    } else {
      // Else try to create a new user.
      try {
        FirebaseApp app = await FirebaseApp.configure(name: 'Secondary', options: await FirebaseApp.instance.options);
        AuthResult result = await FirebaseAuth.fromApp(app).createUserWithEmailAndPassword(email: user.email, password: "1234567");
        Firestore.instance
            .collection("users")
            .document(result.user.uid)
            .setData({"uid": result.user.uid, "name": user.name, "email": user.email, "role": user.role});
        return FunctionFeedback(type: MessageTypes.success, message: "User has been added successfully.");
      } catch (e) {
        return FunctionFeedback(type: MessageTypes.error, message: e.message);
      }
    }
    return FunctionFeedback(type: MessageTypes.info, message: "Something went wrong.");
  }

  Future deleteUser(String userID) async {
    //FirebaseApp app = await FirebaseApp.configure(name: 'Secondary', options: await FirebaseApp.instance.options);
    // await FirebaseAuth.instance.signInWithEmailAndLink()

    QuerySnapshot query = await usersCollection.where('uid', isEqualTo: userID).getDocuments();
    print("deleting " + userID);
    query.documents.forEach((user) {
      usersCollection.document(user.documentID).delete();
      print("deleted" + user.data['email']);
    });
    return "User has been deleted.";
  }
}
