import 'package:app/components/my_drawer_tile.dart';
import 'package:app/pages/profile_page.dart';
import 'package:app/pages/search_page.dart';
import 'package:app/pages/settings_page.dart';
import 'package:app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

/*
DRAWER

This is a menu drawer which is usually access on the left sode of the app bar

Contains 5 menu options:
 - Home
 - Profile
 - Search
 - Settings
 - Logout

 */

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  // access auth service
  final _auth = AuthService();

  // logout
  void logout() {
    _auth.logout();
  }

  //BUILD UI
  @override
  Widget build(BuildContext context) {
    //Drawer
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              //app logo
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Icon(
                  Icons.person,
                  size: 72,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              //divider line
              Divider(
                color: Theme.of(context).colorScheme.secondary,
              ),

              const SizedBox(
                height: 10,
              ),

              //home list title
              MyDrawerTile(
                title: 'Home',
                icon: Icons.home,
                onTap: () {
                  // pop menu drawer since we are already at home
                  Navigator.pop(context);
                },
              ),

              //profile list title
              MyDrawerTile(
                title: "Profile",
                icon: Icons.person,
                onTap: () {
                  // pop menu drawer
                  Navigator.pop(context);
                  // go to profile page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(uid: _auth.getCurrentUid()),
                    ),
                  );
                },
              ),

              //search list title
              MyDrawerTile(
                title: "Search",
                icon: Icons.search,
                onTap: () {
                  // pop menu drawer
                  Navigator.pop(context);

                  //go to search page
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchPage(),
                      ));
                },
              ),

              //setttings list title
              MyDrawerTile(
                title: "Settings",
                icon: Icons.settings,
                onTap: () {
                  // pop menu drawer
                  Navigator.pop(context);

                  //go to settings page
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ));
                },
              ),

              const Spacer(),

              //logout list title
              MyDrawerTile(
                title: "LOGOUT",
                icon: Icons.logout,
                onTap: logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
