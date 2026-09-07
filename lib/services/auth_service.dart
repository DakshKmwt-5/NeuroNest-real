import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  /// Helper to convert username to mock email domain
  static String usernameToEmail(String username) {
    return '${username.trim().toLowerCase()}@neuronest.app';
  }

  /// Registers a new user with username, password, role, and full name.
  Future<UserCredential> signUpUser({
    required String username,
    required String password,
    required String role,
    required String fullName,
  }) async {
    final String email = usernameToEmail(username);

    final UserCredential credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user != null) {
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'username': username,
        'fullName': fullName,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return credential;
  }

  /// Signs in an existing user with username and password.
  Future<UserCredential> loginUser({
    required String username,
    required String password,
  }) async {
    final String email = usernameToEmail(username);

    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Fetches the user profile document, creating a fallback document if missing.
  Future<DocumentSnapshot<Map<String, dynamic>>?> getUserProfile(String uid) async {
    try {
      final docRef = _firestore.collection('users').doc(uid);
      final doc = await docRef.get();
      if (!doc.exists) {
        final user = _auth.currentUser;
        final rawUsername = user?.email?.split('@').first ?? 'user';
        await docRef.set({
          'username': rawUsername,
          'fullName': rawUsername,
          'role': 'Patient',
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        return await docRef.get();
      }
      return doc;
    } catch (e) {
      debugPrint('Error getting user profile: $e');
      return null;
    }
  }

  /// Fetches the user's role from Firestore ('Caregiver' or 'Patient').
  Future<String?> getUserRole(String uid) async {
    try {
      final docRef = _firestore.collection('users').doc(uid);
      var doc = await docRef.get();
      if (!doc.exists) {
        final user = _auth.currentUser;
        final rawUsername = user?.email?.split('@').first ?? 'user';
        await docRef.set({
          'username': rawUsername,
          'fullName': rawUsername,
          'role': 'Patient',
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        doc = await docRef.get();
      }
      if (doc.exists && doc.data() != null) {
        return doc.data()?['role'] as String?;
      }
    } catch (_) {}
    return null;
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
