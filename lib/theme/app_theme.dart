import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ──────────────────────────────────────────────────────────────────────────────
// NeuroNest Color Palette
// ──────────────────────────────────────────────────────────────────────────────

class AppColors {
  AppColors._();

  /// Primary – deep forest green (#347747)
  static const Color primary = Color(0xFF347747);

  /// Secondary – sage / muted lime (#C3D19A)
  static const Color secondary = Color(0xFFC3D19A);

  /// Background – warm off-white (#FCFBF6)
  static const Color background = Color(0xFFFCFBF6);

  /// Text – dark teal-green (#22453E)
  static const Color text = Color(0xFF22453E);

  /// Accent – soft lavender (#D8C9E8)
  static const Color accent = Color(0xFFD8C9E8);

  /// Highlight – warm yellow (#FBE5A8)
  static const Color highlight = Color(0xFFFBE5A8);

  // ── Derived shades ──────────────────────────────────────────────────────────

  /// Slightly muted variant of [text] for secondary labels
  static const Color textSecondary = Color(0xFF4A7068);

  /// Very light tint of [primary] for disabled states / chip backgrounds
  static const Color primarySurface = Color(0xFFE6F0EA);

  /// Pure white – card / dialog surfaces
  static const Color surface = Color(0xFFFFFFFF);

  /// Light grey – dividers, borders
  static const Color outline = Color(0xFFD4D8CC);

  /// Error red – distinct from brand palette
  static const Color error = Color(0xFFB3261E);

  /// On-primary text (white ensures ≥ 4.5 : 1 contrast on #347747)
  static const Color onPrimary = Color(0xFFFFFFFF);

  /// On-secondary text – dark teal for legibility on sage green
  static const Color onSecondary = Color(0xFF22453E);

  /// On-background / on-surface text
  static const Color onBackground = Color(0xFF22453E);

  /// On-accent text
  static const Color onAccent = Color(0xFF22453E);

  /// On-highlight text
  static const Color onHighlight = Color(0xFF22453E);
}

// ──────────────────────────────────────────────────────────────────────────────
// Typography
// ──────────────────────────────────────────────────────────────────────────────

/// Centralised text-theme factory.
///
/// Uses **Baloo 2** (via google_fonts) as the global typeface.
/// All styles default to [AppColors.text] for maximum contrast on the light
/// background, with line-heights tuned for readability.
TextTheme _buildTextTheme() {
  // Apply Baloo 2 across every M3 text role, then override colours below.
  final base = GoogleFonts.baloo2TextTheme();
  const textColor = AppColors.text;
  const secondaryColor = AppColors.textSecondary;

  return base.copyWith(
    // ── Display ───────────────────────────────────────────────────────────────
    displayLarge: base.displayLarge?.copyWith(
      fontSize: 57,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.25,
      height: 1.12,
      color: textColor,
    ),
    displayMedium: base.displayMedium?.copyWith(
      fontSize: 45,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      height: 1.16,
      color: textColor,
    ),
    displaySmall: base.displaySmall?.copyWith(
      fontSize: 36,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.22,
      color: textColor,
    ),

    // ── Headline ──────────────────────────────────────────────────────────────
    headlineLarge: base.headlineLarge?.copyWith(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      height: 1.25,
      color: textColor,
    ),
    headlineMedium: base.headlineMedium?.copyWith(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.29,
      color: textColor,
    ),
    headlineSmall: base.headlineSmall?.copyWith(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.33,
      color: textColor,
    ),

    // ── Title ─────────────────────────────────────────────────────────────────
    titleLarge: base.titleLarge?.copyWith(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.27,
      color: textColor,
    ),
    titleMedium: base.titleMedium?.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      height: 1.50,
      color: textColor,
    ),
    titleSmall: base.titleSmall?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      height: 1.43,
      color: textColor,
    ),

    // ── Body ──────────────────────────────────────────────────────────────────
    bodyLarge: base.bodyLarge?.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      height: 1.60,
      color: textColor,
    ),
    bodyMedium: base.bodyMedium?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.57,
      color: textColor,
    ),
    bodySmall: base.bodySmall?.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      height: 1.33,
      color: secondaryColor,
    ),

    // ── Label ─────────────────────────────────────────────────────────────────
    labelLarge: base.labelLarge?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      height: 1.43,
      color: textColor,
    ),
    labelMedium: base.labelMedium?.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.33,
      color: textColor,
    ),
    labelSmall: base.labelSmall?.copyWith(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.45,
      color: secondaryColor,
    ),
  );
}

// ──────────────────────────────────────────────────────────────────────────────
// ColorScheme
// ──────────────────────────────────────────────────────────────────────────────

const ColorScheme _colorScheme = ColorScheme(
  brightness: Brightness.light,

  // Primary
  primary: AppColors.primary,
  onPrimary: AppColors.onPrimary,
  primaryContainer: AppColors.primarySurface,
  onPrimaryContainer: AppColors.text,

  // Secondary
  secondary: AppColors.secondary,
  onSecondary: AppColors.onSecondary,
  secondaryContainer: AppColors.highlight,
  onSecondaryContainer: AppColors.text,

  // Tertiary (mapped to accent)
  tertiary: AppColors.accent,
  onTertiary: AppColors.onAccent,
  tertiaryContainer: AppColors.accent,
  onTertiaryContainer: AppColors.text,

  // Error
  error: AppColors.error,
  onError: AppColors.onPrimary,
  errorContainer: Color(0xFFF9DEDC),
  onErrorContainer: Color(0xFF410E0B),

  // Surface / Background
  surface: AppColors.surface,
  onSurface: AppColors.text,
  surfaceContainerHighest: AppColors.primarySurface,
  onSurfaceVariant: AppColors.textSecondary,

  // Outline
  outline: AppColors.outline,
  outlineVariant: Color(0xFFE5E8DF),

  // Inverse
  inverseSurface: AppColors.text,
  onInverseSurface: AppColors.background,
  inversePrimary: AppColors.secondary,

  // Shadow / scrim
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
);

// ──────────────────────────────────────────────────────────────────────────────
// Minimum touch-target enforcement
// ──────────────────────────────────────────────────────────────────────────────

/// A [MaterialTapTargetSize] override is set globally, but we also expose this
/// constant so individual widgets can reference it explicitly.
const double kMinTouchTarget = 48.0;

// ──────────────────────────────────────────────────────────────────────────────
// AppTheme — public entry-point
// ──────────────────────────────────────────────────────────────────────────────

abstract final class AppTheme {
  AppTheme._();

  /// The single global [ThemeData] for NeuroNest.
  static ThemeData get light {
    final textTheme = _buildTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: _colorScheme,

      // ── Background ─────────────────────────────────────────────────────────
      scaffoldBackgroundColor: AppColors.background,

      // ── Typography ─────────────────────────────────────────────────────────
      textTheme: textTheme,
      primaryTextTheme: textTheme,

      // ── Material tap-target size ────────────────────────────────────────────
      // Forces all Material interactive widgets to maintain a minimum 48×48 px
      // touch target as required by Material / WCAG accessibility guidelines.
      materialTapTargetSize: MaterialTapTargetSize.padded,

      // ── AppBar ─────────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.text,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: AppColors.text,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.text,
          size: kMinTouchTarget / 2, // 24 px icon inside 48 px target
        ),
        actionsIconTheme: const IconThemeData(
          color: AppColors.text,
          size: 24,
        ),
      ),

      // ── ElevatedButton ─────────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          minimumSize: const Size(kMinTouchTarget, kMinTouchTarget),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),

      // ── FilledButton ───────────────────────────────────────────────────────
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          minimumSize: const Size(kMinTouchTarget, kMinTouchTarget),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),

      // ── OutlinedButton ─────────────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(kMinTouchTarget, kMinTouchTarget),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),

      // ── TextButton ─────────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(kMinTouchTarget, kMinTouchTarget),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),

      // ── IconButton ─────────────────────────────────────────────────────────
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(kMinTouchTarget, kMinTouchTarget),
          fixedSize: const Size(kMinTouchTarget, kMinTouchTarget),
        ),
      ),

      // ── FloatingActionButton ───────────────────────────────────────────────
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 4,
        highlightElevation: 8,
        shape: StadiumBorder(),
      ),

      // ── Card ───────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.outline, width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      ),

      // ── InputDecoration ────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.primarySurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        constraints: const BoxConstraints(minHeight: kMinTouchTarget),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.textSecondary,
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.textSecondary,
        ),
        floatingLabelStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),

      // ── BottomNavigationBar ────────────────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: textTheme.labelSmall,
        showUnselectedLabels: true,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),

      // ── NavigationBar (M3) ─────────────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primarySurface,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary, size: 24);
          }
          return const IconThemeData(color: AppColors.textSecondary, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            );
          }
          return textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondary,
          );
        }),
      ),

      // ── Chip ───────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.primarySurface,
        selectedColor: AppColors.primary,
        secondarySelectedColor: AppColors.secondary,
        labelStyle: textTheme.labelMedium,
        secondaryLabelStyle: textTheme.labelMedium?.copyWith(
          color: AppColors.onPrimary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: const StadiumBorder(),
        side: BorderSide.none,
      ),

      // ── Divider ────────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.outline,
        thickness: 1,
        space: 1,
      ),

      // ── Dialog ─────────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        titleTextStyle: textTheme.headlineSmall?.copyWith(
          color: AppColors.text,
        ),
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.text,
        ),
      ),

      // ── SnackBar ───────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.text,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.background,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
      ),

      // ── Switch ─────────────────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.onPrimary;
          }
          return AppColors.textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.outline;
        }),
      ),

      // ── Checkbox ───────────────────────────────────────────────────────────
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.onPrimary),
        side: const BorderSide(color: AppColors.outline, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // ── Radio ──────────────────────────────────────────────────────────────
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.outline;
        }),
      ),

      // ── Slider ─────────────────────────────────────────────────────────────
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.primarySurface,
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primary.withAlpha(30),
        valueIndicatorColor: AppColors.primary,
        valueIndicatorTextStyle: textTheme.labelSmall?.copyWith(
          color: AppColors.onPrimary,
        ),
        minThumbSeparation: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
        trackHeight: 4,
      ),

      // ── ListTile ───────────────────────────────────────────────────────────
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        minVerticalPadding: 12,
        minLeadingWidth: kMinTouchTarget,
        iconColor: AppColors.primary,
        textColor: AppColors.text,
        titleTextStyle: textTheme.bodyLarge,
        subtitleTextStyle: textTheme.bodySmall,
      ),

      // ── TabBar ─────────────────────────────────────────────────────────────
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        unselectedLabelStyle: textTheme.labelLarge,
        dividerColor: AppColors.outline,
      ),

      // ── ProgressIndicator ──────────────────────────────────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.primarySurface,
        circularTrackColor: AppColors.primarySurface,
      ),

      // ── Tooltip ────────────────────────────────────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.text.withAlpha(230),
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: TextStyle(
          color: AppColors.background,
          fontSize: 12,
          fontFamily: GoogleFonts.baloo2().fontFamily,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        waitDuration: const Duration(milliseconds: 500),
      ),

      // ── BottomSheet ────────────────────────────────────────────────────────
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        showDragHandle: true,
        dragHandleColor: AppColors.outline,
      ),

      // ── Badge ──────────────────────────────────────────────────────────────
      badgeTheme: const BadgeThemeData(
        backgroundColor: AppColors.error,
        textColor: AppColors.onPrimary,
        padding: EdgeInsets.symmetric(horizontal: 6),
        smallSize: 8,
        largeSize: 16,
      ),
    );
  }
}
