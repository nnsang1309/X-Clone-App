// ignore_for_file: avoid_print

/*

DATABASE PROVIDER

This provider is to separete the firestore data handling and the Ui of our app.

----------------------------------------

  - The database service class handless data to and from firebase
  - The database provider class processes the data to display in our app

 */

import 'package:app/models/comment.dart';
import 'package:app/models/user.dart';
import 'package:app/services/auth/auth_service.dart';
import 'package:app/services/database/database_service.dart';
import 'package:flutter/foundation.dart';

import '../../models/post.dart';

class DatabaseProvider extends ChangeNotifier {
  /*

  SERVICES
  
  */

  // get db & auth service
  final _db = DatabaseService();
  final _auth = AuthService();

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

    // initalize local like data
    initalizeLikeMap();

    // updata UI
    notifyListeners();
  }

  // filter and return posts given uid
  List<Post> fillterUserPosts(String uid) {
    return _allPosts.where((post) => post.uid == uid).toList();
  }

  // delete post
  Future<void> deletePost(String postId) async {
    try {
      // delete from firebase
      await _db.deletePostFromFirebase(postId);
      print("Post deleted success");

      // reload data from firebase
      await loadAllPosts();
      print("Posts reloaded.");
    } catch (e) {
      print(e);
    }
  }

  /*

  LIKES

  */

  // Local Map: theo dõi số lượng like cho mỗi bài đăng
  Map<String, int> _likeCounts = {
    // for each post id: like count
  };

  // Local list: theo dõi danh sách user like bài viết (post)
  List<String> _likePosts = [];

  // does current user like this post?
  bool isPostLikeByCurrentUser(String postId) => _likePosts.contains(postId);

  // get like count of a post
  int getLikeCount(String postId) => _likeCounts[postId] ?? 0;

  // initalize like map locally
  void initalizeLikeMap() {
    // get current uid
    final currentUserID = _auth.getCurrentUid();

    // clear liked posts ( for when new user signs in, clear local data)
    _likePosts.cast();

    // for each post get like data
    for (var post in _allPosts) {
      // update like count map
      _likeCounts[post.id] = post.likeCount;

      // if the current user alreadly likes this post
      if (post.likeBy.contains(currentUserID)) {
        // add this post id to local list of liked posts
        _likePosts.add(post.id);
      }
    }
  }

  // toggle like
  Future<void> toggleLike(String postId) async {
    /*
    This first part will update the local values first so that the UI feels immediate responsive. 
    Update the UI optimistically, and revert back if anything  goes wrong while writing to the database


    */

    // store original values in case it fails
    final likedPostsOriginal = _likePosts;
    final likeCountOriginal = _likeCounts;

    // perform like / unlike
    if (_likePosts.contains(postId)) {
      _likePosts.remove(postId);
      _likeCounts[postId] = (_likeCounts[postId] ?? 0) - 1;
    } else {
      _likePosts.add(postId);
      _likeCounts[postId] = (_likeCounts[postId] ?? 0) + 1;
    }

    // update UI locally
    notifyListeners();

    /*  
    Update database
    */

    // attempt like database
    try {
      await _db.toggleLikeInFirebase(postId);
    }
    // revert back to initial state id update fails
    catch (e) {
      _likePosts = likedPostsOriginal;
      _likeCounts = likeCountOriginal;

      // update Ui again
      notifyListeners();
    }
  }

  /*

  COMMENTS

  {
  postId1: [comment1, comment2, comment3,..],
  postId2: [comment1, comment2, comment3,..],
  postId3: [comment1, comment2, comment3,..],
  }

  */

  // local list of comments
  final Map<String, List<Comment>> _comments = {};

  // get comments locally
  List<Comment> getComments(String postId) => _comments[postId] ?? [];

  // fetch comments from database for a post
  Future<void> loadComments(String postId) async {
    // get all comments for this post
    final allComments = await _db.getCommentsFromFirebase(postId);

    // update local data
    _comments[postId] = allComments;

    // update UI
    notifyListeners();
  }

  // add a comment
  Future<void> addComment(String postId, message) async {
    // add comment in firebase
    await _db.addCommnetInFirebase(postId, message);

    // reload comments
    await loadComments(postId);
  }

  // delete a comment
  Future<void> deleteComment(String commentId, postId) async {
    // delete comment in firebase
    await _db.deleteCommentInFirebase(commentId);

    // reload comments
    await loadComments(postId);
  }
}
