import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuronest/screens/caregiver_profile_screen.dart';
import 'package:neuronest/theme/app_theme.dart';

/// Settings tab for the Caregiver Dashboard.
class SettingsTabContent extends StatelessWidget {
  const SettingsTabContent({super.key});

  Widget _buildCardTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color iconColor = AppColors.primary,
    Color textColor = AppColors.text,
    bool showChevron = true,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withAlpha(25),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(
          title,
          style: GoogleFonts.baloo2(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: GoogleFonts.baloo2(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              )
            : null,
        trailing: showChevron
            ? const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      children: [
        Text(
          'Settings',
          style: GoogleFonts.baloo2(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 16),
        _buildCardTile(
          icon: Icons.record_voice_over_rounded,
          title: 'Language & Voice',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Language & Voice settings tapped')),
            );
          },
        ),
        _buildCardTile(
          icon: Icons.accessibility_new_rounded,
          title: 'Accessibility',
          subtitle: 'Text size, theme',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Accessibility settings tapped')),
            );
          },
        ),
        _buildCardTile(
          icon: Icons.person_outline_rounded,
          title: "Patient's Profile",
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Patient's Profile tapped")),
            );
          },
        ),
        _buildCardTile(
          icon: Icons.account_circle_rounded,
          title: 'My Profile',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CaregiverProfileScreen(),
              ),
            );
          },
        ),
        _buildCardTile(
          icon: Icons.logout_rounded,
          title: 'Log Out',
          iconColor: const Color(0xFFD32F2F),
          textColor: const Color(0xFFD32F2F),
          showChevron: false,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Logged out')),
            );
          },
        ),
      ],
    );
  }
}
