/*
 
  POST PAGE

  This page display

  - individual post
  - comments on this post

*/

import 'package:app/components/my_post_tile.dart';
import 'package:app/helper/navigate_pages.dart';
import 'package:flutter/material.dart';

import '../models/post.dart';

class PostPage extends StatefulWidget {
  final Post post;

  const PostPage({
    super.key,
    required this.post,
  });

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // SCAFFOLD
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),

      // body
      body: ListView(
        children: [
          // post
          MyPostTile(
            post: widget.post,
            onUserTap: () => goUserPage(context, widget.post.uid),
            onPostTap: () {},
          ),

          // comment on this post
        ],
      ),
    );
  }
}
