import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:orbitpatter/data/models/user.dart';

class AuthRepository {
  Future<User> signInWithGoogle() async {
    try {
      String? serverClientId = dotenv.env['serverClientId'];

      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize(serverClientId: serverClientId);

      final GoogleSignInAccount? googleUser = await googleSignIn.authenticate();
      if (googleUser == null) {
        throw Exception('Google sign-in aborted by user');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final UserCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      final firebaseUser = UserCredential.user;


      if (firebaseUser == null) {
        throw Exception('Failed to sign in with Google');
      }

      final userMap = {
        'uid': firebaseUser.uid,
        'name': firebaseUser.displayName ?? '',
        'email': firebaseUser.email ?? '',
        'photoUrl': firebaseUser.photoURL ?? '',
        'bio': null,
        'createdAt': Timestamp.now(),
      };

      return User.fromMap(userMap);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw Exception('Google Sign-In was canceled by the user');
      }
      throw Exception('Google Sign-In failed: ${e.toString()}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> isSignedIn() async {
    final user = FirebaseAuth.instance.currentUser;
    return user != null;
  }


  Future<void> signOut() {
    return Future.wait([
      FirebaseAuth.instance.signOut(),
      GoogleSignIn.instance.signOut(),
    ]);
  }
}
