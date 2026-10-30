import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../Domain models/bp_reading_model.dart';

class BloodPressureChart extends StatelessWidget {
  final List<BPReading> readings;

  const BloodPressureChart({super.key, required this.readings});

  @override
  Widget build(BuildContext context) {
    if (readings.isEmpty) {
      return const Center(child: Text("No blood pressure data available."));
    }

    return AspectRatio(
      aspectRatio: 1.7,
      child: Padding(
        padding: const EdgeInsets.only(right: 18, left: 12, top: 24, bottom: 12),
        child: LineChart(
          LineChartData(
            // Enable touch tooltips
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    final isSystolic = spot.barIndex == 0;
                    final label = isSystolic ? 'Systolic' : 'Diastolic';
                    return LineTooltipItem(
                      '$label: ${spot.y.toInt()} mmHg',
                      TextStyle(
                        color: spot.bar.color,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              horizontalInterval: 20,
              getDrawingHorizontalLine: (value) => FlLine(
                color: Colors.grey.withValues(alpha: 0.2),
                strokeWidth: 1,
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              
              // Left Axis: Pressure Values (mmHg)
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 30,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '${value.toInt()}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    );
                  },
                ),
              ),

              // Bottom Axis: Sequence index or day label
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index >= 0 && index < readings.length) {
                      final date = readings[index].timeStamp;
                      return Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Text('${date.day}/${date.month}'),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
            ),
            minY: 40,   // Minimum diastolic range
            maxY: 200,  // Maximum systolic range
            
            // Dual Line Configuration
            lineBarsData: [
              // 1. Systolic Line (Red/Pink)
              LineChartBarData(
                spots: readings.asMap().entries.map((e) {
                  return FlSpot(e.key.toDouble(), e.value.systolic);
                }).toList(),
                isCurved: true,
                color: Colors.redAccent,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.redAccent.withValues(alpha: 0.1),
                ),
              ),

              // 2. Diastolic Line (Blue)
              LineChartBarData(
                spots: readings.asMap().entries.map((e) {
                  return FlSpot(e.key.toDouble(), e.value.diastolic);
                }).toList(),
                isCurved: true,
                color: Colors.blueAccent,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.blueAccent.withValues(alpha: 0.1),
                ),
              ),
            ],

            // Target baseline (e.g., 120 mmHg standard upper reference line)
            extraLinesData: ExtraLinesData(
              horizontalLines: [
                HorizontalLine(
                  y: 120,
                  color: Colors.green.withValues(alpha: 0.5),
                  strokeWidth: 1.5,
                  dashArray: [5, 5],
                  label: HorizontalLineLabel(
                    show: true,
                    alignment: Alignment.topRight,
                    style: const TextStyle(color: Colors.green, fontSize: 10),
                    labelResolver: (_) => 'Standard Systolic (120)',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}