import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? getCurrentUser() {
    final firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      return UserModel(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName ?? '',
        firstName: firebaseUser.displayName?.split(' ').first ?? '',
        lastName: firebaseUser.displayName?.split(' ').last ?? '',
        phoneNumber: firebaseUser.phoneNumber ?? '',
        createdAt: DateTime.now(), // Placeholder
      );
    }
    return null;
  }

  Stream<UserModel?> get authStateChanges {
    return _auth.authStateChanges().switchMap((firebaseUser) {
      if (firebaseUser == null) {
        return Stream.value(null);
      } else {
        return _firestore.collection('users')
            .doc(firebaseUser.uid)
            .snapshots()
            .map((userDoc) {
          if (userDoc.exists) {
            return UserModel.fromMap(userDoc.data()!);
          } else {
            debugPrint("Warning: Firestore user doc not found for UID: ${firebaseUser.uid}");
            return null;
          }
        });
      }
    });
  }

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    String? bio,
    String? address,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception("Firebase user creation failed.");
      }

      final displayName = '$firstName $lastName';
      await user.updateDisplayName(displayName);

      final userModel = UserModel(
        uid: user.uid,
        email: email,
        displayName: displayName,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        bio: bio,
        address: address,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      final userMap = userModel.toMap();
      userMap['lastLoginAt'] = FieldValue.serverTimestamp();
      userMap['createdAt'] = FieldValue.serverTimestamp();

      await _firestore.collection('users').doc(user.uid).set(userMap);

      return userModel.copyWith(
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

    } on FirebaseAuthException catch (e) {
      debugPrint("Firebase Auth Sign Up Error: ${e.code}");
      throw Exception(e.message ?? "An unknown error occurred during sign up.");
    } catch (e) {
      debugPrint("Sign Up Error: $e");
      rethrow;
    }
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user!;
      final userUid = user.uid;

      _firestore.collection('users').doc(userUid).set(
        {'lastLoginAt': FieldValue.serverTimestamp()},
        SetOptions(merge: true),
      );


      return UserModel(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? '',
        firstName: user.displayName?.split(' ').first ?? '',
        lastName: user.displayName?.split(' ').last ?? '',
        phoneNumber: user.phoneNumber ?? '',
        createdAt: DateTime.now(), // Placeholder
      );

    } on FirebaseAuthException catch (e) {
      debugPrint("Firebase Auth Sign In Error: ${e.code}");
      throw Exception(e.message ?? "An unknown error occurred during sign in.");
    } catch (e) {
      debugPrint("Sign In Error: $e");
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> updateProfile(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).update(user.toMap());
    await _auth.currentUser?.updateDisplayName(user.displayName);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}