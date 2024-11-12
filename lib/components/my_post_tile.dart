/*

POST TILE

To use this widget

- the post
- a function for onPostTap ( đi đến bài post để xem comment, like,... )
- a function for onUserTap ( đi đến trang cá nhân của user )

*/

import 'package:app/models/post.dart';
import 'package:app/services/auth/auth_service.dart';
import 'package:app/services/database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyPostTile extends StatefulWidget {
  final Post post;
  final void Function()? onUserTap;
  final void Function()? onPostTap;

  const MyPostTile({
    super.key,
    required this.post,
    required this.onUserTap,
    required this.onPostTap,
  });

  @override
  State<MyPostTile> createState() => _MyPostTileState();
}

class _MyPostTileState extends State<MyPostTile> {
  // provider
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);

  /*
  LIKE
  */

  // user tapped like (or unlike)
  void _toggleLikePost() async {
    try {
      await databaseProvider.toggleLike(widget.post.id);
    } catch (e) {
      print(e);
    }
  }

  // show options for post
  void _showOptions() {
    // check if this post is owned bu the user ot not
    String currentUid = AuthService().getCurrentUid();
    final bool isOwnPost = widget.post.uid == currentUid;
    // show options
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Wrap(
              children: [
                // Bài viết thuộc sở hữu của User
                if (isOwnPost)
                  // delete button
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text("Delete"),
                    onTap: () async {
                      // pop option box
                      Navigator.pop(context);

                      // handle delete action
                      await databaseProvider.deletePost(widget.post.id);
                    },
                  )

                // Bài viết thuộc sở hữu của User khác
                else ...[
                  // report post button
                  ListTile(
                    leading: const Icon(Icons.flag),
                    title: const Text("Report"),
                    onTap: () {
                      // pop option box
                      Navigator.pop(context);

                      // handle report action
                    },
                  ),

                  // block user button
                  ListTile(
                    leading: const Icon(Icons.block),
                    title: const Text("Block User"),
                    onTap: () {
                      // pop option box
                      Navigator.pop(context);

                      // handle block action
                    },
                  )
                ],

                // cannel button
                ListTile(
                  leading: const Icon(Icons.cancel),
                  title: const Text("Cannel"),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        });
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // does the current user like this post?
    bool likeByCurrentUser = listeningProvider.isPostLikeByCurrentUser(widget.post.id);

    // listen to like count
    int likeCount = listeningProvider.getLikeCount(widget.post.id);

    // Container
    return GestureDetector(
      onTap: widget.onPostTap,
      child: Container(
        // padding outside
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),

        // padding inside
        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          // color post tile
          color: Theme.of(context).colorScheme.secondary,

          // curve corrners
          borderRadius: BorderRadius.circular(8),
        ),

        // Column
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top: profile pic / name / username
            GestureDetector(
              onTap: widget.onUserTap,
              child: Row(
                children: [
                  // personl pic
                  Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.primary,
                  ),

                  const SizedBox(width: 10),

                  // name
                  Text(
                    widget.post.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(width: 5),

                  // user name handle
                  Text(
                    '@${widget.post.username}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),

                  const Spacer(),

                  // button -> more options: delete
                  GestureDetector(
                    onTap: _showOptions,
                    child: Icon(
                      Icons.more_horiz,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // message
            Text(
              widget.post.message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),

            const SizedBox(height: 20),

            // button -> like + comment
            Row(
              children: [
                // like button
                GestureDetector(
                  onTap: _toggleLikePost,
                  child: likeByCurrentUser
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : Icon(
                          Icons.favorite_border,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                ),

                const SizedBox(width: 5),

                // like count
                Text(
                  likeCount != 0 ? likeCount.toString() : '',
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
