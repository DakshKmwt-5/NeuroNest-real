import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuronest/theme/app_theme.dart';

// ──────────────────────────────────────────────────────────────────────────────
// StatCard
// ──────────────────────────────────────────────────────────────────────────────

/// Which background tint variant to apply to a [StatCard].
enum StatCardVariant {
  /// Soft lavender tint (maps to [AppColors.accent]).
  accent,

  /// Warm yellow tint (maps to [AppColors.highlight]).
  highlight,

  /// Very light primary green surface (maps to [AppColors.primarySurface]).
  primary,

  /// Plain white surface (maps to [AppColors.surface]).
  neutral,
}

/// A rounded, subtly-shadowed card for displaying a labelled metric/statistic.
///
/// The card background is tinted using [variant], cycling through the brand's
/// [AppColors.accent], [AppColors.highlight], and [AppColors.primarySurface]
/// colours for visual variety.
///
/// ```dart
/// StatCard(
///   title: 'Mood Score',
///   value: '8.4',
///   unit: '/ 10',
///   icon: Icons.sentiment_satisfied_alt_rounded,
///   variant: StatCardVariant.accent,
/// )
/// ```
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.unit,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.variant = StatCardVariant.accent,
    this.onTap,
    this.badge,
    this.trend,
  });

  /// Short label displayed above the value (e.g. "Steps Today").
  final String title;

  /// The primary numerical / string value (e.g. "12,345").
  final String value;

  /// Small unit string rendered next to the value (e.g. "kcal", "/ 10").
  final String? unit;

  /// Optional subtitle shown below the value row.
  final String? subtitle;

  /// Icon rendered in the top-right corner of the card.
  final IconData? icon;

  /// Explicit colour for [icon]; falls back to the card's tint colour.
  final Color? iconColor;

  /// Background tint variant.
  final StatCardVariant variant;

  /// Optional tap callback — adds ink-well ripple if provided.
  final VoidCallback? onTap;

  /// Optional small badge widget (e.g. a trend chip) rendered below the value.
  final Widget? badge;

  /// Optional trend value string (e.g. "+3.2%"); rendered with a green/red tint.
  final String? trend;

  // ── Colour resolution ──────────────────────────────────────────────────────

  static Color _bgColor(StatCardVariant v) {
    switch (v) {
      case StatCardVariant.accent:
        return AppColors.accent;
      case StatCardVariant.highlight:
        return AppColors.highlight;
      case StatCardVariant.primary:
        return AppColors.primarySurface;
      case StatCardVariant.neutral:
        return AppColors.surface;
    }
  }

  /// Returns a darker shade of the bg used for the icon and accent details.
  static Color _accentColor(StatCardVariant v) {
    switch (v) {
      case StatCardVariant.accent:
        return const Color(0xFF7B68A8); // deep lavender
      case StatCardVariant.highlight:
        return const Color(0xFFA07D1C); // golden amber
      case StatCardVariant.primary:
        return AppColors.primary;
      case StatCardVariant.neutral:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = _bgColor(variant);
    final accent = iconColor ?? _accentColor(variant);

    final content = Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Top row: title + icon ────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.baloo2(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (icon != null) ...[
                const SizedBox(width: 8),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: accent.withAlpha(28),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 20, color: accent),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          // ── Value row ───────────────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: GoogleFonts.baloo2(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text,
                  height: 1.1,
                ),
              ),
              if (unit != null) ...[
                const SizedBox(width: 4),
                Text(
                  unit!,
                  style: GoogleFonts.baloo2(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
          // ── Trend ───────────────────────────────────────────────────────
          if (trend != null) ...[
            const SizedBox(height: 6),
            _TrendChip(trend: trend!),
          ],
          // ── Subtitle ────────────────────────────────────────────────────
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              subtitle!,
              style: GoogleFonts.baloo2(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          // ── Custom badge ─────────────────────────────────────────────────
          if (badge != null) ...[
            const SizedBox(height: 10),
            badge!,
          ],
        ],
      ),
    );

    return Semantics(
      label: '$title: $value${unit != null ? " $unit" : ""}',
      button: onTap != null,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          splashColor: AppColors.primary.withAlpha(20),
          highlightColor: AppColors.primary.withAlpha(12),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _accentColor(variant).withAlpha(40),
                width: 1,
              ),
              boxShadow: [
                // Subtle ambient shadow for depth
                BoxShadow(
                  color: _accentColor(variant).withAlpha(30),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
                // Tight key shadow
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// _TrendChip (private helper)
// ──────────────────────────────────────────────────────────────────────────────

class _TrendChip extends StatelessWidget {
  const _TrendChip({required this.trend});

  final String trend;

  @override
  Widget build(BuildContext context) {
    final isPositive = trend.startsWith('+');
    final isNegative = trend.startsWith('-');
    final Color fgColor = isPositive
        ? const Color(0xFF276C40)
        : isNegative
            ? AppColors.error
            : AppColors.textSecondary;
    final Color bgColor = isPositive
        ? const Color(0xFFD4EDDA)
        : isNegative
            ? const Color(0xFFFADED9)
            : AppColors.primarySurface;
    final IconData arrowIcon = isPositive
        ? Icons.trending_up_rounded
        : isNegative
            ? Icons.trending_down_rounded
            : Icons.trending_flat_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(arrowIcon, size: 14, color: fgColor),
          const SizedBox(width: 3),
          Text(
            trend,
            style: GoogleFonts.baloo2(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: fgColor,
            ),
          ),
        ],
      ),
    );
  }
}
