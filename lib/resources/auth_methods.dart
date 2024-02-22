import 'dart:typed_data';
import 'package:instagram/models/user.dart' as model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserdetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('user').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  // sign up user

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
         // register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);

        String downloadurl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        // add user to our database

        model.User user = model.User(
          email: email,
          uid: cred.user!.uid,
          photoUrl: downloadurl,
          username: username,
          bio: bio,
          followers: [],
          following: [],
          // comments: [],
          // likes: []
        );

        await _firestore.collection('user').doc(cred.user!.uid).set(
              user.toJson(),
            );

// await _firestore.collection('user').add({
//    'username':username,
//   'uid':cred.user!.uid,
//   'email':email,
//   'bio':bio,
//   'followers':[],
//   'following':[],
// });
        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Logging user
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    }
    on FirebaseAuthException catch (e){
      if(e.code=='password'){

      }
    }

    catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
