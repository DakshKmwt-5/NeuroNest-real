import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class GameScoreService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveScore({
    required String gameName,
    required int score,
    required int maxScore,
    required int timeElapsed,
  }) async {
    try {
      final String? uid = _auth.currentUser?.uid;
      if (uid != null) {
        await _firestore.collection('game_scores').add({
          'userId': uid,
          'gameName': gameName,
          'score': score,
          'maxScore': maxScore,
          'timeElapsed': timeElapsed,
          'timestamp': FieldValue.serverTimestamp(),
        });
        debugPrint('Score saved for $gameName: $score/$maxScore in ${timeElapsed}s');
      }
    } catch (e) {
      debugPrint('Failed to save score for $gameName: $e');
    }
  }
}
