/*

DATABASE PROVIDER

This provider is to separete the firestore data handling and the Ui of our app.

----------------------------------------

  - The database service class handless data to and from firebase
  - The database provider class processes the data to display in our app

 */

import 'package:app/models/user.dart';
import 'package:app/services/database/database_service.dart';
import 'package:flutter/foundation.dart';

import '../../models/post.dart';

class DatabaseProvider extends ChangeNotifier {
  /*

  SERVICES
  
  */

  // get db & auth service
  final _db = DatabaseService();

  /*

  USER PROFILE
  
  */

  // get user profile given uid
  Future<UserProfile?> userProfile(String uid) => _db.getUserFromFirebase(uid);

  // update user bio
  Future<void> updateBio(String bio) => _db.updateUserBioInFirebase(bio);

  /*

  POST

  */

  // local list of posts
  List<Post> _allPosts = [];

  // get posts
  List<Post> get allPosts => _allPosts;

  // post message
  Future<void> postMessage(String message) async {
    // post message in firebase
    await _db.postMassageInFirebase(message);

    // reload data from firebase
    await loadAllPosts();
  }

  // fetch all posts
  Future<void> loadAllPosts() async {
    // fetch all posts from firebase
    final allPosts = await _db.getAllPostFromFirebase();

    // update local data
    _allPosts = allPosts;

    // updata UI
    notifyListeners();
  }

  // filter and return posts given uid
  List<Post> fillterUserPosts(String uid) {
    return _allPosts.where((post) => post.uid == uid).toList();
  }

  // delete post
  Future<void> deletePost(String postId) async {
    // delete from firebase
    await _db.deletePostFromFirebase(postId);

    // reload data from firebase
    await loadAllPosts();
  }
}
