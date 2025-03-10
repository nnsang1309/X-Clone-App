import 'package:app/components/my_bio_box.dart';
import 'package:app/components/my_follow_button.dart';
import 'package:app/components/my_input_alert_box.dart';
import 'package:app/components/my_post_tile.dart';
import 'package:app/components/my_profile_stats.dart';
import 'package:app/models/user.dart';
import 'package:app/pages/follow_list_page.dart';
import 'package:app/services/auth/auth_service.dart';
import 'package:app/services/database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helper/navigate_pages.dart';

/*

PROFILE PAGE

This is a profile page for given uid

 */

class ProfilePage extends StatefulWidget {
  // uid
  final String uid;
  const ProfilePage({
    super.key,
    required this.uid,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // providers
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);

  // user info
  UserProfile? user;
  String currentUserId = AuthService().getCurrentUid();

  // text controller for bio
  final bioTextController = TextEditingController();

  // loading..
  bool _isLoading = true;

  // isFollowing state
  bool _isFollowing = false;

  // on startup,
  @override
  void initState() {
    super.initState();

    // let's load user info
    loadUser();
  }

  // load User
  Future<void> loadUser() async {
    // get the user profile info
    user = await databaseProvider.userProfile(widget.uid);

    // update following state
    _isFollowing = databaseProvider.isFollowing(widget.uid);

    // load followers & following for this user
    await databaseProvider.loadUserFollowers(widget.uid);
    await databaseProvider.loadUserFollowing(widget.uid);

    // finished loading. .
    setState(() {
      _isLoading = false;
    });
  }

  // show edit bio box
  void _showEditBioBox() {
    showDialog(
      context: context,
      builder: (context) => MyInputAlertBox(
          textController: bioTextController,
          hintText: "Edit bio...",
          onPressed: saveBio,
          onPressedText: "Save"),
    );
  }

  // save update bio
  Future<void> saveBio() async {
    // start loading..
    setState(() {
      _isLoading = true;
    });

    // update bio
    await databaseProvider.updateBio(bioTextController.text);

    // reload user
    await loadUser();

    // done loading
    setState(() {
      _isLoading = false;
    });
  }

  // toggle follow -> follow / unfollow
  Future<void> toggleFollow() async {
    // unfollow

    if (_isFollowing) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Unfollow'),
          content: const Text('Are you sure you want to unfollow?'),
          actions: [
            // cancel
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),

            // yes
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                // perform unfollow
                await databaseProvider.unfollowUser(widget.uid);
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      );
    }
    // follow
    else {
      await databaseProvider.followUser(widget.uid);
    }

    // update isFollowing state
    setState(() {
      _isFollowing = !_isFollowing;
    });
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // listen to user posts
    final allUserPosts = listeningProvider.fillterUserPosts(widget.uid);

    // listen to followers && following count
    final followerCount = listeningProvider.getFollowerCount(widget.uid);
    final followingCount = listeningProvider.getFollowingCount(widget.uid);

    // listen to is following
    _isFollowing = listeningProvider.isFollowing(widget.uid);
    // SCAFFOLD
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      // APPBAR
      appBar: AppBar(
        centerTitle: true,
        title: Text(_isLoading || user == null ? '' : user!.name),
        foregroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          onPressed: () => goHomePage(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),

      // BODY
      body: ListView(
        children: [
          // user name handle
          Center(
            child: Text(
              _isLoading ? '' : '@${user!.username}',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),

          const SizedBox(height: 25),
          // profile picture
          Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(21)),
              padding: const EdgeInsets.all(25),
              child: Icon(
                Icons.person,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),

          const SizedBox(height: 25),

          // profile status -> number of posts / followers / following
          MyProfileStats(
            postCount: allUserPosts.length,
            followerCount: followerCount,
            followingCount: followingCount,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FollowListPage(uid: widget.uid),
                )),
          ),

          // follow / unfollow button
          // only show if the user is viewing someone else' profile
          if (user != null && user!.uid != currentUserId)
            MyFollowButton(
              onPressed: toggleFollow,
              isFollowing: _isFollowing,
            ),

          // edit bio
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // text
                Text(
                  "Bio",
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),

                // button
                // only show edit button if it's current user page
                if (user != null && user!.uid == currentUserId)
                  GestureDetector(
                    onTap: _showEditBioBox,
                    child: Icon(
                      Icons.settings,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // bio box
          MyBioBox(text: _isLoading ? '...' : user!.bio),

          //
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 25),
            child: Text(
              "Posts",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),

          // list of posts from user
          allUserPosts.isEmpty
              ?

              // user post in empty
              const Center(
                  child: Text("No posts yet.."),
                )
              :

              // user post in NOT empty
              ListView.builder(
                  itemCount: allUserPosts.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (contcontext, index) {
                    // get individual post
                    final post = allUserPosts[index];

                    // post tile UI
                    return MyPostTile(
                      post: post,
                      onUserTap: () {},
                      onPostTap: () => goPostPage(context, post),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
