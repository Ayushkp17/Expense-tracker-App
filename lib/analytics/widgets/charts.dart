import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../expenses/providers/expense_provider.dart';
import '../../core/theme.dart';

class CategoryPieChart extends ConsumerStatefulWidget {
  const CategoryPieChart({super.key});

  @override
  ConsumerState<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends ConsumerState<CategoryPieChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final categoryTotals = ref.watch(categoryTotalsProvider);
    final total = ref.watch(totalMonthlySpendProvider);

    if (categoryTotals.isEmpty) {
      return _buildEmpty(context);
    }

    final sortedEntries = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final sections = sortedEntries.asMap().entries.map((entry) {
      final idx = entry.key;
      final cat = entry.value.key;
      final value = entry.value.value;
      final color = CategoryColors.forCategory(cat);
      final isTouched = idx == _touchedIndex;
      final pct = total > 0 ? (value / total * 100) : 0;

      return PieChartSectionData(
        value: value,
        color: color,
        radius: isTouched ? 72 : 60,
        title: isTouched ? '${pct.toStringAsFixed(1)}%' : '',
        titleStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        badgeWidget: isTouched
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.5),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  cat,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : null,
        badgePositionPercentageOffset: 1.4,
      );
    }).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'By Category',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 220,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  pieTouchData: PieTouchData(
                    touchCallback: (event, response) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            response == null ||
                            response.touchedSection == null) {
                          _touchedIndex = -1;
                          return;
                        }
                        _touchedIndex =
                            response.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 3,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: sortedEntries.take(6).map((entry) {
                final color = CategoryColors.forCategory(entry.key);
                final pct = total > 0 ? entry.value / total * 100 : 0;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${entry.key} ${pct.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.pie_chart_outline_rounded,
                size: 48,
                color: Colors.white.withValues(alpha: 0.2),
              ),
              const SizedBox(height: 12),
              Text(
                'No data for this month',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DailyBarChart extends ConsumerWidget {
  const DailyBarChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyTotals = ref.watch(dailyTotalsProvider);
    final selectedMonth = ref.watch(selectedMonthProvider);

    if (dailyTotals.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.bar_chart_rounded,
                  size: 48,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                const SizedBox(height: 12),
                Text(
                  'No data for this month',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final maxVal = dailyTotals.values.isEmpty
        ? 1.0
        : dailyTotals.values.reduce((a, b) => a > b ? a : b);

    final daysInMonth = DateUtils.getDaysInMonth(
      selectedMonth.year,
      selectedMonth.month,
    );

    final barGroups = List.generate(daysInMonth, (idx) {
      final day = idx + 1;
      final val = dailyTotals[day] ?? 0.0;
      return BarChartGroupData(
        x: day,
        barRods: [
          BarChartRodData(
            toY: val,
            color: val > 0
                ? Theme.of(context).colorScheme.primary
                : const Color(0xFF2A2A4A),
            width: 8,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            gradient: val > 0
                ? LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  )
                : null,
          ),
        ],
      );
    });

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Spending',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  maxY: maxVal * 1.3,
                  barGroups: barGroups,
                  gridData: FlGridData(
                    show: true,
                    getDrawingHorizontalLine: (_) =>
                        const FlLine(color: Color(0xFF2A2A4A), strokeWidth: 1),
                    drawVerticalLine: false,
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() % 5 != 0) {
                            return const SizedBox.shrink();
                          }
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                          );
                        },
                        reservedSize: 24,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value == 0) return const SizedBox.shrink();
                          return Text(
                            '₹${NumberFormat.compact().format(value)}',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                          );
                        },
                        reservedSize: 44,
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '₹${NumberFormat('#,##0.00').format(rod.toY)}',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                    ),
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
