import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuronest/screens/caregiver_dashboard_screen.dart';
import 'package:neuronest/screens/login_screen.dart';
import 'package:neuronest/screens/onboarding_screen.dart';
import 'package:neuronest/screens/patient_dashboard_screen.dart';
import 'package:neuronest/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Entry point
// ──────────────────────────────────────────────────────────────────────────────

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase init failed (likely missing web config): $e');
  }

  // Lock to portrait while the UI layer is being built out.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Transparent status-bar so the splash gradient bleeds edge-to-edge.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const NeuroNestApp());
}

// ──────────────────────────────────────────────────────────────────────────────
// Root application widget
// ──────────────────────────────────────────────────────────────────────────────

class NeuroNestApp extends StatelessWidget {
  const NeuroNestApp({super.key});

  // ── Route map ───────────────────────────────────────────────────────────────
  // Add new named routes here as screens are implemented.
  static const String routeSplash               = '/';
  static const String routeOnboarding           = '/onboarding';
  static const String routeLogin                = '/login';
  static const String routePatientDashboard     = '/dashboard/patient';
  static const String routePatientDashboardAlt  = '/patient_dashboard';
  static const String routeCaregiverDashboard   = '/caregiver_dashboard';

  static Map<String, WidgetBuilder> get _routes => {
        routeSplash:              (_) => const SplashScreen(),
        routeOnboarding:          (_) => const OnboardingScreen(),
        routeLogin:               (_) => const LoginScreen(),
        routePatientDashboard:    (_) => const PatientDashboardScreen(),
        routePatientDashboardAlt: (_) => const PatientDashboardScreen(),
        routeCaregiverDashboard:  (_) => const CaregiverDashboardScreen(),
      };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ── App metadata ─────────────────────────────────────────────────────
      title: 'NeuroNest',
      debugShowCheckedModeBanner: false,

      // ── Theme ─────────────────────────────────────────────────────────────
      theme: AppTheme.light,

      // ── Navigation ────────────────────────────────────────────────────────
      initialRoute: routeSplash,
      routes: _routes,

      // Page-transition: fade between all named routes
      onGenerateRoute: (settings) {
        final builder = _routes[settings.name];
        if (builder == null) return null;
        return PageRouteBuilder<void>(
          settings: settings,
          pageBuilder: (context, _, __) => builder(context),
          transitionsBuilder: (context, animation, _, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 350),
        );
      },
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// SplashScreen  (route: '/')
// ──────────────────────────────────────────────────────────────────────────────

/// Placeholder splash / landing screen.
///
/// Displays the NeuroNest wordmark in **Baloo 2** and the brand colour palette.
/// No Firebase or async initialisation is performed here; replace the body
/// with a FutureBuilder once Firebase is wired up.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    // Start entrance animation then navigate to onboarding after 2 s.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed(
          NeuroNestApp.routeOnboarding,
        );
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      // Scaffold background comes from AppTheme (AppColors.background).
      body: Stack(
        children: [
          // ── Decorative gradient backdrop ──────────────────────────────────
          _GradientBackdrop(size: size),

          // ── Centred wordmark + tagline ─────────────────────────────────────
          SafeArea(
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: const _WordmarkSection(),
                ),
              ),
            ),
          ),

          // ── Bottom version label ───────────────────────────────────────────
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnim,
              child: const _VersionLabel(),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Private sub-widgets
// ──────────────────────────────────────────────────────────────────────────────

class _GradientBackdrop extends StatelessWidget {
  const _GradientBackdrop({required this.size});
  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          // Base: warm off-white
          Container(color: AppColors.background),

          // Top-left accent blob (lavender)
          Positioned(
            top: -size.width * 0.3,
            left: -size.width * 0.25,
            child: _Blob(
              diameter: size.width * 0.9,
              color: AppColors.accent.withAlpha(90),
            ),
          ),

          // Bottom-right highlight blob (warm yellow)
          Positioned(
            bottom: -size.width * 0.2,
            right: -size.width * 0.15,
            child: _Blob(
              diameter: size.width * 0.75,
              color: AppColors.highlight.withAlpha(110),
            ),
          ),

          // Centre-left primary blob (green)
          Positioned(
            top: size.height * 0.35,
            left: -size.width * 0.4,
            child: _Blob(
              diameter: size.width * 0.65,
              color: AppColors.primarySurface.withAlpha(160),
            ),
          ),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.diameter, required this.color});
  final double diameter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _WordmarkSection extends StatelessWidget {
  const _WordmarkSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Logo mark ───────────────────────────────────────────────────────
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withAlpha(80),
                blurRadius: 32,
                offset: const Offset(0, 12),
                spreadRadius: -4,
              ),
            ],
          ),
          child: const Icon(
            Icons.psychology_rounded,
            color: AppColors.background,
            size: 48,
          ),
        ),

        const SizedBox(height: 32),

        // ── App name in Baloo 2 ──────────────────────────────────────────────
        Text(
          'NeuroNest',
          style: GoogleFonts.baloo2(
            fontSize: 48,
            fontWeight: FontWeight.w800,
            color: AppColors.text,
            height: 1.05,
            letterSpacing: -0.5,
          ),
        ),

        const SizedBox(height: 10),

        // ── Tagline ──────────────────────────────────────────────────────────
        Text(
          'Your mental wellness companion',
          textAlign: TextAlign.center,
          style: GoogleFonts.baloo2(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),

        const SizedBox(height: 40),

        // ── Palette preview pills (brand identity indicator) ─────────────────
        const _PalettePills(),
      ],
    );
  }
}

class _PalettePills extends StatelessWidget {
  const _PalettePills();

  static const _colors = [
    AppColors.primary,
    AppColors.secondary,
    AppColors.accent,
    AppColors.highlight,
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _colors
          .map(
            (c) => Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: c,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: c.withAlpha(80),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _VersionLabel extends StatelessWidget {
  const _VersionLabel();

  @override
  Widget build(BuildContext context) {
    return Text(
      'v1.0.0 · NeuroNest',
      textAlign: TextAlign.center,
      style: GoogleFonts.baloo2(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary.withAlpha(160),
        letterSpacing: 0.4,
      ),
    );
  }
}
