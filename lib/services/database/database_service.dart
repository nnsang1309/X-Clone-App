// ignore_for_file: avoid_print, unnecessary_brace_in_string_interps

/*
DATABASE SERVICE

This class handles all the data from and to firebase.

--------------------------------------------------------

  - User profile
  - Post message
  - Likes
  - Commnets
  - Account stuff ( report / block / delete account )
  - Follow / unfollow
  - Search users
*/

import 'package:app/models/comment.dart';
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
  Future<void> saveUserInfoFirebase({required String name, required String email}) async {
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
      rethrow;
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

  // Delete user info
  Future<void> deleteUserInfoFromFiribase(String uid) async {
    WriteBatch batch = _db.batch();
    // delete user doc
    DocumentReference userDoc = _db.collection("Users").doc(uid);
    batch.delete(userDoc);

    // delete user posts
    QuerySnapshot userPosts = await _db.collection("Posts").where('uid', isEqualTo: uid).get();

    for (var post in userPosts.docs) {
      batch.delete(post.reference);
    }

    // delete user comments
    QuerySnapshot userCommnents =
        await _db.collection("Comments").where('uid', isEqualTo: uid).get();
    for (var comment in userCommnents.docs) {
      batch.delete(comment.reference);
    }

    // delete likes done by this user
    QuerySnapshot allPosts = await _db.collection("Posts").get();
    for (QueryDocumentSnapshot post in allPosts.docs) {
      Map<String, dynamic> postData = post.data() as Map<String, dynamic>;
      var likeBy = postData['likeBy'] as List<dynamic>? ?? [];

      if (likeBy.contains(uid)) {
        batch.update(post.reference, {
          'likeBy': FieldValue.arrayRemove([uid]),
          'likes': FieldValue.increment(-1),
        });
      }
    }

    // update followers & following records according.. (later)

    // commit batch
    await batch.commit();
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
      QuerySnapshot snapshot =
          await _db.collection("Posts").orderBy('timestamp', descending: true).get();

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

  // Like a post
  Future<void> toggleLikeInFirebase(String postId) async {
    try {
      // get current uid
      String uid = AuthService().getCurrentUid();

      // go to doc for this post
      DocumentReference postDoc = _db.collection("Posts").doc(postId);

      // excute like
      await _db.runTransaction(
        (transaction) async {
          // get post data
          DocumentSnapshot postSnapshot = await transaction.get(postDoc);

          // get like of users who like this post
          List<String> likeBy = List<String>.from(postSnapshot['likeBy'] ?? []);

          // get like count
          int currentLikeCount = postSnapshot['likes'];

          // if user has not liked this post yet -> then like
          if (!likeBy.contains(uid)) {
            // add user to like list
            likeBy.add(uid);

            // increment like count
            currentLikeCount++;
          }

          // if user has already liked this post -> then unlike
          else {
            // remove user from like list
            likeBy.remove(uid);

            // decrement like count
            currentLikeCount--;
          }
          // update post data in firebase
          transaction.update(postDoc, {
            'likes': currentLikeCount,
            'likeBy': likeBy,
          });
        },
      );
    } catch (e) {
      print(e);
    }
  }

  /*
  
  COMMENTS
  
  */

  // Add a comment a post
  Future<void> addCommnetInFirebase(String postId, message) async {
    try {
      // get current user
      String uid = _auth.currentUser!.uid;
      UserProfile? user = await getUserFromFirebase(uid);

      // create a new comment
      Comment newComment = Comment(
        id: '', // firebase will auto generate this
        postId: postId,
        uid: uid,
        name: user!.name,
        username: user.username,
        message: message,
        timestamp: Timestamp.now(),
      );

      // convert comment to map
      Map<String, dynamic> newCommentMap = newComment.toMap();

      // to store in firebase
      await _db.collection("Comments").add(newCommentMap);
    } catch (e) {
      print(e);
    }
  }

  // Delete a comment from a post
  Future<void> deleteCommentInFirebase(String commentId) async {
    try {
      await _db.collection("Comments").doc(commentId).delete();
    } catch (e) {
      print(e);
    }
  }

  // Fetch comments for a post
  Future<List<Comment>> getCommentsFromFirebase(String postId) async {
    try {
      // get comments fromm firebase
      QuerySnapshot snapshot =
          await _db.collection("Comments").where("postId", isEqualTo: postId).get();

      // return as a list of comments
      return snapshot.docs.map((doc) => Comment.fromDocument(doc)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  /*
  
  ACCOUNT STUFF

  There are requirements if you wish to publish this to the app store!
  
  */

  // Report post
  Future<void> reportUserInFirebase(String postId, userId) async {
    // get current user id
    final currentUserId = _auth.currentUser!.uid;

    // create a report map
    final report = {
      'reportedBy': currentUserId,
      'messageId': postId,
      'messageOwnerId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    };

    // update in firebase
    await _db.collection("Reports").add(report);
  }

  // Block user
  Future<void> blockUserInFirebase(String userId) async {
    // get current user id
    final currentUserId = _auth.currentUser!.uid;

    // add this user to blocked list
    await _db.collection("Users").doc(currentUserId).collection("BlockedUsers").doc(userId).set({});
  }

  // Unblock user
  Future<void> unblockUserInFirebase(String blockedUserId) async {
    // get current user id
    final currentUserId = _auth.currentUser!.uid;

    // unblock in firebase
    await _db
        .collection("Users")
        .doc(currentUserId)
        .collection("BlockedUsers")
        .doc(blockedUserId)
        .delete();
  }

  // Get list of blocked user ids
  Future<List<String>> getBlockedUidsFromFirebase() async {
    // get current user id
    final currentUserId = _auth.currentUser!.uid;

    // get data of blocked users
    final snapshot =
        await _db.collection("Users").doc(currentUserId).collection("BlockedUsers").get();

    // return as a list of uids
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  /*
  
  FOLLOW
  
  */

  // Follow user
  Future<void> followUserInFirebase(String uid) async {
    // get current logged in user
    final currentUserId = _auth.currentUser!.uid;

    // add target user to the current user's following
    await _db.collection("Users").doc(currentUserId).collection("Following").doc(uid).set({});

    // add current user to the target user's follwers
    await _db.collection("Users").doc(uid).collection("Followers").doc(currentUserId).set({});
  }

  // Unfollow user
  Future<void> unFollowUserInFirebase(String uid) async {
    // get current logged in user
    final currentUserId = _auth.currentUser!.uid;

    // remove target user from current user's following
    await _db.collection("Users").doc(currentUserId).collection("Following").doc(uid).delete();

    // remove currnet user from target user's followers
    await _db.collection("Users").doc(uid).collection("Followers").doc(currentUserId).delete();
  }

  // Get a user's followers: list of uids
  Future<List<String>> getFollowersUidsFromFirebase(String uid) async {
    // get the followers from firebase
    final snapshot = await _db.collection("Users").doc(uid).collection("Followers").get();

    // return as a nice simple list of uids
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  // Get a user's follwing: list of uids
  Future<List<String>> getFollowingUidsFromFirebase(String uid) async {
    // get the following from firebase
    final snapshot = await _db.collection("Users").doc(uid).collection("Following").get();

    // return as a nice simple list of uids
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  /*

  SEARCH

  
  */
}
