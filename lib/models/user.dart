/*

USER PROFILE

This is what every user should have for their profile.

-----------------------------------------

  - uid
  - name
  - email
  - username
  - bio
  - profile photo (we'll do at the end since it requires extra stuff... )

*/

import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String username;
  final String bio;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.username,
    required this.bio,
  });

  /*
  firebase -> app

  convert firestore document to a user profile
  */

  factory UserProfile.fromDocument(DocumentSnapshot doc) {
    return UserProfile(
      uid: doc['uid'],
      name: doc['name'],
      email: doc['email'],
      username: doc['username'],
      bio: doc['bio'],
    );
  }

  /*
  app -> firebase

  convert a user profile to a map
  */
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'username': username,
      'bio': bio,
    };
  }
}
