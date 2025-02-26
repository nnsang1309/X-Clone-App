/*
  USER LIST TILE

  This is to display each user as a nice tile. 
  We will use this when we need to display a list of users, 
  for e.g. in the user search results pr viewing the followers of a user.


  ------------------------------------------------------------------------------

  To use tjhis widget, you need:

  - a user

 */

import 'package:app/models/user.dart';
import 'package:app/pages/profile_page.dart';
import 'package:flutter/material.dart';

class MyUserTile extends StatelessWidget {
  final UserProfile user;
  const MyUserTile({
    super.key,
    required this.user,
  });

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      // List tile
      child: ListTile(
        // Name
        title: Text(user.name),
        titleTextStyle: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        // Username
        subtitle: Text('@${user.username}'),
        subtitleTextStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        // Profile pic
        leading: Icon(
          Icons.person,
          color: Theme.of(context).colorScheme.primary,
        ),

        // on tap -> gp to user's page
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(uid: user.uid),
          ),
        ),

        // arrow forward icon
        trailing: Icon(
          Icons.arrow_forward,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
