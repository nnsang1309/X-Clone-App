import 'package:app/components/my_settings_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/themes/theme_provider.dart';

/*
  SETTING PAGE

  -Dark mode
  - Blocked Users
  - Accoount settings
*/

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      //App bar
      appBar: AppBar(
        title: const Text("S E T T I N G S"),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),

      //Body
      body: Column(
        children: [
          //Dark mode
          MySettingsTile(
            title: "Dark mode",
            action: CupertinoSwitch(
              onChanged: (value) =>
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme(),
              value:
                  Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
            ),
          ),

          //Block user

          //Account setting
        ],
      ),
    );
  }
}
