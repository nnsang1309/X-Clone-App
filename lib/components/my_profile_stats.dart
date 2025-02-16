/*
  PROFILE STATS

  This will be displayed on the profile page



  ----------------------------------------------------------------------

  Number of:

  - posts
  - followers
  - following

 */

import 'package:flutter/material.dart';

class MyProfileStats extends StatelessWidget {
  final int postCount;
  final int followerCount;
  final int followingCount;
  final void Function()? onTap;

  const MyProfileStats({
    super.key,
    required this.postCount,
    required this.followerCount,
    required this.followingCount,
    required this.onTap,
  });

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // textstyle for count
    var textstyleForCount =
        TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.inversePrimary);
    // textstyle for text
    var textstyleForText = TextStyle(color: Theme.of(context).colorScheme.primary);
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // posts
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(
                  postCount.toString(),
                  style: textstyleForCount,
                ),
                Text(
                  'Posts',
                  style: textstyleForText,
                ),
              ],
            ),
          ),

          // followers
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(
                  followerCount.toString(),
                  style: textstyleForCount,
                ),
                Text(
                  'Follower',
                  style: textstyleForText,
                ),
              ],
            ),
          ),

          // following
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(
                  followingCount.toString(),
                  style: textstyleForCount,
                ),
                Text(
                  'Following',
                  style: textstyleForText,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
