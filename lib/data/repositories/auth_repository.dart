import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:orbitpatter/core/services/notification_service.dart';
import 'package:orbitpatter/core/utils/logger.dart';
import 'package:orbitpatter/data/models/user.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final NotificationService _notificationService;

  // Add NotificationService to constructor
  AuthRepository(this._notificationService);

  Future<UserModel> signInWithGoogle() async {
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

      final UserCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      final firebaseUser = UserCredential.user;

      if (firebaseUser == null) {
        throw Exception('Failed to sign in with Google');
      }

      // Get current device FCM token (may be null)
      final String? currentFcmToken = await _notificationService.getToken();

      final userDoc = await _firebaseFirestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();
      Map<String, dynamic> userMap;

      //Store user to Users collection
      if (!userDoc.exists) {
        userMap = {
          'uid': firebaseUser.uid,
          'name': firebaseUser.displayName ?? '',
          'email': firebaseUser.email ?? '',
          'photoUrl': firebaseUser.photoURL ?? '',
          'bio': null,
          'createdAt': Timestamp.now(),
          'fcmtTokens': currentFcmToken != null ? [currentFcmToken] : <String>[],
        };
        await _firebaseFirestore
            .collection('users')
            .doc(firebaseUser.uid)
            .set(userMap);
      } else {
        userMap = {
          ...userDoc.data()!,
          'name': firebaseUser.displayName ?? '',
          'email': firebaseUser.email ?? '',
          'photoUrl': firebaseUser.photoURL ?? '',
        };
        // Update user basic info
        await _firebaseFirestore
            .collection('users')
            .doc(firebaseUser.uid)
            .update({
              'name': firebaseUser.displayName ?? '',
              'email': firebaseUser.email ?? '',
              'photoUrl': firebaseUser.photoURL ?? '',
            });

        // Add current FCM token to fcmtTokens if present and not already stored
        if (currentFcmToken != null) {
          final existingTokens =
              List<String>.from((userDoc.data() ?? {})['fcmtTokens'] ?? []);
          if (!existingTokens.contains(currentFcmToken)) {
            existingTokens.add(currentFcmToken);
            await _firebaseFirestore
                .collection('users')
                .doc(firebaseUser.uid)
                .update({'fcmtTokens': existingTokens});
            userMap['fcmtTokens'] = existingTokens;
          } else {
            userMap['fcmtTokens'] = existingTokens;
          }
        }
      }

      return UserModel.fromMap(userMap);
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

  Future<UserModel> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;

    try {
      final userDoc = await _firebaseFirestore
          .collection('users')
          .doc(user!.uid)
          .get();
      LoggerUtil.info('Current user fetched: ${userDoc.data()}');
      return UserModel.fromMap(userDoc.data()!);
    } catch (e) {
      LoggerUtil.error('Failed to get current user: $e');
      rethrow;
    }
  }

  Future<List<UserModel>> getUsers() async {
    final snapshot = await _firebaseFirestore
        .collection('users')
        .where('uid', isNotEqualTo: _firebaseAuth.currentUser?.uid)
        .get();
    final users = snapshot.docs.map((doc) {
      return UserModel.fromMap(doc.data());
    }).toList();
    return users;
  }

  Future<UserModel> getUserById(String uid) async {
    try {
      final userDoc = await _firebaseFirestore
        .collection('users')
        .doc(uid)
        .get();

      if (!userDoc.exists) {
      throw Exception('User with ID $uid does not exist');
    }
      
      LoggerUtil.info('User fetched by ID ${userDoc.data()}');
      return UserModel.fromMap(userDoc.data()!);
    } catch (e) {
      LoggerUtil.error('Failed to fecth user by ID: $e');
      rethrow;
    }
  
  }

}
