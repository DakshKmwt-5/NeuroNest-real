import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuronest/theme/app_theme.dart';
import 'package:neuronest/widgets/widgets.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Helper: SubScreenScaffold wrapper
// ──────────────────────────────────────────────────────────────────────────────

class _SubScreenScaffold extends StatelessWidget {
  const _SubScreenScaffold({
    required this.title,
    required this.body,
  });

  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.text),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          title,
          style: GoogleFonts.baloo2(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.text,
          ),
        ),
        centerTitle: true,
      ),
      body: body,
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// 1. LanguageVoiceScreen
// ──────────────────────────────────────────────────────────────────────────────

class LanguageVoiceScreen extends StatefulWidget {
  const LanguageVoiceScreen({super.key});

  @override
  State<LanguageVoiceScreen> createState() => _LanguageVoiceScreenState();
}

class _LanguageVoiceScreenState extends State<LanguageVoiceScreen> {
  String _selectedLanguage = 'English';
  double _voiceSpeed = 1.0;

  static const List<String> _languages = ['English', 'Hindi', 'NER Language'];

  @override
  Widget build(BuildContext context) {
    return _SubScreenScaffold(
      title: 'Language & Voice',
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Section 1: Select Language ──
            Text(
              'Select Language',
              style: GoogleFonts.baloo2(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: List.generate(_languages.length, (index) {
                  final lang = _languages[index];
                  final isSelected = lang == _selectedLanguage;

                  return Column(
                    children: [
                      ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: index == 0 ? const Radius.circular(16) : Radius.zero,
                            bottom: index == _languages.length - 1
                                ? const Radius.circular(16)
                                : Radius.zero,
                          ),
                        ),
                        onTap: () => setState(() => _selectedLanguage = lang),
                        title: Text(
                          lang,
                          style: GoogleFonts.baloo2(
                            fontSize: 16,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? AppColors.primary : AppColors.text,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.primary,
                                size: 22,
                              )
                            : null,
                      ),
                      if (index < _languages.length - 1)
                        const Divider(height: 1, indent: 16, endIndent: 16),
                    ],
                  );
                }),
              ),
            ),
            const SizedBox(height: 32),

            // ── Section 2: Voice Prompt Speed ──
            Text(
              'Voice Prompt Speed',
              style: GoogleFonts.baloo2(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Playback Speed',
                        style: GoogleFonts.baloo2(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                      ),
                      Text(
                        '${_voiceSpeed.toStringAsFixed(1)}x',
                        style: GoogleFonts.baloo2(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.primary,
                      inactiveTrackColor: AppColors.secondary.withAlpha(100),
                      thumbColor: AppColors.primary,
                    ),
                    child: Slider(
                      value: _voiceSpeed,
                      min: 0.5,
                      max: 2.0,
                      divisions: 6,
                      onChanged: (v) => setState(() => _voiceSpeed = v),
                    ),
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    text: 'Test Voice',
                    icon: Icons.volume_up_rounded,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Playing sample voice prompt in $_selectedLanguage at ${_voiceSpeed.toStringAsFixed(1)}x speed',
                          ),
                          backgroundColor: AppColors.primary,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// 2. AccessibilityScreen
// ──────────────────────────────────────────────────────────────────────────────

class AccessibilityScreen extends StatefulWidget {
  const AccessibilityScreen({super.key});

  @override
  State<AccessibilityScreen> createState() => _AccessibilityScreenState();
}

class _AccessibilityScreenState extends State<AccessibilityScreen> {
  double _textSize = 1.0;
  bool _highContrast = true;
  bool _screenReader = true;

  @override
  Widget build(BuildContext context) {
    return _SubScreenScaffold(
      title: 'Accessibility',
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Text Size ──
            Text(
              'Text Size',
              style: GoogleFonts.baloo2(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'A (Small)',
                        style: GoogleFonts.baloo2(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        'A (Large)',
                        style: GoogleFonts.baloo2(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.primary,
                      inactiveTrackColor: AppColors.secondary.withAlpha(100),
                      thumbColor: AppColors.primary,
                    ),
                    child: Slider(
                      value: _textSize,
                      min: 0.8,
                      max: 1.4,
                      divisions: 4,
                      onChanged: (v) => setState(() => _textSize = v),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // ── Display & Sound Settings ──
            Text(
              'Display & Screen Options',
              style: GoogleFonts.baloo2(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    activeThumbColor: AppColors.primary,
                    activeTrackColor: AppColors.primary.withAlpha(100),
                    title: Text(
                      'High Contrast Mode',
                      style: GoogleFonts.baloo2(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                    subtitle: Text(
                      'Enhances contrast for readability',
                      style: GoogleFonts.baloo2(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    value: _highContrast,
                    onChanged: (v) => setState(() => _highContrast = v),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  SwitchListTile(
                    activeThumbColor: AppColors.primary,
                    activeTrackColor: AppColors.primary.withAlpha(100),
                    title: Text(
                      'Screen Reader Compatibility',
                      style: GoogleFonts.baloo2(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                    subtitle: Text(
                      'Optimizes UI elements for assistive readers',
                      style: GoogleFonts.baloo2(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    value: _screenReader,
                    onChanged: (v) => setState(() => _screenReader = v),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// 3. EditPatientProfileScreen
// ──────────────────────────────────────────────────────────────────────────────

class EditPatientProfileScreen extends StatelessWidget {
  const EditPatientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SubScreenScaffold(
      title: 'Edit Patient Profile',
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 46,
                    backgroundColor: AppColors.accent,
                    child: Icon(
                      Icons.person_rounded,
                      size: 52,
                      color: AppColors.primary,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const CustomTextField(
              label: 'Full Name',
              hint: 'e.g. Robert Smith',
              initialValue: 'Robert Smith',
              prefixIcon: Icons.person_outline_rounded,
            ),
            const SizedBox(height: 14),
            const CustomTextField(
              label: 'Age',
              hint: 'e.g. 72',
              initialValue: '72',
              keyboardType: TextInputType.number,
              prefixIcon: Icons.cake_outlined,
            ),
            const SizedBox(height: 14),
            const CustomTextField(
              label: 'Medical Condition',
              hint: 'e.g. Early-stage Alzheimer’s',
              initialValue: 'Early-stage Alzheimer’s',
              prefixIcon: Icons.healing_outlined,
            ),
            const SizedBox(height: 14),
            const CustomTextField(
              label: 'Emergency Contact',
              hint: 'e.g. Sarah (Daughter) - (555) 019-2831',
              initialValue: 'Sarah (Daughter) - (555) 019-2831',
              prefixIcon: Icons.phone_outlined,
            ),
            const SizedBox(height: 14),
            const CustomTextField(
              label: 'Safe Zone Address',
              hint: 'e.g. 142 Elm Street, Maplewood, NJ',
              initialValue: '142 Elm Street, Maplewood, NJ',
              maxLines: 2,
              prefixIcon: Icons.home_outlined,
            ),
            const SizedBox(height: 28),
            PrimaryButton(
              text: 'Save Changes',
              icon: Icons.save_rounded,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Patient profile updated successfully!'),
                    backgroundColor: AppColors.primary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
                Navigator.of(context).maybePop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// 4. FaqScreen
// ──────────────────────────────────────────────────────────────────────────────

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  static const List<Map<String, String>> _faqs = [
    {
      'q': 'How do I add a new reminder?',
      'a': 'Go to the Reminders tab and click Send Custom Note.',
    },
    {
      'q': 'How is location tracked?',
      'a': 'Location is updated every 5 minutes while the patient is outside the Safe Zone.',
    },
    {
      'q': 'Can I add multiple caregivers?',
      'a': 'Yes, invite them via the Care Team section.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return _SubScreenScaffold(
      title: 'FAQs',
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        itemCount: _faqs.length,
        itemBuilder: (context, index) {
          final faq = _faqs[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(8),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.help_outline_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                title: Text(
                  faq['q']!,
                  style: GoogleFonts.baloo2(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                children: [
                  Text(
                    faq['a']!,
                    style: GoogleFonts.baloo2(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// 5. ContactReportScreen (for Contact Support & Report an Issue)
// ──────────────────────────────────────────────────────────────────────────────

class ContactReportScreen extends StatefulWidget {
  const ContactReportScreen({
    super.key,
    this.title = 'Contact Support',
    this.defaultIssueType = 'General Question',
  });

  final String title;
  final String defaultIssueType;

  @override
  State<ContactReportScreen> createState() => _ContactReportScreenState();
}

class _ContactReportScreenState extends State<ContactReportScreen> {
  late String _issueType;
  final TextEditingController _msgController = TextEditingController();

  static const List<String> _issueTypes = [
    'General Question',
    'Technical Problem / Bug',
    'Caregiver Sync Issue',
    'Feature Request',
    'Feedback',
  ];

  @override
  void initState() {
    super.initState();
    _issueType = widget.defaultIssueType;
    if (!_issueTypes.contains(_issueType)) {
      _issueType = _issueTypes.first;
    }
  }

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SubScreenScaffold(
      title: widget.title,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Issue Type',
              style: GoogleFonts.baloo2(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _issueType,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.text),
                  style: GoogleFonts.baloo2(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                  items: _issueTypes
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _issueType = v);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Description',
              style: GoogleFonts.baloo2(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _msgController,
              hint: 'Describe your issue or question here...',
              maxLines: 5,
            ),
            const SizedBox(height: 28),
            PrimaryButton(
              text: 'Submit',
              icon: Icons.send_rounded,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${widget.title} submitted successfully! Our team will respond shortly.'),
                    backgroundColor: AppColors.primary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
                Navigator.of(context).maybePop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// 6. PrivacySecurityScreen
// ──────────────────────────────────────────────────────────────────────────────

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SubScreenScaffold(
      title: 'Privacy & Security',
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Data Encryption
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primarySurface,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.lock_outline_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Data Encryption',
                        style: GoogleFonts.baloo2(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'All patient metrics, activity logs, reminders, and geolocation data are encrypted both in transit (TLS 1.3) and at rest (AES-256). Only authorized care team members have access.',
                    style: GoogleFonts.baloo2(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // HIPAA Compliance
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4EDDA),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.verified_user_outlined,
                          color: Color(0xFF2E7D32),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'HIPAA Compliance',
                        style: GoogleFonts.baloo2(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'NeuroNest strictly complies with HIPAA privacy and security rules to ensure protected health information (PHI) is kept completely safe, confidential, and accessible only by you and your approved care team.',
                    style: GoogleFonts.baloo2(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),

            // Request Data Deletion
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      title: Text(
                        'Request Data Deletion',
                        style: GoogleFonts.baloo2(
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      content: Text(
                        'Are you sure you want to request deletion of all patient and caregiver logs? This action is permanent.',
                        style: GoogleFonts.baloo2(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.baloo2(fontWeight: FontWeight.bold),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD32F2F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Data deletion request submitted.'),
                                backgroundColor: Color(0xFFD32F2F),
                              ),
                            );
                          },
                          child: Text(
                            'Delete Data',
                            style: GoogleFonts.baloo2(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFD32F2F)),
                label: Text(
                  'Request Data Deletion',
                  style: GoogleFonts.baloo2(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFD32F2F),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFD32F2F), width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
