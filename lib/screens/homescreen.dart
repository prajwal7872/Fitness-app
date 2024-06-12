import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:health/health.dart';
import 'package:loginpage/screens/health_services.dart';

class HealthDataPage extends StatefulWidget {
  const HealthDataPage({super.key});

  @override
  State<HealthDataPage> createState() => _HealthDataPageState();
}

class _HealthDataPageState extends State<HealthDataPage> {
  List<BarChartGroupData> _barChartData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // fetchStepData();
    fetchWeeklyStepData();
    _isLoading = false;
  }

  double _convertToDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    } else {
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Energy Burned'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 400,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 3000,
                    barGroups: _barChartData,
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 10),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            final day = DateTime.now()
                                .subtract(Duration(days: value.toInt()));
                            return Text(
                              "${day.month}/${day.day}",
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 10),
                            );
                          },
                        ),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawHorizontalLine: true,
                      drawVerticalLine: false,
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border:
                          Border.all(color: const Color(0xff37434d), width: 1),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
