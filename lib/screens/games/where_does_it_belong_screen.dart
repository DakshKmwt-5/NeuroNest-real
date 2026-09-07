import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuronest/screens/games/daily_routine_screen.dart';
import 'package:neuronest/services/game_score_service.dart';
import 'package:neuronest/theme/app_theme.dart';
import 'package:neuronest/widgets/widgets.dart';

// ──────────────────────────────────────────────────────────────────────────────
// HouseholdItem Data Model
// ──────────────────────────────────────────────────────────────────────────────

class HouseholdItem {
  final String name;
  final String emoji;
  final String correctRoom;

  HouseholdItem({
    required this.name,
    required this.emoji,
    required this.correctRoom,
  });
}

// ──────────────────────────────────────────────────────────────────────────────
// WhereDoesItBelongScreen
// ──────────────────────────────────────────────────────────────────────────────

class WhereDoesItBelongScreen extends StatefulWidget {
  const WhereDoesItBelongScreen({super.key});

  @override
  State<WhereDoesItBelongScreen> createState() =>
      _WhereDoesItBelongScreenState();
}

class _WhereDoesItBelongScreenState extends State<WhereDoesItBelongScreen> {
  int score = 6;
  int timeElapsed = 0;
  int currentItemIndex = 0;
  Timer? timer;
  List<String> disabledRooms = [];

  // ── Rooms ──────────────────────────────────────────────────────────────────
  final List<String> rooms = ['Hall', 'Bathroom', 'Kitchen', 'Bedroom'];

  static const Map<String, IconData> _roomIcons = {
    'Hall':     Icons.tv_rounded,
    'Bathroom': Icons.bathtub_rounded,
    'Kitchen':  Icons.microwave_rounded,
    'Bedroom':  Icons.bed_rounded,
  };

  static const Map<String, Color> _roomColors = {
    'Hall':     Color(0xFFE8EAF6), // Lavender tint
    'Bathroom': Color(0xFFE0F7FA), // Cyan tint
    'Kitchen':  Color(0xFFFFF9C4), // Yellow tint
    'Bedroom':  Color(0xFFFCE4EC), // Pink tint
  };

  static const Map<String, Color> _roomAccents = {
    'Hall':     Color(0xFF5C6BC0),
    'Bathroom': Color(0xFF0097A7),
    'Kitchen':  Color(0xFFF9A825),
    'Bedroom':  Color(0xFFE91E63),
  };

  // ── Items ──────────────────────────────────────────────────────────────────
  late final List<HouseholdItem> items = [
    HouseholdItem(name: 'Toothbrush', emoji: '🪥', correctRoom: 'Bathroom'),
    HouseholdItem(name: 'Frying Pan', emoji: '🍳', correctRoom: 'Kitchen'),
    HouseholdItem(name: 'TV Remote',  emoji: '📺', correctRoom: 'Hall'),
    HouseholdItem(name: 'Pillow',     emoji: '🛏️', correctRoom: 'Bedroom'),
    HouseholdItem(name: 'Soap',       emoji: '🧼', correctRoom: 'Bathroom'),
    HouseholdItem(name: 'Plate',      emoji: '🍽️', correctRoom: 'Kitchen'),
  ];

  @override
  void initState() {
    super.initState();
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

  void _onCorrect() {
    setState(() {
      disabledRooms.clear();
      currentItemIndex++;
    });
    if (currentItemIndex >= items.length) {
      timer?.cancel();
      Future.delayed(const Duration(milliseconds: 350), _showCompletionDialog);
    }
  }

  void _onWrong(String roomName) {
    setState(() {
      disabledRooms.add(roomName);
      score = (score - 1).clamp(0, 6);
    });
  }

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
                // Badge
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
                    child: Text('🏠', style: TextStyle(fontSize: 36)),
                  ),
                ),
                const SizedBox(height: 16),

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
                  'You sorted all items into the right rooms!',
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
                      _StatCol(label: 'Time',  value: _formatTime(timeElapsed)),
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
                        gameName: 'Where Does It Belong',
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
                    // Push Daily Routine as the next game
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const DailyRoutineScreen(),
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
                      currentItemIndex = 0;
                      disabledRooms.clear();
                      timer?.cancel();
                      timer = Timer.periodic(
                        const Duration(seconds: 1),
                        (_) {
                          if (mounted) setState(() => timeElapsed++);
                        },
                      );
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
    final bool gameComplete = currentItemIndex >= items.length;
    final HouseholdItem? currentItem =
        gameComplete ? null : items[currentItemIndex];

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
          'Where Does It Belong?',
          style: GoogleFonts.baloo2(
            fontSize: 20,
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

            // ── Progress dots ───────────────────────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(items.length, (i) {
                  final done = i < currentItemIndex;
                  final current = i == currentItemIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: current ? 20 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: done
                          ? AppColors.primary
                          : current
                              ? AppColors.secondary
                              : AppColors.outline,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  );
                }),
              ),
            ),

            // ── Active Item Card ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 60, vertical: 10),
              child: currentItem == null
                  ? const SizedBox.shrink()
                  : Column(
                      children: [
                        Text(
                          'Drag this item to the correct room:',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.baloo2(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Draggable<HouseholdItem>(
                          data: currentItem,
                          feedback: Material(
                            color: Colors.transparent,
                            child: Opacity(
                              opacity: 0.85,
                              child: _ItemCard(item: currentItem, isDragging: false),
                            ),
                          ),
                          childWhenDragging: _ItemCardPlaceholder(
                              name: currentItem.name),
                          child: _ItemCard(item: currentItem, isDragging: false),
                        ),
                      ],
                    ),
            ),

            // ── "Drop into room" hint ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(children: [
                const Expanded(child: Divider(color: AppColors.outline)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Drop into a room below',
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

            // ── Rooms Grid ──────────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: rooms.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemBuilder: (context, index) {
                    final roomName = rooms[index];
                    final disabled = disabledRooms.contains(roomName);
                    final accent = _roomAccents[roomName]!;
                    final bg = _roomColors[roomName]!;
                    final icon = _roomIcons[roomName]!;

                    return Opacity(
                      opacity: disabled ? 0.3 : 1.0,
                      child: DragTarget<HouseholdItem>(
                        onWillAcceptWithDetails: (details) =>
                            !disabled && !gameComplete,
                        onAcceptWithDetails: (details) {
                          final item = details.data;
                          if (item.correctRoom == roomName) {
                            _onCorrect();
                          } else {
                            _onWrong(roomName);
                          }
                        },
                        builder: (context, candidateData, rejectedData) {
                          final isHovering = candidateData.isNotEmpty;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            decoration: BoxDecoration(
                              color: isHovering
                                  ? accent.withAlpha(30)
                                  : bg,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isHovering
                                    ? accent
                                    : accent.withAlpha(80),
                                width: isHovering ? 2.5 : 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isHovering
                                      ? accent.withAlpha(60)
                                      : Colors.black.withAlpha(15),
                                  blurRadius: isHovering ? 16 : 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(icon,
                                    color: accent,
                                    size: isHovering ? 40 : 34),
                                const SizedBox(height: 8),
                                Text(
                                  roomName,
                                  style: GoogleFonts.baloo2(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: accent,
                                  ),
                                ),
                                if (disabled) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Not here!',
                                    style: GoogleFonts.baloo2(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red.withAlpha(180),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
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
// _ItemCard – the draggable card widget
// ──────────────────────────────────────────────────────────────────────────────

class _ItemCard extends StatelessWidget {
  const _ItemCard({required this.item, required this.isDragging});
  final HouseholdItem item;
  final bool isDragging;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.secondary, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(40),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(item.emoji, style: const TextStyle(fontSize: 70)),
          const SizedBox(height: 6),
          Text(
            item.name,
            textAlign: TextAlign.center,
            style: GoogleFonts.baloo2(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// _ItemCardPlaceholder – shown in place of the dragged card
// ──────────────────────────────────────────────────────────────────────────────

class _ItemCardPlaceholder extends StatelessWidget {
  const _ItemCardPlaceholder({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.secondary.withAlpha(100),
          width: 2,
          // Dashed border approximation via short segments around the edge
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 30),
          Icon(Icons.drag_indicator_rounded,
              color: AppColors.secondary.withAlpha(120), size: 36),
          const SizedBox(height: 6),
          Text(
            name,
            textAlign: TextAlign.center,
            style: GoogleFonts.baloo2(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary.withAlpha(80),
            ),
          ),
          const SizedBox(height: 10),
        ],
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
