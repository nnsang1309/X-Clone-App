import 'package:app/components/my_button.dart';
import 'package:app/components/my_loading_circle.dart';
import 'package:app/components/my_text_field.dart';
import 'package:app/helper/toast_message.dart';
import 'package:app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

/*
  LOGIN PAGE

  On this page, an existing user can login in with their:
  - Email
  - Password  

  --------------------------------------------
  Once the user successfully logs in, they wil be redirected to the home page.

  If the user doesn't have an account yet, they can go to the register page from here.
*/

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // access auth service
  final _auth = AuthService();

  // Text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  // logged method
  void login() async {
    if (emailController.text.isEmpty || pwController.text.isEmpty) {
      ToastMessage().showToast('Please enter full information', ToastType.failed);
      return;
    }
    // show loading circle
    showLoadingCircle(context);

    // attempt login
    try {
      // trying to login...
      await _auth.loginEmailPassword(emailController.text, pwController.text);

      // finished loading...
      if (mounted) hideLoadingCircle(context);
    }
    // catch any errors...
    catch (e) {
      // finished loading...
      if (mounted) hideLoadingCircle(context);
      ToastMessage().showToast(e.toString(), ToastType.failed);
    }
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      // BODY
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  // Logo
                  Icon(
                    Icons.lock_open_rounded,
                    size: 72,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 50),

                  //Welcome back message
                  Text(
                    "Welcome back, you've been missed!",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // email textfield
                  MyTextField(
                    controller: emailController,
                    hintText: "Enter email",
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  // password textfield
                  MyTextField(
                    controller: pwController,
                    hintText: "Enter password",
                    obscureText: true,
                  ),

                  const SizedBox(height: 10),

                  //forgot password?
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forget password?',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  //sign in button
                  MyButton(
                    text: "Login",
                    onTap: login,
                  ),

                  const SizedBox(height: 50),

                  // not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Not a member?",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 10),

                      // User can tap this to go to register
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          "Register now",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
