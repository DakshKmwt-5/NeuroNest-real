import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuronest/theme/app_theme.dart';

// ──────────────────────────────────────────────────────────────────────────────
// PrimaryButton
// ──────────────────────────────────────────────────────────────────────────────

/// A large, bold elevated button using [AppColors.primary] as the background
/// and [AppColors.background] as the foreground/text colour.
///
/// Minimum touch target is enforced at [kMinTouchTarget] (48 × 48 px) via
/// [minimumSize] and [MaterialTapTargetSize.padded].
///
/// ```dart
/// PrimaryButton(
///   text: 'Get Started',
///   onPressed: () => Navigator.pushNamed(context, '/home'),
/// )
/// ```
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.semanticLabel,
  });

  /// Button label.
  final String text;

  /// Callback fired on tap. Pass `null` to disable the button.
  final VoidCallback? onPressed;

  /// When `true` a [CircularProgressIndicator] replaces the label.
  final bool isLoading;

  /// When `true` (default) the button stretches to fill available width.
  final bool isFullWidth;

  /// Optional leading icon rendered before [text].
  final IconData? icon;

  /// Overrides the default semantic label (defaults to [text]).
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final bool disabled = onPressed == null || isLoading;

    final buttonChild = isLoading
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.background),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: AppColors.background),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: GoogleFonts.baloo2(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.background,
                  letterSpacing: 0.3,
                  height: 1.2,
                ),
              ),
            ],
          );

    final button = Semantics(
      label: semanticLabel ?? text,
      button: true,
      enabled: !disabled,
      child: AnimatedOpacity(
        opacity: disabled ? 0.55 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.background,
            disabledBackgroundColor: AppColors.primary.withAlpha(140),
            disabledForegroundColor: AppColors.background.withAlpha(160),
            // ── Touch target: minimum 48 × 48 px ──────────────────────────
            minimumSize: const Size(kMinTouchTarget, kMinTouchTarget),
            tapTargetSize: MaterialTapTargetSize.padded,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            // Splash / highlight colour
            overlayColor: AppColors.background.withAlpha(28),
          ),
          child: buttonChild,
        ),
      ),
    );

    return isFullWidth
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }
}
