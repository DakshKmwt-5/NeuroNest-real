import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuronest/theme/app_theme.dart';
import 'package:neuronest/widgets/widgets.dart';

// ──────────────────────────────────────────────────────────────────────────────
// CaregiverProfileScreen
// ──────────────────────────────────────────────────────────────────────────────

/// Allows the caregiver to view and edit their profile details.
///
/// Layout (SingleChildScrollView):
///   1. [_ProfileAvatar]  – CircleAvatar + camera upload button
///   2. [_ProfileNameBadge] – display name + role chip
///   3. Form fields: Username, Relation, Phone, Email
///   4. [PrimaryButton] "Save Changes"
class CaregiverProfileScreen extends StatefulWidget {
  const CaregiverProfileScreen({super.key});

  @override
  State<CaregiverProfileScreen> createState() =>
      _CaregiverProfileScreenState();
}

class _CaregiverProfileScreenState extends State<CaregiverProfileScreen> {
  // ── Controllers ───────────────────────────────────────────────────────────
  final _formKey          = GlobalKey<FormState>();
  final _usernameCtrl     = TextEditingController();
  final _relationCtrl     = TextEditingController();
  final _phoneCtrl        = TextEditingController();
  final _emailCtrl        = TextEditingController();

  String _displayName = 'Caregiver';
  String _role = 'Caregiver';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
        var doc = await docRef.get();
        if (!doc.exists) {
          final defaultUsername = user.email?.split('@').first ?? 'caregiver';
          await docRef.set({
            'username': defaultUsername,
            'fullName': user.displayName ?? defaultUsername,
            'role': 'Caregiver',
            'createdAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
          doc = await docRef.get();
        }

        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;
          final String fullName = data['fullName'] ?? 'Not entered';
          final String username = data['username'] ?? 'Not entered';
          final String role = data['role'] ?? 'Caregiver';
          final String phone = data['phone'] ?? data['mobile'] ?? 'Not entered';
          final String email = data['email'] ?? user.email ?? 'Not entered';
          final String relation = data['relation'] ?? 'Not entered';

          if (mounted) {
            setState(() {
              _displayName = fullName != 'Not entered' && fullName.isNotEmpty
                  ? fullName
                  : (username != 'Not entered' && username.isNotEmpty ? username : 'Caregiver');
              _role = role;
              _usernameCtrl.text = username;
              _relationCtrl.text = relation;
              _phoneCtrl.text = phone;
              _emailCtrl.text = email;
            });
          }
          return;
        }
      } catch (e) {
        debugPrint('Error loading caregiver profile: $e');
      }
    }
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _relationCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      debugPrint('Profile saved');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Profile updated successfully!',
            style: GoogleFonts.baloo2(fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // ── AppBar ─────────────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.text,
            size: 20,
          ),
          tooltip: 'Back',
        ),
        title: Text(
          'My Profile',
          style: GoogleFonts.baloo2(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.text,
            height: 1.1,
          ),
        ),
        centerTitle: true,
        actions: [
          // Edit shortcut
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: _onSave,
              icon: const Icon(
                Icons.check_rounded,
                color: AppColors.primary,
                size: 24,
              ),
              tooltip: 'Save changes',
            ),
          ),
        ],
      ),

      // ── Body ───────────────────────────────────────────────────────────────
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1 ── Profile avatar ──────────────────────────────────────────
              const _ProfileAvatar(),
              const SizedBox(height: 20),

              // 2 ── Name + role badge ────────────────────────────────────────
              _ProfileNameBadge(
                displayName: _displayName,
                role: _role,
              ),
              const SizedBox(height: 32),

              // 3 ── Section label ────────────────────────────────────────────
              const _SectionLabel(label: 'Account Details'),
              const SizedBox(height: 16),

              // Username
              CustomTextField(
                label: 'Username',
                hint: 'Enter your username',
                controller: _usernameCtrl,
                prefixIcon: Icons.badge_outlined,
                textInputAction: TextInputAction.next,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Username is required'
                    : null,
                semanticLabel: 'Username field',
              ),
              const SizedBox(height: 20),

              // Relation
              CustomTextField(
                label: 'Relation to Patient',
                hint: 'e.g. Son, Daughter, Nurse',
                controller: _relationCtrl,
                prefixIcon: Icons.people_outline_rounded,
                textInputAction: TextInputAction.next,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Relation is required'
                    : null,
                semanticLabel: 'Relation to patient field',
              ),
              const SizedBox(height: 20),

              // 4 ── Section label ────────────────────────────────────────────
              const _SectionLabel(label: 'Contact Information'),
              const SizedBox(height: 16),

              // Phone
              CustomTextField(
                label: 'Phone Number',
                hint: 'Enter your phone number',
                controller: _phoneCtrl,
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                semanticLabel: 'Phone number field',
              ),
              const SizedBox(height: 20),

              // Email
              CustomTextField(
                label: 'Email Address',
                hint: 'Enter your email address',
                controller: _emailCtrl,
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _onSave(),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null; // optional
                  final valid = RegExp(
                          r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$')
                      .hasMatch(v.trim());
                  return valid ? null : 'Enter a valid email';
                },
                semanticLabel: 'Email address field',
              ),
              const SizedBox(height: 40),

              // 5 ── Save CTA ─────────────────────────────────────────────────
              PrimaryButton(
                text: 'Save Changes',
                icon: Icons.save_rounded,
                onPressed: _onSave,
                semanticLabel: 'Save profile changes',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// _ProfileAvatar
// ──────────────────────────────────────────────────────────────────────────────

/// Large [CircleAvatar] with a camera upload button overlaid at bottom-right.
class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── Main avatar circle ──────────────────────────────────────────────
          Container(
            width: 124,
            height: 124,
            decoration: BoxDecoration(
              color: AppColors.accent,   // #D8C9E8 Accent bg
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.surface,
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withAlpha(120),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                  spreadRadius: -4,
                ),
              ],
            ),
            child: const Icon(
              Icons.person_rounded,
              size: 64,
              color: AppColors.primary,   // Primary (#347747) icon
            ),
          ),

          // ── Camera upload button ────────────────────────────────────────────
          Positioned(
            bottom: 0,
            right: 0,
            child: Semantics(
              button: true,
              label: 'Upload profile photo',
              child: GestureDetector(
                onTap: () {}, // TODO: implement image picker
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary,   // Primary circle
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.surface,
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(80),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,   // white icon
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// _ProfileNameBadge
// ──────────────────────────────────────────────────────────────────────────────

/// Displays the caregiver's display name and a "Caregiver" role pill.
class _ProfileNameBadge extends StatelessWidget {
  final String displayName;
  final String role;

  const _ProfileNameBadge({
    required this.displayName,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          displayName,
          textAlign: TextAlign.center,
          style: GoogleFonts.baloo2(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.text,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        // Role chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.secondary, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.favorite_rounded,
                size: 14,
                color: AppColors.primary,
              ),
              const SizedBox(width: 6),
              Text(
                role,
                style: GoogleFonts.baloo2(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// _SectionLabel
// ──────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.baloo2(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.text,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}
