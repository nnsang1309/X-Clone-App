import 'package:app/pages/login_page.dart';
import 'package:app/pages/register_page.dart';
import 'package:flutter/material.dart';

/*
  LOGIN OR REGISTER PAGE

  This determines whether to show login page or register page
*/

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  // initially, show login page
  bool showLoginPage = true;

  //toggle between login $ register
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        onTap: togglePages,
      );
    } else {
      return RegisterPage(
        onTap: togglePages,
      );
    }
  }
}
