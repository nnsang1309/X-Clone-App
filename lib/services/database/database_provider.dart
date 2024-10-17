/*

DATABASE PROVIDER

This provider is to separete the firestore data handling and the Ui of our app.

----------------------------------------

  - The database service class handless data to and from firebase
  - The database provider class processes the data to display in our app

 */

import 'package:app/models/user.dart';
import 'package:app/services/database/database_service.dart';
import 'package:flutter/foundation.dart';

class DatabaseProvider extends ChangeNotifier {
  /*

  SERVICES
  
  */

  // get db & auth service
  final _db = DatabaseService();

  /*

  SERVICES
  
  */

  // get user profile given uid
  Future<UserProfile?> userProfile(String uid) => _db.getUserFromFirebase(uid);

  // update user bio
  Future<void> updateBio(String bio) => _db.updateUserBioInFirebase(bio);
}
