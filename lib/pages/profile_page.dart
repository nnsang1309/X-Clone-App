import 'package:app/models/user.dart';
import 'package:app/services/auth/auth_service.dart';
import 'package:app/services/database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  // user info
  UserProfile? user;
  String currentUserId = AuthService().getCurrentUid();

  // loading..
  bool _isLoading = true;

  // on startup,
  @override
  void initState() {
    super.initState();

    // let's load user info
    loadUser();
  }

  Future<void> loadUser() async {
    // get the user profile info
    user = await databaseProvider.userProfile(widget.uid);

    // finished loading..
    setState(() {
      _isLoading = false;
    });
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // SCAFFOLD
    return Scaffold(
      // APPBAR
      appBar: AppBar(
        title: Text(_isLoading || user == null ? 'Null' : user!.email),
      ),

      // BODY
      body: ListView(
          // user name handle

          // profile picture

          // profile status -> number of posts / followers / following

          // follow / unfollow button

          // bio box

          // list of posts from user
          ),
    );
  }
}
