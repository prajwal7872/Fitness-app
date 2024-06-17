import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:loginpage/screens/health_services.dart';




// Widget to display the health data in a bar chart
class HealthDataPage extends StatefulWidget {
  const HealthDataPage({super.key});

  @override
  State<HealthDataPage> createState() => _HealthDataPageState();
}

class _HealthDataPageState extends State<HealthDataPage> {
  final List<BarChartGroupData> _barChartData = [];
  bool _isLoading = true;
  final List<String> _weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
    fetchAndDisplayWeeklyCalorieData();
  }

  Future<void> fetchAndDisplayWeeklyCalorieData() async {
    final weeklyCalorie = await fetchWeeklyCalorieData();
    print('Weekly Calorie Data: $weeklyCalorie');
    if (!mounted) return; 

    setState(() {
      _barChartData.clear();
      int index = 0;
      _weekDays.forEach((day) {
        double calorie = weeklyCalorie[day] ?? 0.0;
        _barChartData.add(
          BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: calorie,
                color: Colors.blue,
              ),
            ],
            barsSpace: 4,
          ),
        );
        index++;
      });
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
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: _barChartData.isNotEmpty
                        ? _barChartData
                                .map((data) => data.barRods[0].toY)
                                .reduce((a, b) => a > b ? a : b) *
                            1.2
                        : 10000,
                    barGroups: _barChartData,
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: 1000,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                value.toInt().toString(),
                                style: const TextStyle(color: Colors.black, fontSize: 10),
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            return Text(
                              _weekDays[value.toInt()],
                              style: const TextStyle(color: Colors.black, fontSize: 10),
                            );
                          },
                        ),
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
                      border: Border.all(color: const Color(0xff37434d), width: 1),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
