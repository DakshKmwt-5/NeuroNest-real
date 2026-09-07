import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuronest/screens/games/sort_objects_screen.dart';
import 'package:neuronest/theme/app_theme.dart';
import 'package:neuronest/widgets/widgets.dart';

// ──────────────────────────────────────────────────────────────────────────────
// DailyRoutineScreen
// ──────────────────────────────────────────────────────────────────────────────

class DailyRoutineScreen extends StatefulWidget {
  const DailyRoutineScreen({super.key});

  @override
  State<DailyRoutineScreen> createState() => _DailyRoutineScreenState();
}

class _DailyRoutineScreenState extends State<DailyRoutineScreen> {
  // ── State ──────────────────────────────────────────────────────────────────
  int score = 100;
  int timeElapsed = 0;
  Timer? timer;

  // ── Data ───────────────────────────────────────────────────────────────────
  static const List<String> _correctOrder = [
    'Wake up & brush teeth',
    'Eat breakfast',
    'Take morning medication',
    'Eat lunch',
    'Go for an evening walk',
    'Eat dinner & sleep',
  ];

  static const List<IconData> _taskIcons = [
    Icons.wb_sunny_rounded,          // Wake up
    Icons.free_breakfast_rounded,    // Breakfast
    Icons.medication_rounded,        // Medication
    Icons.lunch_dining_rounded,      // Lunch
    Icons.directions_walk_rounded,   // Evening walk
    Icons.nightlight_round,          // Dinner & sleep
  ];

  late List<String> currentOrder;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    currentOrder = List<String>.from(_correctOrder);
    // Re-shuffle until the order doesn't accidentally match correctOrder
    do {
      currentOrder.shuffle();
    } while (_isCorrect());

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => timeElapsed++);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final int m = seconds ~/ 60;
    final int s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  /// True when currentOrder exactly matches _correctOrder
  bool _isCorrect() {
    for (int i = 0; i < _correctOrder.length; i++) {
      if (currentOrder[i] != _correctOrder[i]) return false;
    }
    return true;
  }

  /// Sum of absolute positional distances from expected
  int _calculateDistance() {
    int distance = 0;
    for (int i = 0; i < currentOrder.length; i++) {
      final int expectedIndex = _correctOrder.indexOf(currentOrder[i]);
      distance += (i - expectedIndex).abs();
    }
    return distance;
  }

  IconData _iconForTask(String task) {
    final idx = _correctOrder.indexOf(task);
    if (idx < 0 || idx >= _taskIcons.length) return Icons.check_circle_outline;
    return _taskIcons[idx];
  }

  Color _cardAccentForIndex(int correctIdx) {
    const borders = [
      Color(0xFFF9A825),
      Color(0xFF388E3C),
      Color(0xFF1565C0),
      Color(0xFFE65100),
      Color(0xFF7B1FA2),
      Color(0xFF3949AB),
    ];
    return borders[correctIdx.clamp(0, borders.length - 1)];
  }

  Color _cardBgForIndex(int correctIdx) {
    const colors = [
      Color(0xFFFFF9C4),
      Color(0xFFE8F5E9),
      Color(0xFFE3F2FD),
      Color(0xFFFFF3E0),
      Color(0xFFF3E5F5),
      Color(0xFFE8EAF6),
    ];
    return colors[correctIdx.clamp(0, colors.length - 1)];
  }

  // ── Reorder logic ──────────────────────────────────────────────────────────
  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) newIndex--;
      final item = currentOrder.removeAt(oldIndex);
      currentOrder.insert(newIndex, item);
    });
  }

  // ── Confirm logic ──────────────────────────────────────────────────────────
  void _onConfirm() {
    if (_isCorrect()) {
      timer?.cancel();
      Future.delayed(const Duration(milliseconds: 200), _showCompletionDialog);
    } else {
      final int distance = _calculateDistance();
      setState(() {
        score = max(0, score - (distance * 5));
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.swap_vert_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Not quite right! Try adjusting the order.',
                  style: GoogleFonts.baloo2(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFE65100),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // ── Completion dialog ──────────────────────────────────────────────────────
  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withAlpha(60),
                  blurRadius: 28,
                  offset: const Offset(0, 10),
                ),
              ],
              border: Border.all(color: AppColors.secondary, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Trophy badge
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.highlight,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('🌅', style: TextStyle(fontSize: 36)),
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  'Perfect Routine!',
                  style: GoogleFonts.baloo2(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'You arranged the daily tasks in the correct order!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.baloo2(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),

                // Stats
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withAlpha(50),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.secondary),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatCol(
                          label: 'Time', value: _formatTime(timeElapsed)),
                      Container(
                          width: 1,
                          height: 32,
                          color: AppColors.secondary),
                      _StatCol(label: 'Score', value: '$score%'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                PrimaryButton(
                  text: 'Next Game',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SortObjectsScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    setState(() {
                      score = 100;
                      timeElapsed = 0;
                      _resetGame();
                    });
                  },
                  child: Text(
                    'Play Again',
                    style: GoogleFonts.baloo2(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.text),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Daily Routine',
          style: GoogleFonts.baloo2(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header: Time & Score ────────────────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outline),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(10),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      const Icon(Icons.timer_outlined,
                          color: AppColors.primary, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'Time: ${_formatTime(timeElapsed)}',
                        style: GoogleFonts.baloo2(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                    ]),
                    Row(children: [
                      const Icon(Icons.stars_rounded,
                          color: Color(0xFFB56B00), size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'Score: $score%',
                        style: GoogleFonts.baloo2(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),

            // ── Instruction prompt ──────────────────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.accent.withAlpha(50),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.accent.withAlpha(80)),
                ),
                child: Row(children: [
                  const Icon(Icons.info_outline_rounded,
                      color: AppColors.primary, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Drag the tasks to arrange them from morning to night.',
                      style: GoogleFonts.baloo2(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                ]),
              ),
            ),

            // ── Reorderable Task List ───────────────────────────────────────
            Expanded(
              child: ReorderableListView(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
                onReorderItem: (oldIndex, newIndex) => _onReorder(oldIndex, newIndex),
                proxyDecorator: (child, index, animation) {
                  return AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      return Material(
                        elevation: 8,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(18),
                        child: child,
                      );
                    },
                    child: child,
                  );
                },
                children: List.generate(currentOrder.length, (index) {
                  final task = currentOrder[index];
                  final correctIdx = _correctOrder.indexOf(task);
                  final accent = _cardAccentForIndex(correctIdx);
                  final bg = _cardBgForIndex(correctIdx);
                  final icon = _iconForTask(task);

                  return Container(
                    key: Key(task),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                          color: accent.withAlpha(120), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(15),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      leading: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: accent.withAlpha(30),
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: accent.withAlpha(80)),
                        ),
                        child: Center(
                          child: Icon(icon, color: accent, size: 22),
                        ),
                      ),
                      title: Text(
                        task,
                        style: GoogleFonts.baloo2(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                      trailing: Icon(
                        Icons.drag_handle_rounded,
                        color: accent.withAlpha(180),
                        size: 26,
                      ),
                    ),
                  );
                }),
              ),
            ),

            // ── Confirm Button ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: PrimaryButton(
                text: 'Confirm Order',
                icon: Icons.check_circle_outline_rounded,
                onPressed: _onConfirm,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// _StatCol – compact stat label + value used in the dialog
// ──────────────────────────────────────────────────────────────────────────────

class _StatCol extends StatelessWidget {
  const _StatCol({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: GoogleFonts.baloo2(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.baloo2(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
