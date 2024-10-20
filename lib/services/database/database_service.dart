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
import 'package:app/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/post.dart';

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

  //Update user bio
  Future<void> updateUserBioInFirebase(String bio) async {
    //get current uid
    String uid = AuthService().getCurrentUid();

    // update in firebase
    try {
      await _db.collection("Users").doc(uid).update({'bio': bio});
    } catch (e) {
      print(e);
    }
  }

  /*
  
  POST MESSAGE

  */

  // Post a message
  Future<void> postMassageInFirebase(String message) async {
    try {
      // get current uid
      String uid = _auth.currentUser!.uid;

      // use this uid to get the user's profile
      UserProfile? user = await getUserFromFirebase(uid);

      // create a new post
      Post newPost = Post(
        id: '', // firebase will auto generate this
        uid: uid,
        name: user!.name,
        username: user.username,
        message: message,
        timestamp: Timestamp.now(),
        likeCount: 0,
        likeBy: [],
      );

      // convert post object to map
      Map<String, dynamic> newPostMap = newPost.toMap();

      // add to firebase
      await _db.collection("Posts").add(newPostMap);
    } catch (e) {
      print(e);
    }
  }

  //Delete a post
  Future<void> deletePostFromFirebase(String postId) async {
    try {
      await _db.collection("Posts").doc(postId).delete();
    } catch (e) {
      print(e);
    }
  }

  // Get all posts
  Future<List<Post>> getAllPostFromFirebase() async {
    try {
      QuerySnapshot snapshot = await _db
          .collection("Posts")
          .orderBy('timestamp', descending: true)
          .get();

      //
      return snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    } catch (e) {
      return [];
    }
  }

  // Get individual post

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
