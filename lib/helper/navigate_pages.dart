// go to user page

import 'package:app/pages/account_settings_page.dart';
import 'package:app/pages/blocked_users_page.dart';
import 'package:app/pages/profile_page.dart';
import 'package:flutter/material.dart';

import '../models/post.dart';
import '../pages/post_page.dart';

// go to user page
void goUserPage(BuildContext context, String uid) {
  // navigate to the page
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProfilePage(uid: uid),
    ),
  );
}

// go to post page
void goPostPage(BuildContext context, Post post) {
  // navigator to the post page
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PostPage(
        post: post,
      ),
    ),
  );
}

// go to blocked user page
void goBlockedusersPage(BuildContext context) {
  // navigator to the post page
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => BlockedUsersPage(),
    ),
  );
}

// go to account settings page
void goAccountSettingsPage(BuildContext context) {
  // navigator to the post page
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AccountSettingsPage(),
    ),
  );
}
