import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuronest/theme/app_theme.dart';
import 'package:neuronest/widgets/widgets.dart';

// ──────────────────────────────────────────────────────────────────────────────
// OnboardingScreen  (route: '/onboarding')
// ──────────────────────────────────────────────────────────────────────────────

/// The primary onboarding / welcome screen for NeuroNest.
///
/// Layout (top → bottom inside a [Stack]):
///   1. [_OnboardingBackdrop]   – decorative corner ornaments
///   2. [SafeArea] + [Column]   – main content
///       a. Logo
///       b. App name (Baloo 2 w800)
///       c. Tagline
///       d. Hero illustration (Flexible)
///       e. Language selector (DropdownButtonFormField)
///       f. [PrimaryButton] – "Get Started"
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  // ── State ──────────────────────────────────────────────────────────────────
  String _selectedLanguage = 'English';

  static const List<String> _languages = [
    'English',
    'हिंदी (Hindi)',
    'অসমীয়া (Assamese)',
    'বাংলা (Bengali)',
    'ਪੰਜਾਬੀ (Punjabi)',
    'தமிழ் (Tamil)',
    'తెలుగు (Telugu)',
    'ಕನ್ನಡ (Kannada)',
    'മലയാളം (Malayalam)',
    'मराठी (Marathi)',
    'ગુજરાતી (Gujarati)',
    'ଓଡ଼ିଆ (Odia)',
  ];

  // ── Animation ──────────────────────────────────────────────────────────────
  late final AnimationController _anim;
  late final Animation<double>   _fadeIn;
  late final Animation<Offset>   _slideUp;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeIn = CurvedAnimation(
      parent: _anim,
      curve: const Interval(0.0, 0.75, curve: Curves.easeOut),
    );
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _anim,
      curve: const Interval(0.0, 0.85, curve: Curves.easeOut),
    ));
    WidgetsBinding.instance.addPostFrameCallback((_) => _anim.forward());
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold bg is AppColors.background (#FCFBF6) from AppTheme.light
      body: Stack(
        children: [
          // 1 ── Decorative corner ornaments ───────────────────────────────────
          const _OnboardingBackdrop(),

          // 2 ── Main content ─────────────────────────────────────────────────
          SafeArea(
            child: FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideUp,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),

                    // a ── Logo ─────────────────────────────────────────────────
                    const _LogoMark(),

                    const SizedBox(height: 20),

                    // b ── App name ─────────────────────────────────────────────
                    Text(
                      'NeuroNest',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.baloo2(
                        fontSize: 42,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text,
                        height: 1.05,
                        letterSpacing: -0.5,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // c ── Tagline ──────────────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'Your compassionate\ncognitive companion',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.baloo2(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // d ── Hero illustration ────────────────────────────────────
                    const Flexible(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 28),
                        child: _HeroIllustration(),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // e ── Language selector ────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _LanguageSelector(
                        selected: _selectedLanguage,
                        languages: _languages,
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedLanguage = val);
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // f ── CTA button ───────────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                      child: PrimaryButton(
                        text: 'Get Started',
                        icon: Icons.arrow_forward_rounded,
                        onPressed: () => Navigator.pushNamed(context, '/login'),
                      ),
                    ),
                  ],
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
// _OnboardingBackdrop
// ──────────────────────────────────────────────────────────────────────────────

/// Decorative corner ornaments using [Positioned] widgets.
class _OnboardingBackdrop extends StatelessWidget {
  const _OnboardingBackdrop();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;

    return Stack(
      children: [
        // ── Top-left: rounded container with eco icon (Secondary) ─────────────
        Positioned(
          top: -w * 0.18,
          left: -w * 0.18,
          child: Container(
            width: w * 0.55,
            height: w * 0.55,
            decoration: BoxDecoration(
              color: AppColors.secondary.withAlpha(110),
              shape: BoxShape.circle,
            ),
            child: const Align(
              alignment: Alignment(0.45, 0.45),
              child: Icon(
                Icons.eco_rounded,
                size: 36,
                color: AppColors.primary,
              ),
            ),
          ),
        ),

        // ── Top-right: rounded container (Accent / lavender) ──────────────────
        Positioned(
          top: -w * 0.12,
          right: -w * 0.14,
          child: Container(
            width: w * 0.42,
            height: w * 0.42,
            decoration: BoxDecoration(
              color: AppColors.accent.withAlpha(130),
              shape: BoxShape.circle,
            ),
          ),
        ),

        // ── Bottom-left: small highlight blob ─────────────────────────────────
        Positioned(
          bottom: w * 0.02,
          left: -w * 0.12,
          child: Container(
            width: w * 0.32,
            height: w * 0.32,
            decoration: BoxDecoration(
              color: AppColors.highlight.withAlpha(100),
              shape: BoxShape.circle,
            ),
          ),
        ),

        // ── Bottom-right: secondary blob ──────────────────────────────────────
        Positioned(
          bottom: -w * 0.08,
          right: -w * 0.08,
          child: Container(
            width: w * 0.38,
            height: w * 0.38,
            decoration: BoxDecoration(
              color: AppColors.secondary.withAlpha(90),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// _LogoMark
// ──────────────────────────────────────────────────────────────────────────────

class _LogoMark extends StatelessWidget {
  const _LogoMark();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(90),
              blurRadius: 28,
              offset: const Offset(0, 10),
              spreadRadius: -4,
            ),
          ],
        ),
        child: const Icon(
          Icons.psychology_rounded,
          size: 44,
          color: AppColors.background,
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// _HeroIllustration
// ──────────────────────────────────────────────────────────────────────────────

/// A large rounded container that acts as the hero illustration placeholder.
/// Background uses a blend of [AppColors.accent] and [AppColors.highlight].
class _HeroIllustration extends StatelessWidget {
  const _HeroIllustration();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE8DAEF), // lighter lavender (accent-ish)
            Color(0xFFFBE5A8), // warm highlight yellow
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withAlpha(60),
            blurRadius: 24,
            offset: const Offset(0, 8),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Outer glow ring
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(18),
              shape: BoxShape.circle,
            ),
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_rounded,
                size: 52,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Designed for memory\n& cognitive wellness',
            textAlign: TextAlign.center,
            style: GoogleFonts.baloo2(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.text,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// _LanguageSelector
// ──────────────────────────────────────────────────────────────────────────────

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector({
    required this.selected,
    required this.languages,
    required this.onChanged,
  });

  final String selected;
  final List<String> languages;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          'Language',
          style: GoogleFonts.baloo2(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 6),

        // Dropdown
        DropdownButtonFormField<String>(
          value: selected,
          onChanged: onChanged,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.primary,
          ),
          style: GoogleFonts.baloo2(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.text,
          ),
          dropdownColor: AppColors.surface,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.language_rounded,
              color: AppColors.primary,
              size: 20,
            ),
            filled: true,
            fillColor: AppColors.primarySurface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            // Enabled border: Secondary (#C3D19A)
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.secondary,
                width: 1.5,
              ),
            ),
            // Focused border: Primary (#347747)
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.secondary),
            ),
          ),
          items: languages.map((lang) {
            return DropdownMenuItem<String>(
              value: lang,
              child: Text(
                lang,
                style: GoogleFonts.baloo2(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.text,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
