import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuronest/services/game_score_service.dart';
import 'package:neuronest/theme/app_theme.dart';
import 'package:neuronest/widgets/widgets.dart';

// ──────────────────────────────────────────────────────────────────────────────
// SortItem Data Model
// ──────────────────────────────────────────────────────────────────────────────

class SortItem {
  final String name;
  final String emoji;
  final String category;

  SortItem({
    required this.name,
    required this.emoji,
    required this.category,
  });
}

// ──────────────────────────────────────────────────────────────────────────────
// SortObjectsScreen
// ──────────────────────────────────────────────────────────────────────────────

class SortObjectsScreen extends StatefulWidget {
  const SortObjectsScreen({super.key});

  @override
  State<SortObjectsScreen> createState() => _SortObjectsScreenState();
}

class _SortObjectsScreenState extends State<SortObjectsScreen> {
  int score = 6;
  int timeElapsed = 0;
  int currentItemIndex = 0;
  Timer? timer;
  List<String> disabledCategories = [];
  bool isAnimating = false;

  final List<String> categories = ['Animal', 'Food', 'Object'];

  static const Map<String, String> _categoryBoxIcons = {
    'Animal': '🐾',
    'Food': '🍎',
    'Object': '📦',
  };

  late List<SortItem> items;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    items = [
      SortItem(name: 'Dog', emoji: '🐶', category: 'Animal'),
      SortItem(name: 'Apple', emoji: '🍎', category: 'Food'),
      SortItem(name: 'Chair', emoji: '🪑', category: 'Object'),
      SortItem(name: 'Cat', emoji: '🐱', category: 'Animal'),
      SortItem(name: 'Banana', emoji: '🍌', category: 'Food'),
      SortItem(name: 'Book', emoji: '📘', category: 'Object'),
    ];
    items.shuffle();

    score = 6;
    timeElapsed = 0;
    currentItemIndex = 0;
    disabledCategories.clear();
    isAnimating = false;

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => timeElapsed++);
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> onCategoryTap(String category) async {
    if (isAnimating ||
        currentItemIndex >= items.length ||
        disabledCategories.contains(category)) {
      return;
    }

    final currentItem = items[currentItemIndex];

    if (category == currentItem.category) {
      // Correct Category
      setState(() {
        isAnimating = true;
      });

      await Future.delayed(const Duration(milliseconds: 400));

      if (!mounted) return;

      setState(() {
        currentItemIndex++;
        disabledCategories.clear();
        isAnimating = false;
      });

      if (currentItemIndex >= items.length) {
        timer?.cancel();
        _showWinDialog();
      }
    } else {
      // Wrong Category
      setState(() {
        disabledCategories.add(category);
        score = max(0, score - 1);
      });
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppColors.secondary, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withAlpha(50),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                    child: Text('📦', style: TextStyle(fontSize: 36)),
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  'Game Complete!',
                  style: GoogleFonts.baloo2(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'You sorted all items into their correct boxes!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.baloo2(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),

                // Stats Row
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
                      _StatCol(label: 'Time', value: _formatTime(timeElapsed)),
                      Container(width: 1, height: 32, color: AppColors.secondary),
                      _StatCol(label: 'Score', value: '$score/6'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                PrimaryButton(
                  text: 'Next Game',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () async {
                    print("--- NEXT GAME CLICKED, SAVING SCORE ---");
                    try {
                      await GameScoreService().saveScore(
                        gameName: 'Sort Objects',
                        score: score,
                        maxScore: 6,
                        timeElapsed: timeElapsed,
                      );
                      print("--- SCORE SAVED SUCCESSFULLY ---");
                    } catch (e) {
                      print("--- ERROR SAVING SCORE: $e ---");
                    }

                    if (!mounted) return;
                    Navigator.of(dialogContext).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyMemoriesScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    setState(() {
                      _initGame();
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
    final hasItem = currentItemIndex < items.length;
    final currentItem = hasItem ? items[currentItemIndex] : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Sort the Objects',
          style: GoogleFonts.baloo2(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.text,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Stats Bar ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Elapsed time pill
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.secondary, width: 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.timer_outlined,
                            size: 18, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text(
                          _formatTime(timeElapsed),
                          style: GoogleFonts.baloo2(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Progress & Score pill
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.secondary, width: 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded,
                            size: 20, color: Color(0xFFF9A825)),
                        const SizedBox(width: 6),
                        Text(
                          'Score: $score/6',
                          style: GoogleFonts.baloo2(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Instruction prompt
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Tap the correct box for the object shown below',
                textAlign: TextAlign.center,
                style: GoogleFonts.baloo2(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── Categories (Cardboard Boxes) ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: categories.map((category) {
                  final isDisabled = disabledCategories.contains(category);
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: GestureDetector(
                        onTap: () => onCategoryTap(category),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 250),
                          opacity: isDisabled ? 0.3 : 1.0,
                          child: _CardboardBoxWidget(
                            category: category,
                            iconEmoji: _categoryBoxIcons[category] ?? '📦',
                            isDisabled: isDisabled,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // ── Active Item (Bottom Section) ─────────────────────────────────
            Expanded(
              child: Center(
                child: hasItem && currentItem != null
                    ? AnimatedScale(
                        scale: isAnimating ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOutBack,
                        child: AnimatedOpacity(
                          opacity: isAnimating ? 0.0 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            width: 200,
                            padding: const EdgeInsets.symmetric(
                                vertical: 24, horizontal: 20),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                  color: AppColors.secondary, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withAlpha(25),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  currentItem.emoji,
                                  style: const TextStyle(fontSize: 80),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  currentItem.name,
                                  style: GoogleFonts.baloo2(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.text,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.highlight.withAlpha(80),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Item ${currentItemIndex + 1} of ${items.length}',
                                    style: GoogleFonts.baloo2(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Cardboard Box Category Widget
// ──────────────────────────────────────────────────────────────────────────────

class _CardboardBoxWidget extends StatelessWidget {
  final String category;
  final String iconEmoji;
  final bool isDisabled;

  const _CardboardBoxWidget({
    required this.category,
    required this.iconEmoji,
    required this.isDisabled,
  });

  @override
  Widget build(BuildContext context) {
    // Cardboard palette
    const boxBg = Color(0xFFE5D0B8);
    const boxBorder = Color(0xFF8D6E63);
    const boxDarkFlap = Color(0xFFD7BCA2);
    const textBrown = Color(0xFF5D4037);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: boxBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: boxBorder, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withAlpha(isDisabled ? 10 : 40),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Box top flap decoration
          Container(
            width: 38,
            height: 5,
            decoration: BoxDecoration(
              color: boxDarkFlap,
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: boxBorder.withAlpha(120), width: 1),
            ),
          ),
          const SizedBox(height: 8),

          Text(
            iconEmoji,
            style: const TextStyle(fontSize: 26),
          ),
          const SizedBox(height: 6),

          Text(
            category,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.baloo2(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: textBrown,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Helper Stat Column Widget
// ──────────────────────────────────────────────────────────────────────────────

class _StatCol extends StatelessWidget {
  final String label;
  final String value;

  const _StatCol({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: GoogleFonts.baloo2(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.baloo2(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.text,
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// MyMemoriesScreen Placeholder
// ──────────────────────────────────────────────────────────────────────────────

class MyMemoriesScreen extends StatelessWidget {
  const MyMemoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'My Memories',
          style: GoogleFonts.baloo2(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.text,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('📸', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              'My Memories',
              style: GoogleFonts.baloo2(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming soon!',
              style: GoogleFonts.baloo2(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
