/*

  COMMENT TILE

  To use this widget
  
  - the comment
  - a function (for when the user taps and wants to go to the user profile os this comment)

 */

import 'package:app/models/comment.dart';
import 'package:app/services/database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth/auth_service.dart';

class MyCommentTile extends StatelessWidget {
  final Comment comment;
  final void Function()? onUserTap;

  const MyCommentTile({
    super.key,
    required this.comment,
    required this.onUserTap,
  });

  // show options for comment
  void _showOptions(BuildContext context) {
    // check if this post is owned bu the user ot not
    String currentUid = AuthService().getCurrentUid();
    final bool isOwnComment = comment.uid == currentUid;
    // show options
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Wrap(
              children: [
                // Comment thuộc sở hữu của User
                if (isOwnComment)
                  // delete comment button
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text("Delete"),
                    onTap: () async {
                      // pop option box
                      Navigator.pop(context);

                      // handle delete action
                      await Provider.of<DatabaseProvider>(context, listen: false)
                          .deleteComment(comment.id, comment.postId);
                    },
                  )

                // Bình luận thuộc sở hữu của User khác
                // This comment does not belong to user
                else ...[
                  // report comment button
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

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding outside
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),

      // padding inside
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        // color post tile
        color: Theme.of(context).colorScheme.tertiary,

        // curve corrners
        borderRadius: BorderRadius.circular(8),
      ),

      // Column
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top: profile pic / name / username
          GestureDetector(
            onTap: onUserTap,
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
                  comment.name,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(width: 5),

                // user name handle
                Text(
                  '@${comment.username}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),

                const Spacer(),

                // button -> more options: delete
                GestureDetector(
                  onTap: () => _showOptions(context),
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
            comment.message,
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ],
      ),
    );
  }
}
