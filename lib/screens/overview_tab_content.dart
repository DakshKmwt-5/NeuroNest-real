import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuronest/theme/app_theme.dart';

// ──────────────────────────────────────────────────────────────────────────────
// OverviewTabContent
// ──────────────────────────────────────────────────────────────────────────────

/// The "Overview" tab for the Caregiver Hub.
///
/// Current sections:
///   1. Patient Profile card (Highlight bg)
///
/// More sections (Quick Stats, Today's Activities, etc.)
/// will be added in subsequent phases.
class OverviewTabContent extends StatelessWidget {
  const OverviewTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 1. Patient Profile ─────────────────────────────────────────────
          const _SectionTitle(label: 'Patient Profile'),
          const SizedBox(height: 12),
          const _PatientProfileCard(),
          const SizedBox(height: 28),

          // ── 2. Care Team ───────────────────────────────────────────────────
          const _SectionTitle(label: 'Care Team'),
          const SizedBox(height: 4),
          Text(
            'Others supporting ${"Robert"}',
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

/// Displays the patient's avatar, name, age/condition and today's status.
///
/// Background: Highlight (#FBE5A8) — warm and calming.
/// Layout: Row → [CircleAvatar] · [Expanded Column]
class _PatientProfileCard extends StatelessWidget {
  const _PatientProfileCard();

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
          leading: const _PatientAvatar(),
          title: Text(
            'Robert Smith',
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
                '72 yrs  •  Early-stage',
                style: GoogleFonts.baloo2(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 6),
              const _StatusIndicator(
                label: 'Doing well today',
                color: Color(0xFF2E7D32),
                bgColor: Color(0xFFD4EDDA),
              ),
            ],
          ),
          trailing: Builder(
            builder: (context) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_rounded, color: AppColors.text),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Edit Patient Profile tapped')),
                      );
                    },
                    tooltip: 'Edit Profile',
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
                _buildInfoRow(Icons.note_alt_outlined, 'Medical Notes', 'No known severe allergies. Mindful of afternoon routine.'),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.phone_outlined, 'Emergency Contact', 'Sarah (Daughter) - (555) 019-2831'),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.local_hospital_outlined, 'Primary Care Doctor', 'Dr. Evans - St. Jude Memory Clinic'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// _PatientAvatar
// ──────────────────────────────────────────────────────────────────────────────

/// Large circular avatar with a gradient ring.
class _PatientAvatar extends StatelessWidget {
  const _PatientAvatar();

  @override
  Widget build(BuildContext context) {
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
      child: const Padding(
        padding: EdgeInsets.all(3),   // ring thickness
        child: CircleAvatar(
          radius: 43,
          backgroundColor: AppColors.accent,   // #D8C9E8 inner fill
          child: Icon(
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
// _StatusIndicator
// ──────────────────────────────────────────────────────────────────────────────

/// Small pill with a coloured dot and status text.
class _StatusIndicator extends StatelessWidget {
  const _StatusIndicator({
    required this.label,
    required this.color,
    required this.bgColor,
  });

  final String label;
  final Color  color;
  final Color  bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(60), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Filled dot
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withAlpha(80),
                  blurRadius: 6,
                  spreadRadius: 0,
                ),
              ],
            ),
          ),
          const SizedBox(width: 7),
          // Status text
          Text(
            label,
            style: GoogleFonts.baloo2(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
              height: 1.0,
            ),
          ),
        ],
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
