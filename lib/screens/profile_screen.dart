import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuronest/theme/app_theme.dart';
import 'package:neuronest/widgets/widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<DocumentSnapshot<Map<String, dynamic>>?> _fetchUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    var doc = await docRef.get();

    // Fallback check: if the document does not exist yet for an older account,
    // automatically create a basic document using set(..., SetOptions(merge: true))
    if (!doc.exists) {
      final defaultUsername = user.email?.split('@').first ?? 'user';
      await docRef.set({
        'username': defaultUsername,
        'fullName': user.displayName ?? defaultUsername,
        'role': 'Patient',
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      doc = await docRef.get();
    }

    return doc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.text, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(
          'User Profile',
          style: GoogleFonts.baloo2(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.text,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
        future: _fetchUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final data = snapshot.data?.data();

          // Field reads with safe fallbacks
          final String fullName = data?['fullName'] ?? 'Not entered';
          final String username = data?['username'] ?? 'Not entered';
          final String role = data?['role'] ?? 'Not entered';
          final String phone = data?['phone'] ?? data?['mobile'] ?? 'Not entered';
          final String altPhone = data?['altPhone'] ?? data?['emergencyContact'] ?? 'Not entered';
          final String age = data?['age']?.toString() ?? 'Not entered';
          final String address = data?['address'] ?? 'Not entered';

          final displayName = fullName != 'Not entered'
              ? fullName
              : (username != 'Not entered' ? username : 'User Profile');

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.accent,
                  child: Text(
                    displayName.isNotEmpty && displayName != 'Not entered'
                        ? displayName[0].toUpperCase()
                        : '👤',
                    style: GoogleFonts.baloo2(
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  displayName,
                  style: GoogleFonts.baloo2(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                  ),
                ),
                Text(
                  'Role: $role',
                  style: GoogleFonts.baloo2(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 28),

                // Form details
                CustomTextField(
                  label: 'Full Name',
                  hint: fullName,
                  initialValue: fullName,
                  enabled: false,
                  prefixIcon: Icons.badge_outlined,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Username',
                  hint: username,
                  initialValue: username,
                  enabled: false,
                  prefixIcon: Icons.person_outline_rounded,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Role',
                  hint: role,
                  initialValue: role,
                  enabled: false,
                  prefixIcon: Icons.shield_outlined,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Phone Number',
                  hint: phone,
                  initialValue: phone,
                  enabled: false,
                  prefixIcon: Icons.phone_outlined,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Alt / Emergency Phone',
                  hint: altPhone,
                  initialValue: altPhone,
                  enabled: false,
                  prefixIcon: Icons.phone_iphone_rounded,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Age',
                  hint: age,
                  initialValue: age,
                  enabled: false,
                  prefixIcon: Icons.cake_outlined,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Address',
                  hint: address,
                  initialValue: address,
                  enabled: false,
                  maxLines: 2,
                  prefixIcon: Icons.home_outlined,
                ),
                const SizedBox(height: 32),

                // Log out
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      if (!context.mounted) return;
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/login',
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.logout_rounded, color: Color(0xFFD32F2F)),
                    label: Text(
                      'Log Out',
                      style: GoogleFonts.baloo2(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFD32F2F),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFD32F2F), width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
