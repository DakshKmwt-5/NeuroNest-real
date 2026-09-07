import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuronest/screens/activity_tab_content.dart';
import 'package:neuronest/screens/caregiver_profile_screen.dart';
import 'package:neuronest/screens/help_support_tab_content.dart';
import 'package:neuronest/screens/overview_tab_content.dart';
import 'package:neuronest/screens/reminder_tab_content.dart';
import 'package:neuronest/screens/settings_tab_content.dart';
import 'package:neuronest/services/alert_service.dart';
import 'package:neuronest/theme/app_theme.dart';

// ──────────────────────────────────────────────────────────────────────────────
// CaregiverDashboardScreen  (route: '/caregiver_dashboard')
// ──────────────────────────────────────────────────────────────────────────────

/// Primary home screen for the Caregiver role.
class CaregiverDashboardScreen extends StatefulWidget {
  const CaregiverDashboardScreen({super.key});

  @override
  State<CaregiverDashboardScreen> createState() =>
      _CaregiverDashboardScreenState();
}

class _CaregiverDashboardScreenState extends State<CaregiverDashboardScreen>
    with SingleTickerProviderStateMixin {
  // ── State ──────────────────────────────────────────────────────────────────
  int _selectedIndex = 0;

  // ── Services ───────────────────────────────────────────────────────────────
  final AlertService _alertService = AlertService();

  // ── Entrance animation ─────────────────────────────────────────────────────
  late final AnimationController _anim;
  late final Animation<double>   _fadeIn;
  late final Animation<Offset>   _slideUp;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fadeIn  = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _anim, curve: Curves.easeOut));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _anim.forward();
      _alertService.listenForEmergencies(context);
    });
  }

  @override
  void dispose() {
    _alertService.dispose();
    _anim.dispose();
    super.dispose();
  }

  /// Links a patient by username in Firestore
  Future<void> _linkPatientByUsername(String username) async {
    final trimmed = username.trim();
    if (trimmed.isEmpty) return;

    final caregiverUid = FirebaseAuth.instance.currentUser?.uid;
    if (caregiverUid == null) return;

    try {
      // 1. Query Firestore users collection where username matches and role is 'Patient'
      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: trimmed)
          .where('role', isEqualTo: 'Patient')
          .limit(1)
          .get();

      DocumentSnapshot<Map<String, dynamic>>? patientDoc;
      if (query.docs.isNotEmpty) {
        patientDoc = query.docs.first;
      } else {
        // Fallback: check case-insensitive match for role 'Patient'
        final allPatients = await FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'Patient')
            .get();

        final match = allPatients.docs.where((doc) {
          final u = (doc.data()['username'] as String?)?.trim();
          return u != null && u.toLowerCase() == trimmed.toLowerCase();
        }).firstOrNull;

        if (match != null) {
          patientDoc = match;
        }
      }

      if (patientDoc == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'No patient found with username "$trimmed". Please ensure the patient account has role "Patient".',
                style: GoogleFonts.baloo2(fontWeight: FontWeight.w600),
              ),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
        return;
      }

      final String patientUid = patientDoc.id;
      final String patientUsername = patientDoc.data()?['username'] ?? trimmed;
      final String patientName = patientDoc.data()?['fullName'] ?? patientUsername;

      // 2. Save linked patient's uid to caregiver document
      await FirebaseFirestore.instance.collection('users').doc(caregiverUid).set({
        'linkedPatientUid': patientUid,
        'linkedPatientUsername': patientUsername,
        'linkedPatientName': patientName,
      }, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Successfully linked to patient "$patientName" (@$patientUsername)!',
              style: GoogleFonts.baloo2(fontWeight: FontWeight.w600),
            ),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error linking patient: $e',
              style: GoogleFonts.baloo2(fontWeight: FontWeight.w600),
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  /// Prompts dialog to link a patient by username
  void _showLinkPatientDialog({String? currentPatientUsername}) {
    final controller = TextEditingController(text: currentPatientUsername ?? '');
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.person_add_rounded, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    currentPatientUsername != null ? 'Change Patient' : 'Add / Link Patient',
                    style: GoogleFonts.baloo2(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text,
                    ),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter the patient\'s registered username to link their game scores and profile data.',
                  style: GoogleFonts.baloo2(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: 'Patient Username',
                    hintText: 'e.g. robert_smith',
                    prefixIcon: const Icon(Icons.alternate_email_rounded, color: AppColors.primary),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.outline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: isSubmitting ? null : () => Navigator.pop(dialogContext),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.baloo2(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: isSubmitting
                    ? null
                    : () async {
                        final username = controller.text.trim();
                        if (username.isEmpty) return;
                        setDialogState(() => isSubmitting = true);
                        Navigator.pop(dialogContext);
                        await _linkPatientByUsername(username);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                ),
                child: isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Text(
                        'Link Patient',
                        style: GoogleFonts.baloo2(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final caregiverUid = FirebaseAuth.instance.currentUser?.uid;

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: caregiverUid != null
          ? FirebaseFirestore.instance.collection('users').doc(caregiverUid).snapshots()
          : null,
      builder: (context, caregiverSnapshot) {
        final caregiverData = caregiverSnapshot.data?.data();
        final String? linkedPatientUid = caregiverData?['linkedPatientUid'] as String?;
        final String? linkedPatientUsername = caregiverData?['linkedPatientUsername'] as String?;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideUp,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Header ──────────────────────────────────────────────
                    _CaregiverHeader(
                      selectedIndex: _selectedIndex,
                      linkedPatientUsername: linkedPatientUsername,
                      onAddPatientPressed: () => _showLinkPatientDialog(
                        currentPatientUsername: linkedPatientUsername,
                      ),
                    ),

                    // ── Main content ─────────────────────────────────────────
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 280),
                        transitionBuilder: (child, anim) => FadeTransition(
                          opacity: anim,
                          child: child,
                        ),
                        child: _selectedIndex == 0
                            ? OverviewTabContent(
                                key: const ValueKey('overview'),
                                linkedPatientUid: linkedPatientUid,
                                onLinkPatient: (username) => _linkPatientByUsername(username),
                                onShowLinkDialog: () => _showLinkPatientDialog(
                                  currentPatientUsername: linkedPatientUsername,
                                ),
                              )
                            : _selectedIndex == 1
                                ? ActivityTabContent(
                                    key: const ValueKey('activity'),
                                    targetUserId: linkedPatientUid,
                                    onShowLinkDialog: () => _showLinkPatientDialog(
                                      currentPatientUsername: linkedPatientUsername,
                                    ),
                                  )
                                : _selectedIndex == 2
                                    ? const ReminderTabContent(
                                        key: ValueKey('reminder'),
                                      )
                                    : _selectedIndex == 3
                                        ? const SettingsTabContent(
                                            key: ValueKey('settings'),
                                          )
                                        : const HelpSupportTabContent(
                                            key: ValueKey('help_support'),
                                          ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // ── Custom bottom nav ────────────────────────────────────────────
          bottomNavigationBar: _CaregiverBottomNavBar(
            selectedIndex: _selectedIndex,
            onTap: (i) {
              if (i != _selectedIndex) {
                setState(() => _selectedIndex = i);
                _anim
                  ..reset()
                  ..forward();
              }
            },
          ),
        );
      },
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// _CaregiverHeader
// ──────────────────────────────────────────────────────────────────────────────

/// Top navigation row:
///   [NotificationIcon] | [Expanded "Caregiver Hub"] | [AddPatientButton] | [AvatarIcon]
class _CaregiverHeader extends StatelessWidget {
  const _CaregiverHeader({
    required this.selectedIndex,
    this.linkedPatientUsername,
    this.onAddPatientPressed,
  });

  final int selectedIndex;
  final String? linkedPatientUsername;
  final VoidCallback? onAddPatientPressed;

  static const _tabTitles = [
    'Caregiver Hub',
    'Activity',
    'Reminders',
    'Settings',
    'Help & Support',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Left: notification bell ───────────────────────────────────────
          Semantics(
            button: true,
            label: 'Notifications',
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  onPressed: () => debugPrint('Notifications tapped'),
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    color: AppColors.text,
                    size: 26,
                  ),
                  tooltip: 'Notifications',
                  splashRadius: 22,
                ),
                // Unread badge
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppColors.background, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Centre: title ─────────────────────────────────────────────────
          Expanded(
            child: Text(
              _tabTitles[selectedIndex],
              textAlign: TextAlign.center,
              style: GoogleFonts.baloo2(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.text,
                height: 1.1,
                letterSpacing: -0.2,
              ),
            ),
          ),

          // ── Link / Add Patient quick action ──────────────────────────────
          if (onAddPatientPressed != null)
            Semantics(
              button: true,
              label: linkedPatientUsername != null ? 'Change Patient' : 'Add Patient',
              child: IconButton(
                onPressed: onAddPatientPressed,
                icon: Icon(
                  linkedPatientUsername != null
                      ? Icons.person_search_rounded
                      : Icons.person_add_alt_1_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
                tooltip: linkedPatientUsername != null
                    ? 'Linked: @$linkedPatientUsername (Tap to change)'
                    : 'Add / Link Patient',
                splashRadius: 22,
              ),
            ),

          // ── Right: profile avatar ─────────────────────────────────────────
          Semantics(
            button: true,
            label: 'My profile',
            child: IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CaregiverProfileScreen(),
                ),
              ),
              icon: const Icon(
                Icons.account_circle_rounded,
                color: AppColors.primary,
                size: 32,
              ),
              tooltip: 'Profile',
              splashRadius: 22,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// _CaregiverBottomNavBar  – custom 5-tab navigation bar
// ──────────────────────────────────────────────────────────────────────────────

/// Custom bottom nav bar with 5 items:
///   Overview · Activity · Reminder · Setting · Help & Support
///
/// Active:   [AppColors.primary] icon + label
/// Inactive: [AppColors.textSecondary] icon + label
/// All touch targets ≥ 48 × 48 px.
class _CaregiverBottomNavBar extends StatelessWidget {
  const _CaregiverBottomNavBar({
    required this.selectedIndex,
    required this.onTap,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;

  // ── Tab definitions ────────────────────────────────────────────────────────
  static const _tabs = [
    _CaregiverNavItem(icon: Icons.dashboard_rounded,    label: 'Overview'),
    _CaregiverNavItem(icon: Icons.insights_rounded,     label: 'Activity'),
    _CaregiverNavItem(icon: Icons.edit_calendar_rounded,label: 'Reminder'),
    _CaregiverNavItem(icon: Icons.settings_rounded,     label: 'Setting'),
    _CaregiverNavItem(icon: Icons.help_outline_rounded, label: 'Help & Support'),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.paddingOf(context).bottom;

    return Container(
      padding: EdgeInsets.only(bottom: bottomPad),
      decoration: BoxDecoration(
        color: AppColors.surface,  // white / Background surface
        border: const Border(
          top: BorderSide(color: AppColors.outline, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.text.withAlpha(12),
            blurRadius: 20,
            offset: const Offset(0, -4),
            spreadRadius: -4,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(_tabs.length, (i) {
              final tab = _tabs[i];
              final selected = i == selectedIndex;
              final color =
                  selected ? AppColors.primary : AppColors.textSecondary;

              return Semantics(
                button: true,
                selected: selected,
                label: tab.label,
                child: InkWell(
                  onTap: () => onTap(i),
                  borderRadius: BorderRadius.circular(16),
                  splashColor: AppColors.primary.withAlpha(20),
                  highlightColor: AppColors.primary.withAlpha(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primarySurface
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          child: Icon(
                            tab.icon,
                            key: ValueKey(selected),
                            size: 22,
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 3),
                        // Label — truncated for narrow items like "Help & Support"
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 180),
                          style: GoogleFonts.baloo2(
                            fontSize: 9,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: color,
                            height: 1.0,
                          ),
                          child: Text(
                            tab.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

/// Immutable data class for a single nav tab definition.
class _CaregiverNavItem {
  final IconData icon;
  final String   label;
  const _CaregiverNavItem({required this.icon, required this.label});
}
