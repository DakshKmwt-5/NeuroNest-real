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
///
/// Layout:
///   • [Scaffold] with [AppColors.background]
///   • Header row: notification bell | "Caregiver Hub" title | avatar
///   • [Expanded] body showing active tab content
///   • Custom 5-tab [_CaregiverBottomNavBar]
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

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
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
                // ── Header ──────────────────────────────────────────────────
                _CaregiverHeader(selectedIndex: _selectedIndex),

                // ── Main content ─────────────────────────────────────────────
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: child,
                    ),
                    child: _selectedIndex == 0
                        ? const OverviewTabContent(
                            key: ValueKey('overview'),
                          )
                        : _selectedIndex == 1
                            ? const ActivityTabContent(
                                key: ValueKey('activity'),
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
      // ── Custom bottom nav ────────────────────────────────────────────────
      bottomNavigationBar: _CaregiverBottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: (i) {
          if (i != _selectedIndex) {
            setState(() => _selectedIndex = i);
            _anim..reset()..forward();
          }
        },
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// _CaregiverHeader
// ──────────────────────────────────────────────────────────────────────────────

/// Top navigation row:
///   [NotificationIcon] | [Expanded "Caregiver Hub"] | [AvatarIcon]
class _CaregiverHeader extends StatelessWidget {
  const _CaregiverHeader({required this.selectedIndex});
  final int selectedIndex;

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
