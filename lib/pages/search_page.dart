import 'package:app/components/my_user_tile.dart';
import 'package:app/services/database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/*
  SEARCH PAGE

  User can search for any user in the database
 */

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // text controller
  final _seachController = TextEditingController();
  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // provider
    final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
    final listeningProvider = Provider.of<DatabaseProvider>(context);

    // SCAFFOLD
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: TextField(
          controller: _seachController,
          decoration: InputDecoration(
            hintText: 'Search users...',
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
            border: InputBorder.none,
          ),

          // search will begin after each new character has been type
          onChanged: (value) {
            // search users
            if (value.isNotEmpty) {
              databaseProvider.searchUsers(value);
            }

            //clear results
            else {
              databaseProvider.searchUsers("");
            }
          },
        ),
      ),
      body: listeningProvider.searchResult.isEmpty
          ?
          // no users found..

          const Center(
              child: Text('No users found..'),
            )
          :
          // Users found!
          ListView.builder(
              itemCount: databaseProvider.searchResult.length,
              itemBuilder: (context, index) {
                // get each user form search result
                final user = listeningProvider.searchResult[index];

                // return as user tile
                return MyUserTile(user: user);
              }),
    );
  }
}
