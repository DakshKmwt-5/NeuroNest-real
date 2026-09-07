import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuronest/theme/app_theme.dart';

// ──────────────────────────────────────────────────────────────────────────────
// OverviewTabContent
// ──────────────────────────────────────────────────────────────────────────────

/// The "Overview" tab for the Caregiver Hub.
///
/// Current sections:
///   1. Patient Profile card / Link Patient prompt
///   2. Care Team section
class OverviewTabContent extends StatefulWidget {
  final String? linkedPatientUid;
  final ValueChanged<String>? onLinkPatient;
  final VoidCallback? onShowLinkDialog;

  const OverviewTabContent({
    super.key,
    this.linkedPatientUid,
    this.onLinkPatient,
    this.onShowLinkDialog,
  });

  @override
  State<OverviewTabContent> createState() => _OverviewTabContentState();
}

class _OverviewTabContentState extends State<OverviewTabContent> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 1. Patient Profile / Link Section ─────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _SectionTitle(label: 'Patient Profile'),
              if (widget.linkedPatientUid != null && widget.onShowLinkDialog != null)
                TextButton.icon(
                  onPressed: widget.onShowLinkDialog,
                  icon: const Icon(Icons.swap_horiz_rounded, size: 18, color: AppColors.primary),
                  label: Text(
                    'Switch',
                    style: GoogleFonts.baloo2(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          if (widget.linkedPatientUid == null || widget.linkedPatientUid!.isEmpty)
            _NoPatientLinkedCard(
              controller: _usernameController,
              onLink: () {
                final username = _usernameController.text.trim();
                if (username.isNotEmpty && widget.onLinkPatient != null) {
                  widget.onLinkPatient!(username);
                }
              },
            )
          else
            _PatientProfileCard(
              patientUid: widget.linkedPatientUid!,
              onShowLinkDialog: widget.onShowLinkDialog,
            ),
          const SizedBox(height: 28),

          // ── 2. Care Team ───────────────────────────────────────────────────
          const _SectionTitle(label: 'Care Team'),
          const SizedBox(height: 4),
          Text(
            'Others supporting the patient',
            style: GoogleFonts.baloo2(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          const _CareTeamSection(),
          const SizedBox(height: 28),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// _NoPatientLinkedCard
// ──────────────────────────────────────────────────────────────────────────────

/// Prompt card displayed when the caregiver has not linked a patient yet.
class _NoPatientLinkedCard extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onLink;

  const _NoPatientLinkedCard({
    required this.controller,
    required this.onLink,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.person_search_rounded, color: AppColors.primary, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Link a Patient',
                      style: GoogleFonts.baloo2(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text,
                      ),
                    ),
                    Text(
                      'Enter patient username to sync records',
                      style: GoogleFonts.baloo2(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Connect to your patient\'s NeuroNest profile to view live cognitive activity and manage care.',
            style: GoogleFonts.baloo2(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Enter patient username',
                    hintStyle: GoogleFonts.baloo2(fontSize: 13, color: AppColors.textSecondary),
                    prefixIcon: const Icon(Icons.alternate_email_rounded, size: 18, color: AppColors.primary),
                    filled: true,
                    fillColor: AppColors.background,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.outline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: onLink,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  'Link',
                  style: GoogleFonts.baloo2(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// _SectionTitle
// ──────────────────────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.baloo2(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: AppColors.text,       // Primary Text (#22453E)
        height: 1.1,
        letterSpacing: -0.2,
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// _PatientProfileCard
// ──────────────────────────────────────────────────────────────────────────────

/// Displays the linked patient's avatar, name, age/condition and today's status.
class _PatientProfileCard extends StatelessWidget {
  final String patientUid;
  final VoidCallback? onShowLinkDialog;

  const _PatientProfileCard({
    required this.patientUid,
    this.onShowLinkDialog,
  });

  static Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.baloo2(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: GoogleFonts.baloo2(
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = const HSLColor.fromAHSL(1.0, 44.0, 0.50, 0.82).toColor();

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('users').doc(patientUid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        final data = snapshot.data?.data();
        final fullName = (data?['fullName'] as String?)?.trim();
        final username = (data?['username'] as String?)?.trim();
        final displayName = (fullName != null && fullName.isNotEmpty && fullName != 'Not entered')
            ? fullName
            : ((username != null && username.isNotEmpty && username != 'Not entered')
                ? username
                : 'Patient Profile');
        final age = data?['age']?.toString() ?? 'Not entered';
        final emergency = data?['altPhone'] ?? data?['emergencyContact'] ?? 'Not entered';
        final notes = data?['medicalNotes'] ?? data?['notes'] ?? 'Mindful of daily cognitive routine.';
        final doctor = data?['doctor'] ?? 'Dr. Evans - St. Jude Memory Clinic';

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: const Color(0xFFE8CB6A),   // warm gold border
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: cardColor.withAlpha(130),
                blurRadius: 20,
                offset: const Offset(0, 6),
                spreadRadius: -4,
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              backgroundColor: Colors.transparent,
              collapsedBackgroundColor: Colors.transparent,
              shape: const Border(bottom: BorderSide.none),
              collapsedShape: const Border(bottom: BorderSide.none),
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              leading: _PatientAvatar(displayName: displayName),
              title: Text(
                displayName,
                style: GoogleFonts.baloo2(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text,
                  height: 1.1,
                  letterSpacing: -0.3,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    age != 'Not entered' ? '$age yrs • Memory care' : 'Memory care active',
                    style: GoogleFonts.baloo2(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                      height: 1.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Online',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              trailing: Builder(
                builder: (context) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (onShowLinkDialog != null)
                        IconButton(
                          icon: const Icon(Icons.edit_rounded, color: AppColors.text),
                          onPressed: onShowLinkDialog,
                          tooltip: 'Change Linked Patient',
                        ),
                      const Icon(Icons.expand_more_rounded, color: AppColors.text),
                    ],
                  );
                },
              ),
              children: [
                const Divider(color: Color(0xFFD8C180), height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(Icons.badge_outlined, 'Username', '@${username ?? "unknown"}'),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.note_alt_outlined, 'Medical Notes', notes),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.phone_outlined, 'Emergency Contact', emergency),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.local_hospital_outlined, 'Primary Care Doctor', doctor),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// _PatientAvatar
// ──────────────────────────────────────────────────────────────────────────────

/// Large circular avatar with a gradient ring.
class _PatientAvatar extends StatelessWidget {
  final String? displayName;
  const _PatientAvatar({this.displayName});

  @override
  Widget build(BuildContext context) {
    final hasLetter = displayName != null && displayName!.isNotEmpty && displayName != 'Patient Profile';

    return Container(
      // Gradient ring around the avatar
      width: 92,
      height: 92,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,          // #347747
            Color(0xFF9FC8A8),          // soft sage
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(60),
            blurRadius: 16,
            offset: const Offset(0, 5),
            spreadRadius: -3,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(3),   // ring thickness
        child: CircleAvatar(
          radius: 43,
          backgroundColor: AppColors.accent,   // #D8C9E8 inner fill
          child: hasLetter
              ? Text(
                  displayName![0].toUpperCase(),
                  style: GoogleFonts.baloo2(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                )
              : const Icon(
                  Icons.person_rounded,
                  size: 48,
                  color: AppColors.primary,
                ),
        ),
      ),
    );
  }
}



// ──────────────────────────────────────────────────────────────────────────────
// _CareTeamSection  – horizontal scrolling care team list
// ──────────────────────────────────────────────────────────────────────────────

/// A fixed-height [SizedBox] containing a horizontal [ListView.builder]
/// of [_CaregiverChip] items for the 3 mock care team members.
class _CareTeamSection extends StatelessWidget {
  const _CareTeamSection();

  /// 3 mock caregivers: (name, relation, avatar colour)
  static const _team = [
    _TeamMember(name: 'Sarah',   relation: 'Daughter',   color: Color(0xFFD8C9E8)),
    _TeamMember(name: 'James',   relation: 'Son',        color: Color(0xFFC3D19A)),
    _TeamMember(name: 'Dr. Pam', relation: 'Nurse',      color: Color(0xFFFBE5A8)),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _team.length,
        padding: const EdgeInsets.symmetric(vertical: 4),
        itemBuilder: (context, i) => Padding(
          // spacing between chips — leading gap on first item
          padding: EdgeInsets.only(left: i == 0 ? 0 : 12),
          child: _CaregiverChip(member: _team[i]),
        ),
      ),
    );
  }
}

/// Tiny data class for a care team member.
class _TeamMember {
  final String name;
  final String relation;
  final Color  color;
  const _TeamMember({
    required this.name,
    required this.relation,
    required this.color,
  });
}

// ──────────────────────────────────────────────────────────────────────────────
// _CaregiverChip
// ──────────────────────────────────────────────────────────────────────────────

/// A vertical card: avatar circle → name → relation label.
class _CaregiverChip extends StatelessWidget {
  const _CaregiverChip({required this.member});
  final _TeamMember member;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${member.name}, ${member.relation}',
      child: InkWell(
        onTap: () => debugPrint('Care team member tapped: ${member.name}'),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 88,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          decoration: BoxDecoration(
            color: member.color.withAlpha(90),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: member.color,
              width: 1.2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Avatar circle (radius ~30)
              CircleAvatar(
                radius: 30,
                backgroundColor: member.color,
                child: Text(
                  member.name[0],               // first-letter monogram
                  style: GoogleFonts.baloo2(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Name
              Text(
                member.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.baloo2(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,       // Primary Text
                  height: 1.1,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              // Relation
              Text(
                member.relation,
                textAlign: TextAlign.center,
                style: GoogleFonts.baloo2(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,  // Secondary Text (#181818)
                  height: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
