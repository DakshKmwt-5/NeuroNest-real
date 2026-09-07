import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuronest/theme/app_theme.dart';

/// Reminder tab content showing pre-built quick reminders and custom note sender.
class ReminderTabContent extends StatefulWidget {
  const ReminderTabContent({super.key});

  @override
  State<ReminderTabContent> createState() => _ReminderTabContentState();
}

class _ReminderTabContentState extends State<ReminderTabContent> {
  final TextEditingController _noteController = TextEditingController();

  static const List<Map<String, dynamic>> _quickReminders = [
    {
      'title': 'Take Medicines 💊',
      'color': AppColors.highlight, // #FBE5A8
    },
    {
      'title': 'Drink Water 💧',
      'color': AppColors.accent, // #D8C9E8
    },
    {
      'title': 'Meal Time 🍲',
      'color': AppColors.secondary, // #C3D19A
    },
    {
      'title': 'Afternoon Walk 🚶‍♂️',
      'color': AppColors.highlight,
    },
  ];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _sendReminder(String text) {
    if (text.trim().isEmpty) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reminder sent to patient: "$text"'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section 1: Pre-built Reminders ──
          Text(
            'Quick Reminders',
            style: GoogleFonts.baloo2(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.text, // Primary Text #22453E
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _quickReminders.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.2,
            ),
            itemBuilder: (context, index) {
              final reminder = _quickReminders[index];
              final title = reminder['title'] as String;
              final Color bgColor = reminder['color'] as Color;

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: bgColor.withAlpha(220),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: bgColor.withAlpha(100),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.baloo2(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.send_rounded,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      onPressed: () => _sendReminder(title),
                      tooltip: 'Send "$title"',
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 32),

          // ── Section 2: Send Custom Note ──
          Text(
            'Send Custom Note',
            style: GoogleFonts.baloo2(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _noteController,
            maxLines: 3,
            style: GoogleFonts.baloo2(
              fontSize: 15,
              color: AppColors.text,
            ),
            decoration: InputDecoration(
              hintText: 'Type custom reminder or note here...',
              hintStyle: GoogleFonts.baloo2(
                fontSize: 14,
                color: AppColors.textSecondary.withAlpha(150),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                _sendReminder(_noteController.text);
                _noteController.clear();
              },
              icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              label: Text(
                'Send Note',
                style: GoogleFonts.baloo2(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
