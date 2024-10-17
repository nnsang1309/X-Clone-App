/*
DATABASE SERVICE

This class handles all the data from and to firebase.

--------------------------------------------------------

  - User profile
  - Post message
  Likes
  - Commnets
  - Account stuff ( report / block / delete account )
  - Follow / unfollow
  - Search users
*/

import 'package:app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  //get instance of firestore db & auth
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  /*
  
  USER PROFILE

  When a new user register, we create an account for them, but let's also store
  their details in the database to display on their profile page.

  
  */

  // Save user info
  Future<void> saveUserInfoFirebase(
      {required String name, required String email}) async {
    try {
      // get current uid
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception("No user is currently signed in.");
      }
      String uid = currentUser.uid;

      // extract username from email
      String username = email.split('@')[0];
      // e.g. admin@gmail.com -> username: admin

      // create a user profile
      UserProfile user = UserProfile(
        uid: uid,
        name: name,
        email: email,
        username: username,
        bio: '',
      );

      // convert user into a map so that we can store in firebase
      final userMap = user.toMap();

      // Print user data before saving to Firestore
      print('User Data: ${userMap}');

      // save user info in firebase
      await _db.collection("Users").doc(uid).set(userMap);
      print("User info saved to Firestore successfully.");
    } catch (e) {
      print("Error saving user info: $e");
      throw e;
    }
  }

  // Get user info
  Future<UserProfile?> getUserFromFirebase(String uid) async {
    try {
      // retrieve user doc from firebase
      DocumentSnapshot userDoc = await _db.collection('Users').doc(uid).get();

      // Check if the document exists
      if (!userDoc.exists) {
        return null;
      }

      // convert doc to user profile
      return UserProfile.fromDocument(userDoc);
    } catch (e) {
      print(e);
      return null;
    }
  }

  /*
  
  POST MESSAGE

  
  */

  /*
  
  LIKES

  
  */

  /*
  
  COMMENTS

  
  */

  /*
  
  ACCOUNT STUFF

  
  */

  /*
  
  FOLLOW

  
  */

  /*
  
  SEARCH

  
  */
}
