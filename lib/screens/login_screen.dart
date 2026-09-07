import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuronest/theme/app_theme.dart';
import 'package:neuronest/widgets/widgets.dart';

// ──────────────────────────────────────────────────────────────────────────────
// LoginScreen  (route: '/login')
// ──────────────────────────────────────────────────────────────────────────────

/// Credential entry screen for NeuroNest.
///
/// Contains:
///   • A pill-shaped Patient / Caregiver role toggle
///   • Username + Password [CustomTextField]s
///   • A [PrimaryButton] CTA
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  // ── State ──────────────────────────────────────────────────────────────────

  /// `true` = Patient selected, `false` = Caregiver selected.
  bool isPatient = true;

  final _formKey           = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // ── Animation ──────────────────────────────────────────────────────────────
  late final AnimationController _anim;
  late final Animation<double>   _fadeIn;
  late final Animation<Offset>   _slideUp;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeIn = CurvedAnimation(
      parent: _anim,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    );
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _anim,
      curve: const Interval(0.0, 0.9, curve: Curves.easeOut),
    ));
    WidgetsBinding.instance.addPostFrameCallback((_) => _anim.forward());
  }

  @override
  void dispose() {
    _anim.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── Handlers ───────────────────────────────────────────────────────────────

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      debugPrint('Login as ${isPatient ? 'Patient' : 'Caregiver'}');
      if (isPatient) {
        Navigator.of(context).pushReplacementNamed('/patient_dashboard');
      } else {
        Navigator.of(context).pushReplacementNamed('/caregiver_dashboard');
      }
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // ── Subtle background decorations ──────────────────────────────────
          const _LoginBackdrop(),

          // ── Main content ───────────────────────────────────────────────────
          SafeArea(
            child: FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideUp,
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      24,
                      mq.size.height * 0.04,
                      24,
                      24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ── Back button ────────────────────────────────────────
                        Align(
                          alignment: Alignment.centerLeft,
                          child: _BackChip(
                            onTap: () => Navigator.maybePop(context),
                          ),
                        ),

                        SizedBox(height: mq.size.height * 0.04),

                        // ── Header ─────────────────────────────────────────────
                        const _LoginHeader(),

                        const SizedBox(height: 32),

                        // ── Role toggle ────────────────────────────────────────
                        _RoleToggle(
                          isPatient: isPatient,
                          onChanged: (value) =>
                              setState(() => isPatient = value),
                        ),

                        const SizedBox(height: 32),

                        // ── Username field ─────────────────────────────────────
                        CustomTextField(
                          label: 'Username',
                          hint: 'Enter your username',
                          controller: _usernameController,
                          prefixIcon: Icons.person_outline_rounded,
                          textInputAction: TextInputAction.next,
                          validator: (v) =>
                              (v == null || v.trim().isEmpty)
                                  ? 'Username is required'
                                  : null,
                          semanticLabel: 'Username field',
                        ),

                        const SizedBox(height: 20),

                        // ── Password field ─────────────────────────────────────
                        CustomTextField(
                          label: 'Password',
                          hint: 'Enter your password',
                          controller: _passwordController,
                          prefixIcon: Icons.lock_outline_rounded,
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _onLogin(),
                          validator: (v) =>
                              (v == null || v.length < 4)
                                  ? 'Password must be at least 4 characters'
                                  : null,
                          semanticLabel: 'Password field',
                        ),

                        const SizedBox(height: 12),

                        // ── Forgot password link ───────────────────────────────
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () =>
                                debugPrint('Forgot password tapped'),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 8,
                              ),
                              minimumSize: const Size(
                                kMinTouchTarget,
                                kMinTouchTarget,
                              ),
                            ),
                            child: Text(
                              'Forgot password?',
                              style: GoogleFonts.baloo2(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),

                        // ── Push CTA to bottom ────────────────────────────────
                        const Spacer(),

                        // ── Role context hint ─────────────────────────────────
                        _RoleHintBanner(isPatient: isPatient),

                        const SizedBox(height: 16),

                        // ── Login CTA ─────────────────────────────────────────
                        PrimaryButton(
                          text: 'Login',
                          icon: Icons.login_rounded,
                          onPressed: _onLogin,
                          semanticLabel:
                              'Login as ${isPatient ? 'Patient' : 'Caregiver'}',
                        ),
                      ],
                    ),
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
// _LoginBackdrop
// ──────────────────────────────────────────────────────────────────────────────

class _LoginBackdrop extends StatelessWidget {
  const _LoginBackdrop();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    return Stack(
      children: [
        Container(color: AppColors.background),
        // Top-right accent blob
        Positioned(
          top: -w * 0.22,
          right: -w * 0.18,
          child: _Blob(
            diameter: w * 0.60,
            color: AppColors.accent.withAlpha(100),
          ),
        ),
        // Bottom-left highlight blob
        Positioned(
          bottom: h * 0.05,
          left: -w * 0.20,
          child: _Blob(
            diameter: w * 0.55,
            color: AppColors.highlight.withAlpha(90),
          ),
        ),
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.diameter, required this.color});
  final double diameter;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}

// ──────────────────────────────────────────────────────────────────────────────
// _BackChip
// ──────────────────────────────────────────────────────────────────────────────

class _BackChip extends StatelessWidget {
  const _BackChip({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Go back',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: kMinTouchTarget,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.outline),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: AppColors.text,
              ),
              const SizedBox(width: 6),
              Text(
                'Back',
                style: GoogleFonts.baloo2(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// _LoginHeader
// ──────────────────────────────────────────────────────────────────────────────

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo mark (compact)
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withAlpha(70),
                blurRadius: 18,
                offset: const Offset(0, 6),
                spreadRadius: -2,
              ),
            ],
          ),
          child: const Icon(
            Icons.psychology_rounded,
            size: 28,
            color: AppColors.background,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Welcome Back',
          style: GoogleFonts.baloo2(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: AppColors.text,
            height: 1.1,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Sign in to continue your journey',
          style: GoogleFonts.baloo2(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// _RoleToggle
// ──────────────────────────────────────────────────────────────────────────────

/// Pill-shaped Patient / Caregiver toggle.
///
/// The active half gets [AppColors.primary] bg + [AppColors.background] text.
/// The inactive half gets transparent bg + [AppColors.text] text.
class _RoleToggle extends StatelessWidget {
  const _RoleToggle({
    required this.isPatient,
    required this.onChanged,
  });

  final bool isPatient;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Role selector: ${isPatient ? 'Patient' : 'Caregiver'} selected',
      child: Container(
        height: 52,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          // Shared pill background: Secondary at low opacity
          color: AppColors.secondary.withAlpha(100),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: AppColors.secondary,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // ── Patient ──────────────────────────────────────────────────────
            Expanded(
              child: _RoleOption(
                label: 'Patient',
                icon: Icons.person_rounded,
                isActive: isPatient,
                onTap: () => onChanged(true),
                semanticLabel: 'Select Patient role',
              ),
            ),
            // ── Caregiver ─────────────────────────────────────────────────────
            Expanded(
              child: _RoleOption(
                label: 'Caregiver',
                icon: Icons.favorite_rounded,
                isActive: !isPatient,
                onTap: () => onChanged(false),
                semanticLabel: 'Select Caregiver role',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleOption extends StatelessWidget {
  const _RoleOption({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
    required this.semanticLabel,
  });

  final String   label;
  final IconData icon;
  final bool     isActive;
  final VoidCallback onTap;
  final String   semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isActive,
      label: semanticLabel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(26),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(60),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                    spreadRadius: -2,
                  ),
                ]
              : null,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(26),
          splashColor: AppColors.background.withAlpha(30),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isActive
                      ? AppColors.background
                      : AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: GoogleFonts.baloo2(
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive ? AppColors.background : AppColors.text,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// _RoleHintBanner
// ──────────────────────────────────────────────────────────────────────────────

/// A small contextual banner that updates based on the selected role.
class _RoleHintBanner extends StatelessWidget {
  const _RoleHintBanner({required this.isPatient});
  final bool isPatient;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 280),
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: anim,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.15),
            end: Offset.zero,
          ).animate(anim),
          child: child,
        ),
      ),
      child: Container(
        key: ValueKey(isPatient),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isPatient
              ? AppColors.primarySurface
              : AppColors.accent.withAlpha(80),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isPatient ? AppColors.secondary : AppColors.accent,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isPatient
                  ? Icons.info_outline_rounded
                  : Icons.shield_outlined,
              size: 18,
              color: isPatient ? AppColors.primary : AppColors.text,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isPatient
                    ? 'Signing in as a Patient — your data is private & secure.'
                    : 'Signing in as a Caregiver — you can manage linked profiles.',
                style: GoogleFonts.baloo2(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
