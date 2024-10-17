import 'package:firebase_auth/firebase_auth.dart';

/*

  AUTHENTICATION SERVICE

  This handles everything to do with authentication in firebase

  -------------------------------------------

  - Login
  - Register
  - Logout
  - Delete account (required if you want to publish to app store)

*/

class AuthService {
  // get instance of the auth
  final _auth = FirebaseAuth.instance;

  // get current user & uid
  User? getCurrentUser() => _auth.currentUser;
  String getCurrentUid() => _auth.currentUser!.uid;

  // logiin -> email & pw
  Future<UserCredential> loginEmailPassword(String email, password) async {
    // attempt login
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    }

    // catch any errors...
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // register -> email & pw
  Future<UserCredential> registerEmailPassword(
      String email, String password) async {
    // attempt to register new user
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    }
    // catch any errors...
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // delete account
}
