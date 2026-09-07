import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuronest/theme/app_theme.dart';
import 'package:neuronest/widgets/widgets.dart';

// ──────────────────────────────────────────────────────────────────────────────
// PatientDashboardScreen  (route: '/patient_dashboard')
// ──────────────────────────────────────────────────────────────────────────────
class PatientDashboardScreen extends StatefulWidget {
  const PatientDashboardScreen({super.key});
  @override
  State<PatientDashboardScreen> createState() => _PatientDashboardScreenState();
}

class _PatientDashboardScreenState extends State<PatientDashboardScreen>
    with SingleTickerProviderStateMixin {

  int  _currentNavIndex = 0;

  // ── Mock schedule state ────────────────────────────────────────────────────
  // Toggle to true to show the upcoming reminder card instead of the relax card.
  bool hasUpcomingSchedule = false;
  int  freeHours           = 4;

  late final AnimationController _anim;
  late final Animation<double>   _fadeIn;
  late final Animation<Offset>   _slideUp;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 550));
    _fadeIn  = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOut));
    WidgetsBinding.instance.addPostFrameCallback((_) => _anim.forward());
  }

  @override
  void dispose() { _anim.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _fadeIn,
        child: SlideTransition(
          position: _slideUp,
          child: IndexedStack(
            index: _currentNavIndex,
            children: [
              _HomeTab(
                hasUpcomingSchedule: hasUpcomingSchedule,
                freeHours: freeHours,
              ),
              const _PlaceholderTab(
                icon: Icons.location_on_rounded,
                label: 'Location',
                color: AppColors.accent,
              ),
              const _PlaceholderTab(
                icon: Icons.alarm_rounded,
                label: 'Reminders',
                color: AppColors.highlight,
              ),
              const _PlaceholderTab(
                icon: Icons.person_rounded,
                label: 'My Profile',
                color: AppColors.primarySurface,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _BottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: (i) {
          if (i != _currentNavIndex) {
            setState(() => _currentNavIndex = i);
            _anim..reset()..forward();
          }
        },
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// _HomeTab – primary scrollable content
// ──────────────────────────────────────────────────────────────────────────────
class _HomeTab extends StatelessWidget {
  const _HomeTab({
    required this.hasUpcomingSchedule,
    required this.freeHours,
  });
  final bool hasUpcomingSchedule;
  final int  freeHours;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1 ── Simple header
              const _SimpleHeader(),
              const SizedBox(height: 24),

              // 2 ── Conditional schedule / relax card
              _ScheduleCard(
                hasUpcomingSchedule: hasUpcomingSchedule,
                freeHours: freeHours,
              ),
              const SizedBox(height: 20),

              // 3 ── Today's plan card
              const _TodaysPlanCard(),
              const SizedBox(height: 28),

              // 4 ── Mood tracker
              const _MoodTracker(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// 1. _SimpleHeader  – greeting + avatar ONLY (no hamburger, no bell)
// ──────────────────────────────────────────────────────────────────────────────
class _SimpleHeader extends StatelessWidget {
  const _SimpleHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Greeting column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, Patient 👋',
                style: GoogleFonts.baloo2(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text,
                  height: 1.1,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _supportingMessage(),
                style: GoogleFonts.baloo2(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Avatar
        Semantics(
          button: true,
          label: 'View profile',
          child: InkWell(
            onTap: () => debugPrint('Avatar tapped'),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, Color(0xFF2A6039)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(65),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                    spreadRadius: -3,
                  ),
                ],
              ),
              child: const Icon(
                Icons.person_rounded,
                color: AppColors.background,
                size: 28,
              ),
            ),
          ),
        ),
      ],
    );
  }

  static String _supportingMessage() {
    final h = DateTime.now().hour;
    if (h < 12) return "Ready for a great morning?";
    if (h < 17) return "Keep up the wonderful work!";
    return "Time to wind down and reflect.";
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// 2. _ReminderAlert  – upcoming caregiver activity (Highlight bg)
// ──────────────────────────────────────────────────────────────────────────────
class _ReminderAlert extends StatelessWidget {
  const _ReminderAlert({required this.onDismiss});
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.highlight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8CB6A), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.highlight.withAlpha(120),
            blurRadius: 20,
            offset: const Offset(0, 6),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Clock icon badge
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFB56B00).withAlpha(18),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: const Color(0xFFB56B00).withAlpha(50), width: 1),
            ),
            child: const Icon(Icons.alarm_rounded,
                color: Color(0xFFB56B00), size: 24),
          ),
          const SizedBox(width: 14),
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upcoming Activity',
                  style: GoogleFonts.baloo2(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFB56B00),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Afternoon Walk',
                  style: GoogleFonts.baloo2(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.schedule_rounded,
                      size: 13, color: Color(0xFFB56B00)),
                  const SizedBox(width: 4),
                  Text(
                    'In 45 minutes',
                    style: GoogleFonts.baloo2(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFB56B00),
                    ),
                  ),
                ]),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Got it button
          Semantics(
            button: true,
            label: 'Dismiss reminder',
            child: InkWell(
              onTap: onDismiss,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFB56B00),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Got it',
                  style: GoogleFonts.baloo2(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
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
// 3. _TodaysPlanCard  – Accent/Secondary bg, metrics + Start Plan button
// ──────────────────────────────────────────────────────────────────────────────
class _TodaysPlanCard extends StatelessWidget {
  const _TodaysPlanCard();

  static String _dateLabel() {
    final n = DateTime.now();
    const m = ['Jan','Feb','Mar','Apr','May','Jun',
                'Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${m[n.month - 1]} ${n.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFD8C9E8), // Accent
            Color(0xFFC3D19A), // Secondary
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFBCAFD4), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD8C9E8).withAlpha(110),
            blurRadius: 22,
            offset: const Offset(0, 8),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row
            Row(children: [
              Expanded(
                child: Text(
                  "Today's Plan",
                  style: GoogleFonts.baloo2(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                    height: 1.1,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.text.withAlpha(12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.calendar_today_rounded,
                      size: 12, color: AppColors.text),
                  const SizedBox(width: 5),
                  Text(
                    _dateLabel(),
                    style: GoogleFonts.baloo2(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text),
                  ),
                ]),
              ),
            ]),
            const SizedBox(height: 6),
            Text(
              'Personalised for your cognitive goals',
              style: GoogleFonts.baloo2(
                  fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            // Metrics row
            Row(children: [
              _PlanMetric(
                icon: Icons.sports_esports_rounded,
                value: '3 Games',
                color: AppColors.primary,
              ),
              const SizedBox(width: 10),
              _PlanMetric(
                icon: Icons.timer_rounded,
                value: '15 Min',
                color: const Color(0xFFB56B00),
              ),
              const SizedBox(width: 10),
              _PlanMetric(
                icon: Icons.auto_awesome_rounded,
                value: 'Adaptive',
                color: const Color(0xFF7B68A8),
              ),
            ]),
            const SizedBox(height: 20),
            // CTA
            PrimaryButton(
              text: 'Start Plan',
              icon: Icons.play_arrow_rounded,
              onPressed: () => debugPrint('Start Plan tapped'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanMetric extends StatelessWidget {
  const _PlanMetric(
      {required this.icon, required this.value, required this.color});
  final IconData icon;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withAlpha(18),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withAlpha(50)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              value,
              style: GoogleFonts.baloo2(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ]),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// 4. _MoodTracker  – daily check-in with 4 emoji buttons
// ──────────────────────────────────────────────────────────────────────────────
class _MoodTracker extends StatefulWidget {
  const _MoodTracker();
  @override
  State<_MoodTracker> createState() => _MoodTrackerState();
}

class _MoodTrackerState extends State<_MoodTracker> {
  int? _selected;

  static const _moods = [
    ('😄', 'Great',   0),
    ('🙂', 'Good',    1),
    ('😐', 'Okay',    2),
    ('😔', 'Low',     3),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How are you feeling today?',
          style: GoogleFonts.baloo2(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.text,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _selected == null
              ? 'Tap a mood to log your daily check-in'
              : 'Logged: ${_moods[_selected!].$2} ${_moods[_selected!].$1}',
          style: GoogleFonts.baloo2(
              fontSize: 13, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _moods.map((m) {
            final active = _selected == m.$3;
            return Semantics(
              button: true,
              selected: active,
              label: '${m.$2} mood',
              child: GestureDetector(
                onTap: () => setState(() => _selected = m.$3),
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeInOut,
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        // Secondary color bg (#C3D19A), deeper when active
                        color: active
                            ? AppColors.secondary
                            : AppColors.secondary.withAlpha(80),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: active
                              ? AppColors.primary
                              : Colors.transparent,
                          width: 2.5,
                        ),
                        boxShadow: active
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withAlpha(55),
                                  blurRadius: 14,
                                  offset: const Offset(0, 4),
                                  spreadRadius: -3,
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          m.$1,
                          style: TextStyle(fontSize: active ? 30 : 26),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: GoogleFonts.baloo2(
                        fontSize: 12,
                        fontWeight: active
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: active
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                      child: Text(m.$2),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// _BottomNavBar  – custom 4-tab bar: Home | Games (emphasized) | Reminder | Profile
// ──────────────────────────────────────────────────────────────────────────────
class _NavDef {
  final IconData icon;
  final String   label;
  final bool     isGames; // the emphasized centre-left item
  const _NavDef({required this.icon, required this.label, this.isGames = false});
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.currentIndex, required this.onTap});
  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _tabs = [
    _NavDef(icon: Icons.home_rounded,        label: 'Home'),
    _NavDef(icon: Icons.pin_drop_rounded,    label: 'Location', isGames: true),
    _NavDef(icon: Icons.alarm_rounded,       label: 'Reminder'),
    _NavDef(icon: Icons.person_rounded,      label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final bp = MediaQuery.paddingOf(context).bottom;
    return Container(
      decoration: BoxDecoration(
        // White / Background surface
        color: AppColors.surface,
        border: const Border(top: BorderSide(color: AppColors.outline, width: 1)),
        boxShadow: [
          BoxShadow(
            color: AppColors.text.withAlpha(14),
            blurRadius: 24,
            offset: const Offset(0, -6),
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
              final sel = i == currentIndex;
              return tab.isGames
                  ? _GamesNavItem(selected: sel, onTap: () => onTap(i))
                  : _StandardNavItem(tab: tab, selected: sel, onTap: () => onTap(i));
            }),
          ),
        ),
      ),
      padding: EdgeInsets.only(bottom: bp),
    );
  }
}

// Standard nav item (Home, Reminder, Profile)
class _StandardNavItem extends StatelessWidget {
  const _StandardNavItem(
      {required this.tab, required this.selected, required this.onTap});
  final _NavDef tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textSecondary;
    return Semantics(
      button: true, selected: selected, label: tab.label,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          constraints: const BoxConstraints(minWidth: kMinTouchTarget, minHeight: kMinTouchTarget),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: selected ? AppColors.primarySurface : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Icon(tab.icon, key: ValueKey(selected), size: 22, color: color),
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 180),
              style: GoogleFonts.baloo2(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: color,
                height: 1.0,
              ),
              child: Text(tab.label),
            ),
          ]),
        ),
      ),
    );
  }
}

// Location nav item – prominent Primary circle with white icon
class _GamesNavItem extends StatelessWidget {
  const _GamesNavItem({required this.selected, required this.onTap});
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // NOTE: No const on BoxDecoration/BoxShadow — depends on runtime `selected`.
    return Semantics(
      button: true, selected: selected, label: 'Location',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 64,
          height: kMinTouchTarget + 8,
          child: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeInOut,
                width: selected ? 52 : 46,
                height: selected ? 52 : 46,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(selected ? 110 : 65),
                      blurRadius: selected ? 18 : 10,
                      offset: Offset(0, selected ? 5 : 3),
                      spreadRadius: selected ? -2 : -4,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.pin_drop_rounded,       // Location icon
                  color: AppColors.background,  // white icon inside circle
                  size: selected ? 26 : 22,
                ),
              ),
              const SizedBox(height: 3),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 180),
                style: GoogleFonts.baloo2(
                  fontSize: 10,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? AppColors.primary : AppColors.textSecondary,
                  height: 1.0,
                ),
                child: const Text('Location'),  // updated label
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// _PlaceholderTab
// ──────────────────────────────────────────────────────────────────────────────
class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab(
      {required this.icon, required this.label, required this.color});
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(24)),
          child: Icon(icon, size: 40, color: AppColors.text),
        ),
        const SizedBox(height: 20),
        Text(label,
            style: GoogleFonts.baloo2(
                fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.text)),
        const SizedBox(height: 8),
        Text('Coming soon',
            style: GoogleFonts.baloo2(
                fontSize: 14, color: AppColors.textSecondary)),
      ]),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// _ScheduleCard  – conditional: reminder OR relax, based on hasUpcomingSchedule
// ──────────────────────────────────────────────────────────────────────────────

/// Shows [_ReminderCard] when [hasUpcomingSchedule] is true,
/// otherwise shows [_RelaxCard] with the remaining free hours.
class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({
    required this.hasUpcomingSchedule,
    required this.freeHours,
  });
  final bool hasUpcomingSchedule;
  final int  freeHours;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: anim,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.06),
            end: Offset.zero,
          ).animate(anim),
          child: child,
        ),
      ),
      child: hasUpcomingSchedule
          ? const _ReminderCard(key: ValueKey('reminder'))
          : _RelaxCard(key: const ValueKey('relax'), freeHours: freeHours),
    );
  }
}

// ── Reminder card (Highlight bg, shown when hasUpcomingSchedule = true) ────────
class _ReminderCard extends StatelessWidget {
  const _ReminderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.highlight,          // #FBE5A8
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8CB6A), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.highlight.withAlpha(120),
            blurRadius: 20,
            offset: const Offset(0, 6),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon badge
          Container(
            width: 46, height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFB56B00).withAlpha(18),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: const Color(0xFFB56B00).withAlpha(50), width: 1),
            ),
            child: const Icon(Icons.alarm_rounded,
                color: Color(0xFFB56B00), size: 24),
          ),
          const SizedBox(width: 14),
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Upcoming Activity',
                    style: GoogleFonts.baloo2(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFB56B00),
                        letterSpacing: 0.5)),
                const SizedBox(height: 2),
                Text('Afternoon Walk',
                    style: GoogleFonts.baloo2(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text,
                        height: 1.1)),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.schedule_rounded,
                      size: 13, color: Color(0xFFB56B00)),
                  const SizedBox(width: 4),
                  Text('In 45 minutes',
                      style: GoogleFonts.baloo2(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFB56B00))),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Relax card (Accent/Secondary bg, shown when hasUpcomingSchedule = false) ──
class _RelaxCard extends StatelessWidget {
  const _RelaxCard({super.key, required this.freeHours});
  final int freeHours;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        // Soft Accent + Secondary blend
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFD8C9E8), // Accent (#D8C9E8)
            Color(0xFFC3D19A), // Secondary (#C3D19A)
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: const Color(0xFFBCAFD4).withAlpha(120), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD8C9E8).withAlpha(100),
            blurRadius: 18,
            offset: const Offset(0, 6),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Row(
        children: [
          // Relaxing icon container
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(14),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.local_cafe_rounded,   // calming coffee/relax icon
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          // Text column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Relax',
                  style: GoogleFonts.baloo2(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,   // Primary Text
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'No schedule for the next $freeHours hours.',
                  style: GoogleFonts.baloo2(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary, // Secondary Text (#181818)
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
