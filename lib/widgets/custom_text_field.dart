import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuronest/theme/app_theme.dart';

// ──────────────────────────────────────────────────────────────────────────────
// CustomTextField
// ──────────────────────────────────────────────────────────────────────────────

/// A styled [TextFormField] aligned with the NeuroNest design system.
///
/// Features:
/// - Primary-coloured focus border (2 px) / Secondary-coloured enabled border
/// - Large, readable Baloo 2 text at 16 sp
/// - Accessible error state with red border + animated error message
/// - Optional prefix/suffix icons and an integrated clear button
/// - Minimum input height of 48 px ([kMinTouchTarget])
///
/// ```dart
/// CustomTextField(
///   label: 'Email',
///   hint: 'you@example.com',
///   keyboardType: TextInputType.emailAddress,
///   validator: (v) => v!.contains('@') ? null : 'Invalid email',
/// )
/// ```
class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.initialValue,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.showClearButton = false,
    this.enabled = true,
    this.autofocus = false,
    this.focusNode,
    this.helperText,
    this.semanticLabel,
  });

  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? initialValue;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool showClearButton;
  final bool enabled;
  final bool autofocus;
  final FocusNode? focusNode;
  final String? helperText;
  final String? semanticLabel;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _isObscured = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();
    _isObscured = widget.obscureText;
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build the suffix widget
    Widget? effectiveSuffix;
    if (widget.obscureText) {
      effectiveSuffix = _iconButton(
        icon: _isObscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        tooltip: _isObscured ? 'Show password' : 'Hide password',
        onTap: () => setState(() => _isObscured = !_isObscured),
      );
    } else if (widget.showClearButton && _hasText) {
      effectiveSuffix = _iconButton(
        icon: Icons.cancel_outlined,
        tooltip: 'Clear',
        onTap: () {
          _controller.clear();
          widget.onChanged?.call('');
        },
      );
    } else {
      effectiveSuffix = widget.suffixIcon;
    }

    return Semantics(
      label: widget.semanticLabel ?? widget.label,
      textField: true,
      enabled: widget.enabled,
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        enabled: widget.enabled,
        autofocus: widget.autofocus,
        obscureText: widget.obscureText && _isObscured,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        maxLines: widget.obscureText ? 1 : widget.maxLines,
        minLines: widget.minLines,
        maxLength: widget.maxLength,
        inputFormatters: widget.inputFormatters,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onFieldSubmitted,
        validator: widget.validator,
        style: GoogleFonts.baloo2(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: widget.enabled ? AppColors.text : AppColors.textSecondary,
          height: 1.4,
        ),
        cursorColor: AppColors.primary,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          helperText: widget.helperText,
          helperMaxLines: 2,
          // ── Sizing: enforce 48 px min height ──────────────────────────────
          constraints: const BoxConstraints(minHeight: kMinTouchTarget),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          // ── Fill ──────────────────────────────────────────────────────────
          filled: true,
          fillColor: widget.enabled
              ? AppColors.primarySurface
              : AppColors.outline.withAlpha(80),
          // ── Prefix icon ───────────────────────────────────────────────────
          prefixIcon: widget.prefixIcon != null
              ? Icon(widget.prefixIcon, color: AppColors.primary, size: 20)
              : null,
          prefixIconConstraints: const BoxConstraints(
            minWidth: 44,
            minHeight: kMinTouchTarget,
          ),
          // ── Suffix ────────────────────────────────────────────────────────
          suffixIcon: effectiveSuffix,
          suffixIconConstraints: const BoxConstraints(
            minWidth: 44,
            minHeight: kMinTouchTarget,
          ),
          // ── Label style ───────────────────────────────────────────────────
          labelStyle: GoogleFonts.baloo2(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
          floatingLabelStyle: GoogleFonts.baloo2(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
          hintStyle: GoogleFonts.baloo2(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
          helperStyle: GoogleFonts.baloo2(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
          // ── Error style ───────────────────────────────────────────────────
          errorStyle: GoogleFonts.baloo2(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.error,
          ),
          errorMaxLines: 2,
          // ── Borders ───────────────────────────────────────────────────────
          // Enabled: uses Secondary colour at 1.5 px
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.secondary, width: 1.5),
          ),
          // Focused: uses Primary colour at 2 px
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          // Disabled
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.outline.withAlpha(120), width: 1),
          ),
          // Error: uses error colour at 1.5 px
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error, width: 1.5),
          ),
          // Focused + error
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error, width: 2),
          ),
          // Default fallback
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.secondary),
          ),
        ),
      ),
    );
  }

  // ── Helper ─────────────────────────────────────────────────────────────────
  Widget _iconButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          // Padding keeps the touch area ≥ 48 × 48 px
          padding: const EdgeInsets.all(12),
          child: Icon(icon, size: 20, color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
