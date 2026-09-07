import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuronest/theme/app_theme.dart';
import 'package:neuronest/widgets/widgets.dart';

<<<<<<< HEAD
=======
// ──────────────────────────────────────────────────────────────────────────────
// PatientDashboardScreen  (route: '/patient_dashboard')
// ──────────────────────────────────────────────────────────────────────────────
>>>>>>> a20e5fe00ba6f359b28f85e8db3710e316a85633
class PatientDashboardScreen extends StatefulWidget {
  const PatientDashboardScreen({super.key});
  @override
  State<PatientDashboardScreen> createState() => _PatientDashboardScreenState();
}

class _PatientDashboardScreenState extends State<PatientDashboardScreen>
    with SingleTickerProviderStateMixin {
<<<<<<< HEAD
  int _currentNavIndex = 0;
  static const _pageTitles = ['Home', 'Games', 'Memories', 'Profile'];
  late final AnimationController _anim;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideUp;
=======

  int  _currentNavIndex = 0;

  // ── Mock schedule state ────────────────────────────────────────────────────
  // Toggle to true to show the upcoming reminder card instead of the relax card.
  bool hasUpcomingSchedule = false;
  int  freeHours           = 4;

  late final AnimationController _anim;
  late final Animation<double>   _fadeIn;
  late final Animation<Offset>   _slideUp;
>>>>>>> a20e5fe00ba6f359b28f85e8db3710e316a85633

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeIn = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
=======
    _anim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 550));
    _fadeIn  = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
>>>>>>> a20e5fe00ba6f359b28f85e8db3710e316a85633
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
<<<<<<< HEAD
      // Home tab owns its own top-nav inside the scroll; other tabs use AppBar.
      appBar: _currentNavIndex == 0
          ? null
          : _DashboardAppBar(
              title: _pageTitles[_currentNavIndex],
              showGreeting: false,
            ),
=======
>>>>>>> a20e5fe00ba6f359b28f85e8db3710e316a85633
      body: FadeTransition(
        opacity: _fadeIn,
        child: SlideTransition(
          position: _slideUp,
          child: IndexedStack(
            index: _currentNavIndex,
            children: [
<<<<<<< HEAD
              const _HomeTab(),
              const _PlaceholderTab(icon: Icons.bar_chart_rounded,        label: 'My Progress',    color: AppColors.primarySurface),
              const _PlaceholderTab(icon: Icons.sports_esports_rounded,   label: 'Cognitive Games', color: AppColors.accent),
              const _PlaceholderTab(icon: Icons.alarm_rounded,            label: 'Reminders',      color: AppColors.highlight),
              const _PlaceholderTab(icon: Icons.person_rounded,           label: 'My Profile',     color: Color(0xFFD4EDDA)),
=======
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
>>>>>>> a20e5fe00ba6f359b28f85e8db3710e316a85633
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

<<<<<<< HEAD
// ── AppBar ────────────────────────────────────────────────────────────────────
class _DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _DashboardAppBar({required this.title, this.showGreeting = true});
  final String title;
  final bool showGreeting;

  @override
  Size get preferredSize => const Size.fromHeight(72);

  static String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning';
    if (h < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top, left: 20, right: 20),
      child: SizedBox(
        height: 72,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showGreeting)
                    Text(_greeting(),
                        style: GoogleFonts.baloo2(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
                  Text(
                    showGreeting ? 'Good to see you! 👋' : title,
                    style: GoogleFonts.baloo2(
                        fontSize: showGreeting ? 20 : 22, fontWeight: FontWeight.w800, color: AppColors.text, height: 1.1),
                  ),
                ],
              ),
            ),
            _NotificationBell(),
            const SizedBox(width: 10),
            _Avatar(),
          ],
        ),
      ),
    );
  }
}

class _NotificationBell extends StatelessWidget {
  const _NotificationBell();
  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true, label: 'Notifications',
      child: InkWell(
        onTap: () => debugPrint('Notifications'),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: kMinTouchTarget, height: kMinTouchTarget,
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.outline),
          ),
          child: Stack(alignment: Alignment.center, children: [
            const Icon(Icons.notifications_outlined, color: AppColors.text, size: 22),
            Positioned(
              top: 10, right: 10,
              child: Container(
                width: 8, height: 8,
                decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar();
  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true, label: 'Profile',
      child: InkWell(
        onTap: () => debugPrint('Avatar tapped'),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: kMinTouchTarget, height: kMinTouchTarget,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: AppColors.primary.withAlpha(60), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          child: const Icon(Icons.person_rounded, color: AppColors.background, size: 24),
        ),
      ),
    );
  }
}

// ── HomeTab ───────────────────────────────────────────────────────────────────
class _HomeTab extends StatelessWidget {
  const _HomeTab();
=======
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

>>>>>>> a20e5fe00ba6f359b28f85e8db3710e316a85633
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: SafeArea(
        bottom: false,
        child: Padding(
<<<<<<< HEAD
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // ── 1. Top navigation row ──────────────────────────────────────
            const _TopNav(),
            const SizedBox(height: 20),

            // ── 2. Greeting + Avatar ───────────────────────────────────────
            const _GreetingRow(),
            const SizedBox(height: 24),

            // ── 3. Today's Plan card ───────────────────────────────────────
            const _TodaysPlanCard(),
            const SizedBox(height: 28),

            // ── 4. Mood check-in ───────────────────────────────────────────
            const _MoodBanner(),
        const SizedBox(height: 24),
        _SectionLabel(label: "Today's Overview"),
        const SizedBox(height: 12),
        const _StatsRow(),
        const SizedBox(height: 28),
        _SectionLabel(label: 'Quick Actions'),
        const SizedBox(height: 12),
        const _QuickActionsGrid(),
        const SizedBox(height: 28),

        // ── 5. Game selection ──────────────────────────────────────────────
        const _GameSelectionSection(),
        const SizedBox(height: 28),
        _SectionLabel(label: 'My Activities', seeAll: true),
        const SizedBox(height: 12),
        const _ActivitiesRow(),
        const SizedBox(height: 28),
        _SectionLabel(label: 'Recent Memories', seeAll: true),
        const SizedBox(height: 12),
        const _MemoriesList(),
        ]),
=======
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
>>>>>>> a20e5fe00ba6f359b28f85e8db3710e316a85633
        ),
      ),
    );
  }
}

<<<<<<< HEAD
class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, this.seeAll = false});
  final String label;
  final bool seeAll;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: Text(label,
            style: GoogleFonts.baloo2(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.text, height: 1.1)),
      ),
      if (seeAll)
        TextButton(
          onPressed: () => debugPrint('See all: $label'),
          style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), minimumSize: const Size(kMinTouchTarget, 32)),
          child: Text('See all', style: GoogleFonts.baloo2(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
        ),
    ]);
  }
}

// ── MoodBanner ────────────────────────────────────────────────────────────────
class _MoodBanner extends StatefulWidget {
  const _MoodBanner();
  @override
  State<_MoodBanner> createState() => _MoodBannerState();
}

class _MoodBannerState extends State<_MoodBanner> {
  int? _selected;
  static const _moods = [
    ('😢', 'Sad',   0), ('😕', 'Low',   1), ('😐', 'Okay',  2),
    ('🙂', 'Good',  3), ('😄', 'Great', 4),
  ];
=======
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
>>>>>>> a20e5fe00ba6f359b28f85e8db3710e316a85633

  @override
  Widget build(BuildContext context) {
    return Container(
<<<<<<< HEAD
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [AppColors.primary, Color(0xFF2A6039)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: AppColors.primary.withAlpha(80), blurRadius: 24, offset: const Offset(0, 8), spreadRadius: -4)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('How are you feeling today?',
            style: GoogleFonts.baloo2(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.background)),
        const SizedBox(height: 4),
        Text(
          _selected == null ? 'Tap a mood to log your check-in'
              : 'Logged: ${_moods[_selected!].$2} ${_moods[_selected!].$1}',
          style: GoogleFonts.baloo2(fontSize: 12, color: AppColors.background.withAlpha(200)),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _moods.map((m) {
            final active = _selected == m.$3;
            return Semantics(
              button: true, selected: active, label: '${m.$2} mood',
              child: GestureDetector(
                onTap: () => setState(() => _selected = m.$3),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    color: active ? AppColors.background : AppColors.background.withAlpha(35),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: active ? AppColors.background : Colors.transparent, width: 2),
                  ),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(m.$1, style: TextStyle(fontSize: active ? 22 : 18)),
                    if (active)
                      Text(m.$2, style: GoogleFonts.baloo2(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.primary)),
                  ]),
                ),
              ),
            );
          }).toList(),
        ),
      ]),
    );
  }
}

// ── StatsRow ──────────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  const _StatsRow();
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: StatCard(title: 'Mood Score', value: '7.2', unit: '/ 10', icon: Icons.sentiment_satisfied_rounded, variant: StatCardVariant.accent, trend: '+0.4')),
      const SizedBox(width: 12),
      Expanded(child: StatCard(title: 'Day Streak', value: '12', unit: 'days', icon: Icons.local_fire_department_rounded, variant: StatCardVariant.highlight, trend: '+1')),
      const SizedBox(width: 12),
      Expanded(child: StatCard(title: 'Activities', value: '4', unit: 'done', icon: Icons.check_circle_outline_rounded, variant: StatCardVariant.primary)),
    ]);
  }
}

// ── QuickActionsGrid ──────────────────────────────────────────────────────────
class _QA { final IconData icon; final String label; final Color color, bg;
  const _QA({required this.icon, required this.label, required this.color, required this.bg}); }

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid();
  static const _items = [
    _QA(icon: Icons.psychology_rounded,   label: 'Brain\nExercise', color: AppColors.primary,           bg: AppColors.primarySurface),
    _QA(icon: Icons.auto_stories_rounded, label: 'Memory\nJournal',  color: Color(0xFF7B68A8),           bg: AppColors.accent),
    _QA(icon: Icons.music_note_rounded,   label: 'Calming\nMusic',   color: Color(0xFFA07D1C),           bg: AppColors.highlight),
    _QA(icon: Icons.support_agent_rounded,label: 'Talk to\nCarer',   color: Color(0xFF276C40),           bg: Color(0xFFD4EDDA)),
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10, childAspectRatio: 0.82,
      children: _items.map((a) => Semantics(
        button: true, label: a.label.replaceAll('\n', ' '),
        child: InkWell(
          onTap: () => debugPrint('Action: ${a.label}'),
          borderRadius: BorderRadius.circular(18),
          child: Container(
            decoration: BoxDecoration(color: a.bg, borderRadius: BorderRadius.circular(18), border: Border.all(color: a.color.withAlpha(40))),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(width: 44, height: 44,
                decoration: BoxDecoration(color: a.color.withAlpha(28), borderRadius: BorderRadius.circular(14)),
                child: Icon(a.icon, color: a.color, size: 22)),
              const SizedBox(height: 8),
              Text(a.label, textAlign: TextAlign.center,
                  style: GoogleFonts.baloo2(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.text, height: 1.3)),
            ]),
          ),
        ),
      )).toList(),
=======
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
>>>>>>> a20e5fe00ba6f359b28f85e8db3710e316a85633
    );
  }
}

<<<<<<< HEAD
// ── Activities horizontal row ─────────────────────────────────────────────────
class _AI { final String title, subtitle; final IconData icon; final StatCardVariant v; final double p;
  const _AI({required this.title, required this.subtitle, required this.icon, required this.v, required this.p}); }

class _ActivitiesRow extends StatelessWidget {
  const _ActivitiesRow();
  static const _items = [
    _AI(title: 'Word Puzzle',   subtitle: '5 min · Easy',   icon: Icons.abc_rounded,        v: StatCardVariant.accent,    p: 0.6),
    _AI(title: 'Number Match',  subtitle: '8 min · Medium', icon: Icons.tag_rounded,         v: StatCardVariant.highlight, p: 0.3),
    _AI(title: 'Story Recall',  subtitle: '10 min · Hard',  icon: Icons.menu_book_rounded,   v: StatCardVariant.primary,   p: 0.0),
    _AI(title: 'Photo Match',   subtitle: '6 min · Easy',   icon: Icons.image_rounded,       v: StatCardVariant.neutral,   p: 1.0),
  ];

  static Color _bg(StatCardVariant v) {
    switch(v) {
      case StatCardVariant.accent:    return AppColors.accent;
      case StatCardVariant.highlight: return AppColors.highlight;
      case StatCardVariant.primary:   return AppColors.primarySurface;
      case StatCardVariant.neutral:   return AppColors.surface;
    }
  }
  static Color _ac(StatCardVariant v) {
    switch(v) {
      case StatCardVariant.accent:    return const Color(0xFF7B68A8);
      case StatCardVariant.highlight: return const Color(0xFFA07D1C);
      case StatCardVariant.primary:   return AppColors.primary;
      case StatCardVariant.neutral:   return AppColors.textSecondary;
    }
=======
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
>>>>>>> a20e5fe00ba6f359b28f85e8db3710e316a85633
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final it = _items[i];
          final bg = _bg(it.v); final ac = _ac(it.v);
          return Semantics(
            button: true, label: '${it.title}, ${it.subtitle}',
            child: InkWell(
              onTap: () => debugPrint('Activity: ${it.title}'),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 148, padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: bg, borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: ac.withAlpha(35)),
                  boxShadow: [BoxShadow(color: ac.withAlpha(25), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Container(width: 36, height: 36,
                      decoration: BoxDecoration(color: ac.withAlpha(28), borderRadius: BorderRadius.circular(10)),
                      child: Icon(it.icon, color: ac, size: 18)),
                    const Spacer(),
                    if (it.p >= 1.0) const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 18),
                  ]),
                  const Spacer(),
                  Text(it.title, style: GoogleFonts.baloo2(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.text), maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(it.subtitle, style: GoogleFonts.baloo2(fontSize: 11, color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(value: it.p, minHeight: 4,
                      backgroundColor: ac.withAlpha(30), valueColor: AlwaysStoppedAnimation<Color>(ac)),
                  ),
                ]),
              ),
            ),
          );
        },
=======
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
>>>>>>> a20e5fe00ba6f359b28f85e8db3710e316a85633
      ),
    );
  }
}

<<<<<<< HEAD
// ── Memories list ─────────────────────────────────────────────────────────────
class _ME { final String title, date; final IconData icon; final Color color;
  const _ME({required this.title, required this.date, required this.icon, required this.color}); }

class _MemoriesList extends StatelessWidget {
  const _MemoriesList();
  static const _items = [
    _ME(title: 'Morning walk with Maya',   date: 'Today · 09:14 AM',      icon: Icons.directions_walk_rounded, color: AppColors.primary),
    _ME(title: 'Completed Number Match',   date: 'Today · 08:30 AM',      icon: Icons.tag_rounded,              color: Color(0xFFA07D1C)),
    _ME(title: 'Watched family album',     date: 'Yesterday · 06:45 PM',  icon: Icons.photo_album_rounded,      color: Color(0xFF7B68A8)),
=======
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
>>>>>>> a20e5fe00ba6f359b28f85e8db3710e316a85633
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
<<<<<<< HEAD
      children: _items.map((m) => Semantics(
        button: true, label: '${m.title}, ${m.date}',
        child: InkWell(
          onTap: () => debugPrint('Memory: ${m.title}'),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface, borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.outline),
            ),
            child: Row(children: [
              Container(width: 44, height: 44,
                decoration: BoxDecoration(color: m.color.withAlpha(20), borderRadius: BorderRadius.circular(14)),
                child: Icon(m.icon, color: m.color, size: 22)),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(m.title, style: GoogleFonts.baloo2(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.text), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(m.date, style: GoogleFonts.baloo2(fontSize: 12, color: AppColors.textSecondary)),
              ])),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right_rounded, color: AppColors.outline, size: 20),
            ]),
          ),
        ),
      )).toList(),
=======
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
>>>>>>> a20e5fe00ba6f359b28f85e8db3710e316a85633
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
<<<<<<< HEAD
// _BottomNavBar  – custom 5-tab persistent navigation
// ──────────────────────────────────────────────────────────────────────────────

/// Fully custom bottom navigation bar anchored to [Scaffold.bottomNavigationBar].
///
/// Layout: [Container] (white/Background bg, subtle top shadow)
///   └── [Row] mainAxisAlignment: spaceAround
///       ├── Home      – icon + label (standard)
///       ├── Progress  – icon + label (standard)
///       ├── Play      – elevated Primary circle with white icon (FAB-style)
///       ├── Reminders – icon + label (standard)
///       └── Profile   – icon + label (standard)
///
/// Inactive items use [AppColors.textSecondary]; active use [AppColors.primary].
/// All touch targets are ≥ 48 × 48 px.
class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  // ── Tab definitions ─────────────────────────────────────────────────────────
  static const _tabs = [
    _NavDef(icon: Icons.home_rounded,          label: 'Home',      isPlay: false),
    _NavDef(icon: Icons.bar_chart_rounded,     label: 'Progress',  isPlay: false),
    _NavDef(icon: Icons.play_arrow_rounded,    label: 'Play',      isPlay: true),
    _NavDef(icon: Icons.alarm_rounded,         label: 'Reminders', isPlay: false),
    _NavDef(icon: Icons.person_rounded,        label: 'Profile',   isPlay: false),
=======
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
>>>>>>> a20e5fe00ba6f359b28f85e8db3710e316a85633
  ];

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final bottomPad = MediaQuery.paddingOf(context).bottom;

    return Container(
      // ── Shell: white bg + top divider + upward shadow ─────────────────────
      decoration: BoxDecoration(
        color: AppColors.surface,          // white surface
        border: const Border(
          top: BorderSide(color: AppColors.outline, width: 1),
        ),
=======
    final bp = MediaQuery.paddingOf(context).bottom;
    return Container(
      decoration: BoxDecoration(
        // White / Background surface
        color: AppColors.surface,
        border: const Border(top: BorderSide(color: AppColors.outline, width: 1)),
>>>>>>> a20e5fe00ba6f359b28f85e8db3710e316a85633
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
<<<<<<< HEAD
              final selected = i == currentIndex;

              return tab.isPlay
                  ? _PlayButton(
                      selected: selected,
                      onTap: () => onTap(i),
                    )
                  : _StandardNavItem(
                      tab: tab,
                      selected: selected,
                      onTap: () => onTap(i),
                    );
=======
              final sel = i == currentIndex;
              return tab.isGames
                  ? _GamesNavItem(selected: sel, onTap: () => onTap(i))
                  : _StandardNavItem(tab: tab, selected: sel, onTap: () => onTap(i));
>>>>>>> a20e5fe00ba6f359b28f85e8db3710e316a85633
            }),
          ),
        ),
      ),
<<<<<<< HEAD
      padding: EdgeInsets.only(bottom: bottomPad),
=======
      padding: EdgeInsets.only(bottom: bp),
>>>>>>> a20e5fe00ba6f359b28f85e8db3710e316a85633
    );
  }
}

<<<<<<< HEAD
// ── Data class ─────────────────────────────────────────────────────────────────
class _NavDef {
  final IconData icon;
  final String   label;
  final bool     isPlay;
  const _NavDef({required this.icon, required this.label, required this.isPlay});
}

// ── Standard nav item (Home, Progress, Reminders, Profile) ────────────────────
class _StandardNavItem extends StatelessWidget {
  const _StandardNavItem({
    required this.tab,
    required this.selected,
    required this.onTap,
  });

  final _NavDef      tab;
  final bool         selected;
=======
// Standard nav item (Home, Reminder, Profile)
class _StandardNavItem extends StatelessWidget {
  const _StandardNavItem(
      {required this.tab, required this.selected, required this.onTap});
  final _NavDef tab;
  final bool selected;
>>>>>>> a20e5fe00ba6f359b28f85e8db3710e316a85633
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final activeColor   = AppColors.primary;
    final inactiveColor = AppColors.textSecondary;

    return Semantics(
      button: true,
      selected: selected,
      label: tab.label,
=======
    final color = selected ? AppColors.primary : AppColors.textSecondary;
    return Semantics(
      button: true, selected: selected, label: tab.label,
>>>>>>> a20e5fe00ba6f359b28f85e8db3710e316a85633
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
<<<<<<< HEAD
          constraints: const BoxConstraints(
            minWidth: kMinTouchTarget,
            minHeight: kMinTouchTarget,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primarySurface
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with crossfade
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: Icon(
                  tab.icon,
                  key: ValueKey(selected),
                  size: 22,
                  color: selected ? activeColor : inactiveColor,
                ),
              ),
              const SizedBox(height: 3),
              // Label
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 180),
                style: GoogleFonts.baloo2(
                  fontSize: 10,
                  fontWeight:
                      selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? activeColor : inactiveColor,
                  height: 1.0,
                ),
                child: Text(tab.label),
              ),
            ],
          ),
=======
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
>>>>>>> a20e5fe00ba6f359b28f85e8db3710e316a85633
        ),
      ),
    );
  }
}

<<<<<<< HEAD
// ── Play button (centre, elevated Primary circle) ─────────────────────────────
class _PlayButton extends StatelessWidget {
  const _PlayButton({required this.selected, required this.onTap});

  final bool         selected;
=======
// Location nav item – prominent Primary circle with white icon
class _GamesNavItem extends StatelessWidget {
  const _GamesNavItem({required this.selected, required this.onTap});
  final bool selected;
>>>>>>> a20e5fe00ba6f359b28f85e8db3710e316a85633
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Semantics(
      button: true,
      selected: selected,
      label: 'Play a game',
=======
    // NOTE: No const on BoxDecoration/BoxShadow — depends on runtime `selected`.
    return Semantics(
      button: true, selected: selected, label: 'Location',
>>>>>>> a20e5fe00ba6f359b28f85e8db3710e316a85633
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 64,
<<<<<<< HEAD
          height: kMinTouchTarget + 8,  // 56 px — comfortably above 48 min
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              width: selected ? 58 : 52,
              height: selected ? 58 : 52,
              decoration: BoxDecoration(
                // Prominent Primary circle
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(selected ? 110 : 70),
                    blurRadius: selected ? 20 : 14,
                    offset: Offset(0, selected ? 6 : 4),
                    spreadRadius: selected ? -2 : -4,
                  ),
                ],
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                // White icon inside circle
                color: AppColors.background,
                size: selected ? 30 : 26,
              ),
            ),
=======
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
>>>>>>> a20e5fe00ba6f359b28f85e8db3710e316a85633
          ),
        ),
      ),
    );
  }
}

<<<<<<< HEAD

// ── Placeholder tabs ──────────────────────────────────────────────────────────
class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({required this.icon, required this.label, required this.color});
=======
// ──────────────────────────────────────────────────────────────────────────────
// _PlaceholderTab
// ──────────────────────────────────────────────────────────────────────────────
class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab(
      {required this.icon, required this.label, required this.color});
>>>>>>> a20e5fe00ba6f359b28f85e8db3710e316a85633
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 80, height: 80,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(24)),
        child: Icon(icon, size: 40, color: AppColors.text)),
      const SizedBox(height: 20),
      Text(label, style: GoogleFonts.baloo2(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.text)),
      const SizedBox(height: 8),
      Text('Coming soon', style: GoogleFonts.baloo2(fontSize: 14, color: AppColors.textSecondary)),
    ]));
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// _TopNav  – in-scroll top navigation row
// ──────────────────────────────────────────────────────────────────────────────

/// Full-width Row with a menu/hamburger icon on the left and a
/// settings / notification utility icon on the right.
/// Both buttons respect the 48x48 minimum touch target.
class _TopNav extends StatelessWidget {
  const _TopNav();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ── Left: menu icon ─────────────────────────────────────────────────
        Semantics(
          button: true,
          label: 'Open menu',
          child: InkWell(
            onTap: () => debugPrint('Menu tapped'),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: kMinTouchTarget,
              height: kMinTouchTarget,
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.outline),
              ),
              child: const Icon(
                Icons.menu_rounded,
                color: AppColors.text,
                size: 22,
              ),
            ),
          ),
        ),

        // ── Centre: NeuroNest wordmark ────────────────────────────────────
        Expanded(
          child: Center(
            child: Text(
              'NeuroNest',
              style: GoogleFonts.baloo2(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                letterSpacing: -0.3,
              ),
            ),
          ),
        ),

        // ── Right: settings / notifications icon ─────────────────────────
        Stack(
          alignment: Alignment.center,
          children: [
            Semantics(
              button: true,
              label: 'Settings and notifications',
              child: InkWell(
                onTap: () => debugPrint('Settings tapped'),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: kMinTouchTarget,
                  height: kMinTouchTarget,
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.outline),
                  ),
                  child: const Icon(
                    Icons.notifications_outlined,
                    color: AppColors.text,
                    size: 22,
                  ),
                ),
              ),
            ),
            // Unread badge dot
            Positioned(
              top: 9,
              right: 9,
              child: Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.background, width: 1.5),
                ),
              ),
            ),
          ],
        ),
      ],
=======
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
>>>>>>> a20e5fe00ba6f359b28f85e8db3710e316a85633
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
<<<<<<< HEAD
// _GreetingRow  – patient greeting + avatar
// ──────────────────────────────────────────────────────────────────────────────

/// A Row with greeting text on the left and a circular avatar on the right.
///
/// Left [Column]:
///   • Large greeting "Hello, Patient 👋" in [AppColors.text] (Primary Text)
///   • Short supporting message in [AppColors.textSecondary]
///
/// Right: Animated avatar container in [AppColors.primary].
class _GreetingRow extends StatelessWidget {
  const _GreetingRow();

  static String _timeOfDay() {
    final h = DateTime.now().hour;
    if (h < 12) return "Let's start the morning right!";
    if (h < 17) return "Keep up the great work today!";
    return "Wind down and reflect 🌙";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ── Left: greeting column ───────────────────────────────────────────
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, Patient 👋',
                style: GoogleFonts.baloo2(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text, // Primary Text
                  height: 1.1,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _timeOfDay(),
                style: GoogleFonts.baloo2(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary, // Secondary Text
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),

        // ── Right: avatar ────────────────────────────────────────────────────
        Semantics(
          button: true,
          label: 'View profile',
          child: InkWell(
            onTap: () => debugPrint('Avatar tapped'),
            borderRadius: BorderRadius.circular(22),
            child: Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, Color(0xFF2A6039)],
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(70),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                    spreadRadius: -2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.person_rounded,
                color: AppColors.background,
                size: 30,
              ),
            ),
          ),
        ),
      ],
=======
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
>>>>>>> a20e5fe00ba6f359b28f85e8db3710e316a85633
    );
  }
}

<<<<<<< HEAD
// ──────────────────────────────────────────────────────────────────────────────
// _TodaysPlanCard  – prominent daily plan card
// ──────────────────────────────────────────────────────────────────────────────

/// A large, rounded card using a blended Highlight + Accent background.
///
/// Contains:
///   • "Today's Plan" bold title with a calendar chip
///   • Three metric pills: Games count, Duration, Difficulty
///   • [PrimaryButton] "Start Plan" CTA
class _TodaysPlanCard extends StatelessWidget {
  const _TodaysPlanCard();
=======
// ── Reminder card (Highlight bg, shown when hasUpcomingSchedule = true) ────────
class _ReminderCard extends StatelessWidget {
  const _ReminderCard({super.key});
>>>>>>> a20e5fe00ba6f359b28f85e8db3710e316a85633

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
<<<<<<< HEAD
      decoration: BoxDecoration(
        // Blended Highlight (#FBE5A8) → Accent (#D8C9E8) gradient
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFBE5A8), // Highlight
            Color(0xFFEDD9F0), // Accent-leaning lavender
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFF0D690),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFBE5A8).withAlpha(120),
            blurRadius: 24,
            offset: const Offset(0, 8),
=======
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
>>>>>>> a20e5fe00ba6f359b28f85e8db3710e316a85633
            spreadRadius: -4,
          ),
        ],
      ),
<<<<<<< HEAD
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header row: title + date chip ──────────────────────────────
            Row(
              children: [
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
                // Date chip
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.text.withAlpha(12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.calendar_today_rounded,
                        size: 13,
                        color: AppColors.text,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        _todayLabel(),
                        style: GoogleFonts.baloo2(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Personalised for your cognitive goals',
              style: GoogleFonts.baloo2(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 20),

            // ── Metrics row: 3 Games · 15 Min · Adaptive ───────────────────
            Row(
              children: [
                _PlanMetric(
                  icon: Icons.sports_esports_rounded,
                  value: '3 Games',
                  color: AppColors.primary,
                ),
                const SizedBox(width: 10),
                _PlanMetric(
                  icon: Icons.timer_rounded,
                  value: '15 Min',
                  color: const Color(0xFFA07D1C),
                ),
                const SizedBox(width: 10),
                _PlanMetric(
                  icon: Icons.auto_awesome_rounded,
                  value: 'Adaptive',
                  color: const Color(0xFF7B68A8),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── CTA ────────────────────────────────────────────────────────
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

  static String _todayLabel() {
    final now = DateTime.now();
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    return '${months[now.month - 1]} ${now.day}';
  }
}

/// A single metric pill inside the Today's Plan card.
class _PlanMetric extends StatelessWidget {
  const _PlanMetric({
    required this.icon,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String   value;
  final Color    color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withAlpha(18),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withAlpha(50), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                value,
                style: GoogleFonts.baloo2(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// _GameSelectionSection
// ──────────────────────────────────────────────────────────────────────────────

/// "Choose a Game" heading row + supporting description + 3x2 category grid.
class _GameSelectionSection extends StatelessWidget {
  const _GameSelectionSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header row: title + forward icon ──────────────────────────────
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                'Choose a Game',
                style: GoogleFonts.baloo2(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                  height: 1.1,
                ),
              ),
            ),
            Semantics(
              button: true,
              label: 'See all games',
              child: InkWell(
                onTap: () => debugPrint('See all games tapped'),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: kMinTouchTarget,
                  height: kMinTouchTarget,
                  alignment: Alignment.center,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.outline),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 4),

        // ── Supporting description ─────────────────────────────────────────
        Text(
          'Train different areas of your mind with\ntailored cognitive exercises.',
          style: GoogleFonts.baloo2(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 16),

        // ── 3 x 2 game category grid ───────────────────────────────────────
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _GameCategoryTile._categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.88,
          ),
          itemBuilder: (context, index) {
            final cat = _GameCategoryTile._categories[index];
            return _GameCategoryTile(category: cat);
          },
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// _GameCategory  (data class)
// ──────────────────────────────────────────────────────────────────────────────

class _GameCategory {
  final String   name;
  final String   description;
  final IconData icon;
  final Color    iconColor;
  final Color    bgColor;
  final Color    borderColor;

  const _GameCategory({
    required this.name,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.borderColor,
  });
}

// ──────────────────────────────────────────────────────────────────────────────
// _GameCategoryTile
// ──────────────────────────────────────────────────────────────────────────────

class _GameCategoryTile extends StatelessWidget {
  const _GameCategoryTile({required this.category});
  final _GameCategory category;

  /// 3 x 2 = 6 game categories, each with a distinct colour from the palette.
  static const List<_GameCategory> _categories = [
    _GameCategory(
      name: 'Memory',
      description: 'Recall & retention',
      icon: Icons.psychology_rounded,
      iconColor: Color(0xFF7B68A8),   // deep lavender
      bgColor: AppColors.accent,      // #D8C9E8
      borderColor: Color(0xFFBCAFD4),
    ),
    _GameCategory(
      name: 'Attention',
      description: 'Focus & tracking',
      icon: Icons.center_focus_strong_rounded,
      iconColor: AppColors.primary,   // #347747
      bgColor: AppColors.primarySurface,
      borderColor: Color(0xFF9FC8A8),
    ),
    _GameCategory(
      name: 'Language',
      description: 'Words & meaning',
      icon: Icons.translate_rounded,
      iconColor: Color(0xFF2979A0),   // teal-blue
      bgColor: Color(0xFFD6EAF8),
      borderColor: Color(0xFFADD4EE),
    ),
    _GameCategory(
      name: 'Logic',
      description: 'Reasoning & rules',
      icon: Icons.account_tree_rounded,
      iconColor: Color(0xFFB56B00),   // warm amber
      bgColor: AppColors.highlight,   // #FBE5A8
      borderColor: Color(0xFFE8CB6A),
    ),
    _GameCategory(
      name: 'Math',
      description: 'Numbers & patterns',
      icon: Icons.calculate_rounded,
      iconColor: Color(0xFFB3261E),   // warm red
      bgColor: Color(0xFFFADED9),
      borderColor: Color(0xFFEFB5AF),
    ),
    _GameCategory(
      name: 'Visual',
      description: 'Shapes & patterns',
      icon: Icons.grid_view_rounded,
      iconColor: Color(0xFF276C40),   // forest green
      bgColor: Color(0xFFD4EDDA),
      borderColor: Color(0xFF9ACFAB),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${category.name} games: ${category.description}',
      child: InkWell(
        onTap: () => debugPrint('Game category tapped: ${category.name}'),
        borderRadius: BorderRadius.circular(18),
        splashColor: category.iconColor.withAlpha(25),
        highlightColor: category.iconColor.withAlpha(12),
        child: Container(
          decoration: BoxDecoration(
            color: category.bgColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: category.borderColor,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: category.iconColor.withAlpha(22),
                blurRadius: 10,
                offset: const Offset(0, 4),
                spreadRadius: -2,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Icon container ──────────────────────────────────────────
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: category.iconColor.withAlpha(22),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    category.icon,
                    size: 24,
                    color: category.iconColor,
                  ),
                ),

                const SizedBox(height: 10),

                // ── Category name ────────────────────────────────────────────
                Text(
                  category.name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.baloo2(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                    height: 1.1,
                  ),
                ),

                const SizedBox(height: 3),

                // ── Short description ────────────────────────────────────────
                Text(
                  category.description,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.baloo2(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                    height: 1.3,
=======
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
>>>>>>> a20e5fe00ba6f359b28f85e8db3710e316a85633
                  ),
                ),
              ],
            ),
          ),
<<<<<<< HEAD
        ),
=======
        ],
>>>>>>> a20e5fe00ba6f359b28f85e8db3710e316a85633
      ),
    );
  }
}
