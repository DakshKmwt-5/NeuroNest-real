import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuronest/screens/caregiver_dashboard_screen.dart';
import 'package:neuronest/screens/patient_dashboard_screen.dart';
import 'package:neuronest/services/auth_service.dart';
import 'package:neuronest/theme/app_theme.dart';
import 'package:neuronest/widgets/widgets.dart';

// ──────────────────────────────────────────────────────────────────────────────
// SignUpScreen
// ──────────────────────────────────────────────────────────────────────────────

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String selectedRole = 'Caregiver';
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _onCreateAccount() async {
    final name = nameController.text.trim();
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty || username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill in all fields',
            style: GoogleFonts.baloo2(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Password must be at least 6 characters',
            style: GoogleFonts.baloo2(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await AuthService().signUpUser(
        username: username,
        password: password,
        role: selectedRole,
        fullName: name,
      );

      if (!mounted) return;

      if (selectedRole == 'Caregiver') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CaregiverDashboardScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PatientDashboardScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message ?? 'Sign up failed. Please try another username.',
            style: GoogleFonts.baloo2(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'An error occurred: $e',
            style: GoogleFonts.baloo2(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Create New Account',
                style: GoogleFonts.baloo2(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Join NeuroNest to personalize your care and cognitive exercises.',
                style: GoogleFonts.baloo2(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),

              // Role Selection Header
              Text(
                'I am a:',
                style: GoogleFonts.baloo2(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 8),

              // Role Selection Cards
              Row(
                children: [
                  Expanded(
                    child: _RoleCard(
                      icon: Icons.medical_services_rounded,
                      title: 'Caregiver',
                      isSelected: selectedRole == 'Caregiver',
                      onTap: () {
                        setState(() {
                          selectedRole = 'Caregiver';
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _RoleCard(
                      icon: Icons.person_rounded,
                      title: 'Patient',
                      isSelected: selectedRole == 'Patient',
                      onTap: () {
                        setState(() {
                          selectedRole = 'Patient';
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Input Fields
              CustomTextField(
                label: 'Full Name',
                hint: 'e.g. John Doe',
                controller: nameController,
                keyboardType: TextInputType.text,
                prefixIcon: Icons.person_outline_rounded,
              ),
              const SizedBox(height: 14),

              CustomTextField(
                label: 'Username',
                hint: 'e.g. johndoe',
                controller: usernameController,
                keyboardType: TextInputType.text,
                prefixIcon: Icons.alternate_email_rounded,
              ),
              const SizedBox(height: 14),

              CustomTextField(
                label: 'Password',
                hint: 'Create a password',
                controller: passwordController,
                obscureText: true,
                prefixIcon: Icons.lock_outline_rounded,
              ),
              const SizedBox(height: 18),

              // Submit Button
              PrimaryButton(
                text: 'Create Account',
                icon: Icons.arrow_forward_rounded,
                isLoading: isLoading,
                onPressed: isLoading ? null : _onCreateAccount,
              ),
              const SizedBox(height: 8),

              // Footer
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: GoogleFonts.baloo2(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                      children: [
                        TextSpan(
                          text: 'Log in',
                          style: GoogleFonts.baloo2(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Role Card Component
// ──────────────────────────────────────────────────────────────────────────────

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surface : AppColors.surface.withAlpha(120),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.secondary.withAlpha(150),
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(30),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.baloo2(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
