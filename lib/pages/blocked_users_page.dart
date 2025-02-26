/*

  BLOCKED USERS PAGE

  This page display a list of users that have been blocked.

  - You can unblock user here
 */

import 'package:app/services/database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BlockedUsersPage extends StatefulWidget {
  const BlockedUsersPage({super.key});

  @override
  State<BlockedUsersPage> createState() => _BlockedUsersPageState();
}

class _BlockedUsersPageState extends State<BlockedUsersPage> {
  // prodiver
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);

  // on startup,
  @override
  void initState() {
    super.initState();

    // load blocked users list
    loadBlockedUsers();
  }

  // load blocked users
  Future<void> loadBlockedUsers() async {
    await databaseProvider.loadBlockedUsers();
  }

  // show confirm unblock box
  void _showUnblockConfirmationBox(String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Unblock User"),
        content: const Text("Are you sure you want to unblock this user?"),
        actions: [
          // cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          // unblock button
          TextButton(
            onPressed: () async {
              // unblock user
              await databaseProvider.unBlockUser(userId);

              // close box
              if (context.mounted) {
                Navigator.pop(context);
              }

              // let user know it was successfully reported
              if (context.mounted) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text("User unblocked!")));
              }
            },
            child: const Text("Unblock"),
          ),
        ],
      ),
    );
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // listen to blocked users
    final blockedUsers = listeningProvider.blockedUsers;
    // SCAFFOLD
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      // App Bar
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Blocked Users"),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      // Body
      body: blockedUsers.isEmpty
          ? const Center(
              child: Text("No blocked users.."),
            )
          : ListView.builder(
              itemCount: blockedUsers.length,
              itemBuilder: (context, index) {
                // get each user
                final user = blockedUsers[index];

                // return as a ListTile UI
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text('@${user.username}'),
                  trailing: IconButton(
                    onPressed: () => _showUnblockConfirmationBox(user.uid),
                    icon: const Icon(Icons.block),
                  ),
                );
              }),
    );
  }
}
