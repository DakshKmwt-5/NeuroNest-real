import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuronest/theme/app_theme.dart';

/// Activity tab content showing patient activity logs and expandable trend charts.
class ActivityTabContent extends StatefulWidget {
  const ActivityTabContent({super.key});

  @override
  State<ActivityTabContent> createState() => _ActivityTabContentState();
}

class _ActivityTabContentState extends State<ActivityTabContent> {
  static const List<Map<String, dynamic>> _mockActivities = [
    {
      'name': 'Memory Match',
      'score': '95/100',
      'timeTaken': '5m 30s',
      'streak': '3 Day Streak',
      'change': '+5% from last',
      'scores': [80.0, 85.0, 88.0, 92.0, 90.0, 93.0, 95.0],
      'times': [7.0, 6.5, 6.0, 5.8, 5.5, 5.4, 5.5],
      'avgScore': 89.0,
      'avgTime': 6.1,
    },
    {
      'name': 'Pattern Sequence',
      'score': '88/100',
      'timeTaken': '4m 15s',
      'streak': '5 Day Streak',
      'change': '+2% from last',
      'scores': [75.0, 80.0, 82.0, 85.0, 86.0, 87.0, 88.0],
      'times': [6.0, 5.5, 5.2, 4.8, 4.5, 4.3, 4.25],
      'avgScore': 83.3,
      'avgTime': 4.95,
    },
    {
      'name': 'Word Recall',
      'score': '92/100',
      'timeTaken': '6m 10s',
      'streak': '2 Day Streak',
      'change': '+8% from last',
      'scores': [70.0, 78.0, 82.0, 85.0, 89.0, 90.0, 92.0],
      'times': [8.0, 7.5, 7.0, 6.8, 6.5, 6.2, 6.16],
      'avgScore': 83.7,
      'avgTime': 6.88,
    },
    {
      'name': 'Spatial Puzzle',
      'score': '79/100',
      'timeTaken': '7m 45s',
      'streak': '1 Day Streak',
      'change': '-3% from last',
      'scores': [82.0, 80.0, 81.0, 83.0, 81.0, 82.0, 79.0],
      'times': [6.5, 6.8, 7.0, 7.2, 7.1, 7.3, 7.75],
      'avgScore': 81.1,
      'avgTime': 7.09,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      itemCount: _mockActivities.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Patient Activity Log',
                  style: GoogleFonts.baloo2(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                  ),
                ),
                Text(
                  'Tap any card to view detailed 7-day trends.',
                  style: GoogleFonts.baloo2(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }
        final activity = _mockActivities[index - 1];
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: ActivityCard(activity: activity),
        );
      },
    );
  }
}

/// Custom expandable activity card.
class ActivityCard extends StatefulWidget {
  const ActivityCard({super.key, required this.activity});

  final Map<String, dynamic> activity;

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final name = widget.activity['name'] as String;
    final score = widget.activity['score'] as String;
    final timeTaken = widget.activity['timeTaken'] as String;
    final streak = widget.activity['streak'] as String;
    final change = widget.activity['change'] as String;

    final scores = List<double>.from(widget.activity['scores']);
    final times = List<double>.from(widget.activity['times']);
    final avgScore = (widget.activity['avgScore'] as num).toDouble();
    final avgTime = (widget.activity['avgTime'] as num).toDouble();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 14,
            offset: const Offset(0, 4),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Default View ──
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Top Row
                  Row(
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.baloo2(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        score,
                        style: GoogleFonts.baloo2(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          _isExpanded
                              ? Icons.expand_less_rounded
                              : Icons.expand_more_rounded,
                          color: AppColors.text,
                        ),
                        onPressed: () {
                          setState(() => _isExpanded = !_isExpanded);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Bottom Row
                  Row(
                    children: [
                      Text(
                        '$timeTaken  |  $streak  |  $change',
                        style: GoogleFonts.baloo2(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Expanded View (Trend Charts) ──
          if (_isExpanded) ...[
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: 350,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Score Trend Chart
                      Text(
                        'Score Trend (7 Days)',
                        style: GoogleFonts.baloo2(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 120,
                        child: _buildBarChart(
                          data: scores,
                          avgValue: avgScore,
                          barColor: AppColors.primary,
                          maxY: 100,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Response Time Trend Chart
                      Text(
                        'Response Time Trend (Minutes)',
                        style: GoogleFonts.baloo2(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 120,
                        child: _buildBarChart(
                          data: times,
                          avgValue: avgTime,
                          barColor: AppColors.secondary,
                          maxY: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBarChart({
    required List<double> data,
    required double avgValue,
    required Color barColor,
    required double maxY,
  }) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => Text(
                'D${value.toInt()}',
                style: const TextStyle(fontSize: 10, color: Color(0xFF181818)),
              ),
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(color: Color(0xFF181818), width: 1),
          ),
        ),
        extraLinesData: ExtraLinesData(
          extraLinesOnTop: true,
          horizontalLines: [
            HorizontalLine(
              y: avgValue,
              color: AppColors.text, // Primary Text #22453E
              strokeWidth: 1.5,
              dashArray: [5, 5],
              label: HorizontalLineLabel(
                show: true,
                alignment: Alignment.topRight,
                style: GoogleFonts.baloo2(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
                labelResolver: (line) => 'Avg: ${line.y.toStringAsFixed(1)}',
              ),
            ),
          ],
        ),
        barGroups: List.generate(
          data.length,
          (i) => BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: data[i],
                color: barColor,
                width: 16,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
