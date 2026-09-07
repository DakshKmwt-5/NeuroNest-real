import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuronest/screens/games/grocery_basket_screen.dart';
import 'package:neuronest/services/game_score_service.dart';
import 'package:neuronest/theme/app_theme.dart';
import 'package:neuronest/widgets/widgets.dart';

// ──────────────────────────────────────────────────────────────────────────────
// MemoryCard Data Model
// ──────────────────────────────────────────────────────────────────────────────

class MemoryCard {
  final int id;
  final IconData icon;
  bool isFlipped;
  bool isMatched;

  MemoryCard({
    required this.id,
    required this.icon,
    this.isFlipped = false,
    this.isMatched = false,
  });
}

// ──────────────────────────────────────────────────────────────────────────────
// MemoryMatchScreen (route: '/games/memory_match')
// ──────────────────────────────────────────────────────────────────────────────

class MemoryMatchScreen extends StatefulWidget {
  const MemoryMatchScreen({super.key});

  @override
  State<MemoryMatchScreen> createState() => _MemoryMatchScreenState();
}

class _MemoryMatchScreenState extends State<MemoryMatchScreen> {
  static const List<IconData> _availableIcons = [
    Icons.pets_rounded,
    Icons.directions_car_rounded,
    Icons.local_florist_rounded,
    Icons.wb_sunny_rounded,
    Icons.favorite_rounded,
    Icons.star_rounded,
  ];

  late List<MemoryCard> gridCards;
  int score = 100;
  int timeElapsed = 0;
  List<int> flippedIndices = [];
  bool isProcessing = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    _timer?.cancel();
    score = 100;
    timeElapsed = 0;
    flippedIndices.clear();
    isProcessing = false;

    // Generate 2 cards for each of the 6 icons (12 cards total)
    final List<MemoryCard> cards = [];
    int idCounter = 0;
    for (final icon in _availableIcons) {
      cards.add(MemoryCard(id: idCounter++, icon: icon));
      cards.add(MemoryCard(id: idCounter++, icon: icon));
    }
    cards.shuffle();
    gridCards = cards;

    // Start timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          timeElapsed++;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final int m = seconds ~/ 60;
    final int s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  void _onCardTap(int index) async {
    final card = gridCards[index];
    if (isProcessing || card.isFlipped || card.isMatched) {
      return;
    }

    setState(() {
      card.isFlipped = true;
      flippedIndices.add(index);
    });

    if (flippedIndices.length == 2) {
      isProcessing = true;
      final int firstIndex = flippedIndices[0];
      final int secondIndex = flippedIndices[1];
      final firstCard = gridCards[firstIndex];
      final secondCard = gridCards[secondIndex];

      if (firstCard.icon == secondCard.icon) {
        // MATCH!
        setState(() {
          firstCard.isMatched = true;
          secondCard.isMatched = true;
          flippedIndices.clear();
          isProcessing = false;
        });

        // Check win condition
        if (gridCards.every((c) => c.isMatched)) {
          _timer?.cancel();
          _showWinDialog();
        }
      } else {
        // NO MATCH -> deduct 5 points (minimum score 10)
        setState(() {
          score = (score - 5).clamp(10, 100);
        });

        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          setState(() {
            firstCard.isFlipped = false;
            secondCard.isFlipped = false;
            flippedIndices.clear();
            isProcessing = false;
          });
        }
      }
    }
  }

  void _showWinDialog() {
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
                // Trophy / celebration badge
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
                    child: Icon(
                      Icons.emoji_events_rounded,
                      color: Color(0xFFB56B00),
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  'Great Job!',
                  style: GoogleFonts.baloo2(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'You completed the Memory Match exercise!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.baloo2(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),

                // Stats summary container
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withAlpha(50),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.secondary),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Time',
                            style: GoogleFonts.baloo2(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            _formatTime(timeElapsed),
                            style: GoogleFonts.baloo2(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 1,
                        height: 32,
                        color: AppColors.secondary,
                      ),
                      Column(
                        children: [
                          Text(
                            'Score',
                            style: GoogleFonts.baloo2(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            '$score%',
                            style: GoogleFonts.baloo2(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Action Buttons
                PrimaryButton(
                  text: 'Next Game',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () async {
                    print("--- NEXT GAME CLICKED, SAVING SCORE ---");
                    try {
                      await GameScoreService().saveScore(
                        gameName: 'Memory Match',
                        score: score,
                        maxScore: 100,
                        timeElapsed: timeElapsed,
                      );
                      print("--- SCORE SAVED SUCCESSFULLY ---");
                    } catch (e) {
                      print("--- ERROR SAVING SCORE: $e ---");
                    }

                    if (!mounted) return;
                    Navigator.of(dialogContext).pop();
                    // Push Grocery Basket as the next game in the sequence
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const GroceryBasketScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    setState(() {
                      _startNewGame();
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
          'Memory Match',
          style: GoogleFonts.baloo2(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.text, // Primary Text #22453E
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header with Time and Score
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
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
                    Row(
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          color: AppColors.primary,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Time: ${_formatTime(timeElapsed)}',
                          style: GoogleFonts.baloo2(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.stars_rounded,
                          color: Color(0xFFB56B00),
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Score: $score%',
                          style: GoogleFonts.baloo2(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Grid of Memory Cards
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: gridCards.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final card = gridCards[index];
                    return GestureDetector(
                      onTap: () => _onCardTap(index),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          final rotate = Tween(begin: 3.14159, end: 0.0)
                              .animate(animation);
                          return AnimatedBuilder(
                            animation: rotate,
                            child: child,
                            builder: (context, child) {
                              final isUnder =
                                  (ValueKey(card.isFlipped || card.isMatched) !=
                                      child?.key);
                              var tilt =
                                  ((animation.value - 0.5).abs() - 0.5) * 0.003;
                              tilt *= isUnder ? -1.0 : 1.0;
                              final value = isUnder
                                  ? 3.14159 * (1.0 - animation.value)
                                  : rotate.value;
                              return Transform(
                                transform: Matrix4.rotationY(value)
                                  ..setEntry(3, 0, tilt),
                                alignment: Alignment.center,
                                child: child,
                              );
                            },
                          );
                        },
                        child: (card.isFlipped || card.isMatched)
                            ? _buildCardFront(card)
                            : _buildCardBack(card),
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

  Widget _buildCardBack(MemoryCard card) {
    return Container(
      key: const ValueKey(false),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(70),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppColors.secondary.withAlpha(120),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(25),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.psychology_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
    );
  }

  Widget _buildCardFront(MemoryCard card) {
    return Opacity(
      key: const ValueKey(true),
      opacity: card.isMatched ? 0.65 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.highlight, // #FBE5A8
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: card.isMatched ? AppColors.primary : const Color(0xFFE8D394),
            width: card.isMatched ? 2.5 : 1.5,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(
                card.icon,
                color: AppColors.primary, // #347747
                size: 40,
              ),
            ),
            if (card.isMatched)
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
    );
  }
}
