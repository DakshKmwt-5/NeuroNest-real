import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuronest/theme/app_theme.dart';

/// Activity tab content showing patient activity logs
/// backed by live Firestore streams filtered by the linked patient's userId.
class ActivityTabContent extends StatelessWidget {
  final String? targetUserId;
  final VoidCallback? onShowLinkDialog;

  const ActivityTabContent({
    super.key,
    this.targetUserId,
    this.onShowLinkDialog,
  });

  @override
  Widget build(BuildContext context) {
    if (targetUserId == null || targetUserId!.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: const BoxDecoration(
                  color: AppColors.primarySurface,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_search_rounded,
                  size: 48,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'No Patient Linked',
                style: GoogleFonts.baloo2(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Link a patient by their username to view live cognitive game activity and performance records.',
                textAlign: TextAlign.center,
                style: GoogleFonts.baloo2(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              if (onShowLinkDialog != null)
                ElevatedButton.icon(
                  onPressed: onShowLinkDialog,
                  icon: const Icon(Icons.person_add_alt_1_rounded, color: Colors.white, size: 20),
                  label: Text(
                    'Link Patient',
                    style: GoogleFonts.baloo2(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('game_scores')
          .where('userId', isEqualTo: targetUserId)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        var docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.outline),
                    ),
                    child: const Icon(
                      Icons.videogame_asset_outlined,
                      size: 44,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No game activity recorded yet.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.baloo2(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'When the linked patient plays cognitive games, their live scores will stream here in real time.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.baloo2(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          itemCount: docs.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Patient Activity Log',
                      style: GoogleFonts.baloo2(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text,
                      ),
                    ),
                    Text(
                      'Live cognitive session performance and scores.',
                      style: GoogleFonts.baloo2(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }

            var data = docs[index - 1].data() as Map<String, dynamic>;
            final String gameName = data['gameName'] ?? 'Game';
            final dynamic scoreVal = data['score'] ?? 0;
            final dynamic maxScoreVal = data['maxScore'] ?? 0;
            final dynamic timeElapsedVal = data['timeElapsed'] ?? 0;
            final dynamic timestamp = data['timestamp'];

            String formattedDate = '';
            if (timestamp != null && timestamp is Timestamp) {
              formattedDate = timestamp.toDate().toString().substring(0, 16);
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.outline.withAlpha(100)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.sports_esports_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                title: Text(
                  gameName,
                  style: GoogleFonts.baloo2(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                  ),
                ),
                subtitle: Text(
                  'Score: $scoreVal / $maxScoreVal | Time: ${timeElapsedVal}s',
                  style: GoogleFonts.baloo2(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                trailing: Text(
                  formattedDate,
                  style: GoogleFonts.baloo2(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

