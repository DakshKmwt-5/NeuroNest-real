import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuronest/screens/activity_tab_content.dart';
import 'package:neuronest/theme/app_theme.dart';

/// Standalone Activity Screen wrapping [ActivityTabContent]
class ActivityScreen extends StatelessWidget {
  final String? targetUserId;
  final VoidCallback? onShowLinkDialog;

  const ActivityScreen({
    super.key,
    this.targetUserId,
    this.onShowLinkDialog,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.text),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Activity Log',
          style: GoogleFonts.baloo2(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.text,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ActivityTabContent(
          targetUserId: targetUserId,
          onShowLinkDialog: onShowLinkDialog,
        ),
      ),
    );
  }
}
