import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:loginpage/mealplan/Screens/meal_screen.dart';

class CalorieChart extends StatefulWidget {
  final Map<String, double> weeklyCalorieData;
  const CalorieChart(this.weeklyCalorieData, {super.key});

  @override
  State<CalorieChart> createState() => _CalorieChartState();
}

class _CalorieChartState extends State<CalorieChart> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<FlSpot> lineChartData = [];
    final List<String> weekDays = generateWeekDays();

    for (int i = 0; i < weekDays.length; i++) {
      String day = weekDays[i];
      double calorie = widget.weeklyCalorieData[day] ?? 0.0;
      lineChartData.add(FlSpot(i.toDouble(), calorie));
    }

    return SafeArea(
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            MealPlanScreen(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 400,
                    child: LineChart(LineChartData(
                      backgroundColor: Colors.black,
                      minY: 0,
                      maxY: lineChartData.isNotEmpty
                          ? lineChartData
                                  .map((data) => data.y)
                                  .reduce((a, b) => a > b ? a : b) *
                              1.2
                          : 10000,
                      lineBarsData: [
                        LineChartBarData(
                          spots: lineChartData,
                          isCurved: true,
                          barWidth: 3,
                          color: lineChartData.any((data) => data.y > 1800)
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
                              if (index < 0 || index >= weekDays.length) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Text(
                                  weekDays[index],
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
                        border: Border.all(
                            color: const Color(0xff37434d), width: 1),
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
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.local_pizza),
              label: 'Meals',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Calorie Chart',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  List<String> generateWeekDays() {
    final DateFormat formatter = DateFormat('EEE');
    DateTime today = DateTime.now();
    List<String> weekDays = List.generate(
        7, (index) => formatter.format(today.subtract(Duration(days: index))));
    return weekDays.reversed.toList();
  }
}
