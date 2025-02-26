/*
  FOLLOW LIST PAGE

  This page displays a tab bar for (a  given uid);

  - a list of all followers
  - a list of all following

 */

import 'package:app/components/my_user_tile.dart';
import 'package:app/models/user.dart';
import 'package:app/services/database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FollowListPage extends StatefulWidget {
  final String uid;
  const FollowListPage({
    super.key,
    required this.uid,
  });

  @override
  State<FollowListPage> createState() => _FollowListPageState();
}

class _FollowListPageState extends State<FollowListPage> {
  // providers
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);

  // on startup
  @override
  void initState() {
    super.initState();

    // load followers list
    loadFollowerList();
    // load following list
    loadFollowingList();
  }

  // load followers
  Future<void> loadFollowerList() async {
    await databaseProvider.loadUserFollowersProfiles(widget.uid);
  }

  // load following
  Future<void> loadFollowingList() async {
    await databaseProvider.loadUserFollowingProfiles(widget.uid);
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // listen to followers & following
    final followers = listeningProvider.getListOfFollowersProfile(widget.uid);
    final following = listeningProvider.getListOfFollowingProfile(widget.uid);
    // TAB CONTROLLER
    return DefaultTabController(
      length: 2,
      // SCAFFOLD
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          foregroundColor: Theme.of(context).colorScheme.primary,
          // Tab bar
          bottom: TabBar(
            dividerColor: Colors.transparent,
            labelColor: Theme.of(context).colorScheme.inversePrimary,
            unselectedLabelColor: Theme.of(context).colorScheme.primary,
            indicatorColor: Theme.of(context).colorScheme.secondary,
            // Tabs
            tabs: const [
              Tab(text: 'Followers'),
              Tab(text: 'Following'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildUserList(followers, 'No followers...'),
            _buildUserList(following, 'No following...')
          ],
        ),
      ),
    );
  }

  Widget _buildUserList(List<UserProfile> userList, String emptyMessage) {
    return userList.isEmpty
        ?
        // empty message if there are no users
        Center(
            child: Text(emptyMessage),
          )
        :
        // User List
        ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              // get each user
              final user = userList[index];

              // return as a user list tile
              return MyUserTile(user: user);
            },
          );
  }
}
