import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuronest/screens/games/where_does_it_belong_screen.dart';
import 'package:neuronest/theme/app_theme.dart';
import 'package:neuronest/widgets/widgets.dart';

// ──────────────────────────────────────────────────────────────────────────────
// GroceryItem Data Model
// ──────────────────────────────────────────────────────────────────────────────

class GroceryItem {
  final String name;
  final String emoji;
  final bool isCorrect;
  bool isTapped;

  GroceryItem({
    required this.name,
    required this.emoji,
    required this.isCorrect,
    this.isTapped = false,
  });
}

// ──────────────────────────────────────────────────────────────────────────────
// GroceryBasketScreen
// ──────────────────────────────────────────────────────────────────────────────

class GroceryBasketScreen extends StatefulWidget {
  const GroceryBasketScreen({super.key});

  @override
  State<GroceryBasketScreen> createState() => _GroceryBasketScreenState();
}

class _GroceryBasketScreenState extends State<GroceryBasketScreen> {
  int score = 6;
  int timeElapsed = 0;
  int correctSelected = 0;
  int wrongSelected = 0;
  Timer? timer;
  bool _gameOver = false;

  late List<GroceryItem> targetItems;
  late List<GroceryItem> allItems;

  static const List<Map<String, String>> _targets = [
    {'name': 'Apple',  'emoji': '🍎'},
    {'name': 'Bread',  'emoji': '🍞'},
    {'name': 'Milk',   'emoji': '🥛'},
    {'name': 'Eggs',   'emoji': '🥚'},
    {'name': 'Cheese', 'emoji': '🧀'},
    {'name': 'Carrot', 'emoji': '🥕'},
  ];

  static const List<Map<String, String>> _decoys = [
    {'name': 'Banana', 'emoji': '🍌'},
    {'name': 'Cake',   'emoji': '🍰'},
    {'name': 'Pizza',  'emoji': '🍕'},
    {'name': 'Fish',   'emoji': '🐟'},
    {'name': 'Grapes', 'emoji': '🍇'},
    {'name': 'Meat',   'emoji': '🥩'},
  ];

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    targetItems = _targets
        .map((t) => GroceryItem(
              name: t['name']!,
              emoji: t['emoji'] ?? '',
              isCorrect: true,
            ))
        .toList();
    final decoyItems = _decoys
        .map((d) => GroceryItem(
              name: d['name']!,
              emoji: d['emoji'] ?? '',
              isCorrect: false,
            ))
        .toList();

    allItems = [...targetItems, ...decoyItems]..shuffle();

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

  void _onItemTap(GroceryItem item) {
    if (item.isTapped || _gameOver) return;

    setState(() {
      item.isTapped = true;
      if (item.isCorrect) {
        correctSelected++;
      } else {
        wrongSelected++;
        score = max(0, score - 1);
      }
    });

    // Win/lose condition: all correct found OR too many wrong picks
    if (correctSelected == 6 || wrongSelected == 6) {
      _gameOver = true;
      timer?.cancel();
      // Small delay so the last tap's UI update is visible before dialog
      Future.delayed(const Duration(milliseconds: 400), _showCompletionDialog);
    }
  }

  void _showCompletionDialog() {
    final bool won = correctSelected == 6;

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
                // Result icon badge
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: won ? AppColors.highlight : const Color(0xFFFFCDD2),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      won ? '🛒' : '😅',
                      style: const TextStyle(fontSize: 36),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  won ? 'Shopping Done!' : 'Game Over!',
                  style: GoogleFonts.baloo2(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  won
                      ? 'You picked all the right groceries!'
                      : 'Too many wrong items went in the basket.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.baloo2(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),

                // Stats row
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withAlpha(50),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.secondary),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatColumn(label: 'Time',  value: _formatTime(timeElapsed)),
                      Container(width: 1, height: 32, color: AppColors.secondary),
                      _StatColumn(label: 'Score', value: '$score/6'),
                      Container(width: 1, height: 32, color: AppColors.secondary),
                      _StatColumn(label: 'Items', value: '$correctSelected/6'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Action buttons
                PrimaryButton(
                  text: 'Next Game',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    // Push Where Does It Belong as the next game
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const WhereDoesItBelongScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    setState(() {
                      score = 6;
                      timeElapsed = 0;
                      correctSelected = 0;
                      wrongSelected = 0;
                      _gameOver = false;
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.text),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Grocery Basket',
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
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
                      const Icon(Icons.timer_outlined, color: AppColors.primary, size: 22),
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
                      const Icon(Icons.shopping_basket_rounded, color: Color(0xFFB56B00), size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'Score: $score/6',
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

            // ── Shopping List (Target Items) ────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F7EB), // subtle green tint
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.secondary, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(15),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Icon(Icons.receipt_long_rounded,
                          color: AppColors.primary, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'Shopping List',
                        style: GoogleFonts.baloo2(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ]),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: targetItems.map((item) {
                        final found = item.isTapped;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: found
                                ? AppColors.primary.withAlpha(20)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: found
                                  ? AppColors.primary.withAlpha(80)
                                  : AppColors.outline,
                            ),
                          ),
                          child: Text(
                            item.name, // emoji-free in shopping list
                            style: GoogleFonts.baloo2(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: found
                                  ? AppColors.textSecondary.withAlpha(120)
                                  : AppColors.text,
                              decoration: found
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              decorationColor: AppColors.primary,
                              decorationThickness: 2,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            // ── Divider Label ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              child: Row(children: [
                const Expanded(child: Divider(color: AppColors.outline)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Tap to add to basket',
                    style: GoogleFonts.baloo2(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const Expanded(child: Divider(color: AppColors.outline)),
              ]),
            ),

            // ── Grocery Aisles Grid ─────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: allItems.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemBuilder: (context, index) {
                    final item = allItems[index];

                    // Wrong item already tapped: vanish it
                    if (!item.isCorrect && item.isTapped) {
                      return const SizedBox.shrink();
                    }

                    final bool isFound = item.isCorrect && item.isTapped;

                    return GestureDetector(
                      onTap: isFound ? null : () => _onItemTap(item),
                      child: Opacity(
                        opacity: isFound ? 0.45 : 1.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isFound
                                  ? AppColors.primary
                                  : AppColors.outline,
                              width: isFound ? 2.0 : 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(18),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      item.emoji,
                                      style: const TextStyle(fontSize: 50),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.name,
                                      style: GoogleFonts.baloo2(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isFound)
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Helper: Stats column widget used in the completion dialog
// ──────────────────────────────────────────────────────────────────────────────

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.label, required this.value});
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
