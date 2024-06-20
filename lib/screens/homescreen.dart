// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:loginpage/screens/health_services.dart';
import 'package:intl/intl.dart';

class HealthDataPage extends StatefulWidget {
  const HealthDataPage({super.key});

  @override
  State<HealthDataPage> createState() => _HealthDataPageState();
}

class _HealthDataPageState extends State<HealthDataPage> {
  final List<FlSpot> _lineChartData = [];
  bool _isLoading = true;
  List<String> _weekDays = [];

  @override
  void initState() {
    super.initState();
    generateWeekDays();
    fetchAndDisplayWeeklyCalorieData();
  }

  void generateWeekDays() {
    final DateFormat formatter = DateFormat('EEE');
    DateTime today = DateTime.now();
    _weekDays = List.generate(
        7, (index) => formatter.format(today.subtract(Duration(days: index))));
    _weekDays = _weekDays.reversed.toList();
  }

  Future<void> fetchAndDisplayWeeklyCalorieData() async {
    final Map<String, double> weeklyCalorie = await fetchWeeklyCalorieData();
    print('Weekly Calorie Data: $weeklyCalorie');
    if (!mounted) return;

    setState(() {
      _lineChartData.clear();
      for (int i = 0; i < _weekDays.length; i++) {
        String day = _weekDays[i];
        double calorie = weeklyCalorie[day] ?? 0.0;
        _lineChartData.add(FlSpot(i.toDouble(), calorie));
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Active Energy Burned Data'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 400,
                child: LineChart(LineChartData(
                  backgroundColor: Colors.black,
                  minY: 0,
                  maxY: _lineChartData.isNotEmpty
                      ? _lineChartData
                              .map((data) => data.y)
                              .reduce((a, b) => a > b ? a : b) *
                          1.2
                      : 10000,
                  lineBarsData: [
                    LineChartBarData(
                      spots: _lineChartData,
                      isCurved: true,
                      barWidth: 3,
                      color: _lineChartData.any((data) => data.y > 1800)
                          ? const Color.fromARGB(255, 216, 18, 18)
                          : const Color.fromARGB(255, 0, 128, 0),
                      dotData: const FlDotData(show: true),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: 500,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 10, 0, 0),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final int index = value.toInt();
                          if (index < 0 || index >= _weekDays.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              _weekDays[index],
                              style: const TextStyle(
                                color: Color.fromARGB(255, 10, 0, 0),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: const FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    drawVerticalLine: false,
                    horizontalInterval: 100,
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border:
                        Border.all(color: const Color(0xff37434d), width: 1),
                  ),
                  extraLinesData: ExtraLinesData(
                    horizontalLines: [
                      HorizontalLine(
                        y: 1800,
                        color: Colors.blue,
                        strokeWidth: 2,
                        label: HorizontalLineLabel(
                          show: true,
                          labelResolver: (line) => '1800 cal',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ),
            ),
    );
  }
}
