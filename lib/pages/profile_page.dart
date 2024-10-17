import 'package:app/components/my_bio_box.dart';
import 'package:app/components/my_input_alert_box.dart';
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

  // text controller for bio
  final bioTextController = TextEditingController();

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

    // finished loading. .
    setState(() {
      _isLoading = false;
    });
  }

  // show edit bio box
  void _showEditBioBox() {
    showDialog(
      context: context,
      builder: (context) => MyInputAlertBox(
          textController: bioTextController,
          hintText: "Edit bio...",
          onPressed: saveBio,
          onPressedText: "Save"),
    );
  }

  // save update bio
  Future<void> saveBio() async {
    // start loading..
    setState(() {
      _isLoading = true;
    });

    // update bio
    await databaseProvider.updateBio(bioTextController.text);

    // reload user
    await loadUser();

    // done loading
    setState(() {
      _isLoading = false;
    });
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // SCAFFOLD
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      // APPBAR
      appBar: AppBar(
        title: Text(_isLoading || user == null ? 'Null' : user!.name),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),

      // BODY
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: ListView(
          children: [
            // user name handle
            Center(
              child: Text(
                _isLoading ? '' : '@${user!.username}',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),

            const SizedBox(height: 25),
            // profile picture
            Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(21)),
                padding: const EdgeInsets.all(25),
                child: Icon(
                  Icons.person,
                  size: 72,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // profile status -> number of posts / followers / following

            // follow / unfollow button

            // edit bio
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Bio",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: _showEditBioBox,
                  child: Icon(
                    Icons.settings,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // bio box
            MyBioBox(text: _isLoading ? '...' : user!.bio),

            // list of posts from user
          ],
        ),
      ),
    );
  }
}
