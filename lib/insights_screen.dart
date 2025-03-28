import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';

//InsightsScreen widget to displauy sugar consumption insights
class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  InsightsScreenState createState() => InsightsScreenState();
}

//State class for InsightsScreen to manage insight data
class InsightsScreenState extends State<InsightsScreen> {
  List<Map<String, dynamic>> foodLogs = [];
  List<double> weeklySugar = List.filled(7, 0.0);
  double weeklyAverage = 0.0;
  int daysExceededLimit = 0;
  double dailySugarLimit = 50.0;
  Map<String, dynamic>? sugarHeroToday;
  Map<String, dynamic>? sugarVillainToday;

  @override
  void initState() {
    super.initState();
    _loadFoodLogs();
    _loadSugarLimit();
  }

  // Loads food logs from SharedPreferences
  Future<void> _loadFoodLogs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? logs = prefs.getStringList('foodLogs');

    if (logs != null) {
      setState(() {
        foodLogs = logs.map((log) => jsonDecode(log) as Map<String, dynamic>).toList();
        _calculateInsights();
      });
    }
  }

  // Loads the daily sugar limit from SharedPreferences
  Future<void> _loadSugarLimit() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      dailySugarLimit = prefs.getDouble('dailySugarLimit') ?? 50.0;
    });
  }

  // Calculates insights based on loaded food logs
  void _calculateInsights() {
    weeklySugar = List.filled(7, 0.0);
    daysExceededLimit = 0;
    sugarHeroToday = null;
    sugarVillainToday = null;
    int daysWithData = 0;
    double totalSugar = 0.0;

    DateTime now = DateTime.now();
    DateTime startOfPeriod = now.subtract(const Duration(days: 6));

    for (var log in foodLogs) {
      DateTime logDate = DateTime.parse(log['timestamp']);
      if (logDate.isAfter(startOfPeriod.subtract(const Duration(days: 1))) &&
          logDate.isBefore(now.add(const Duration(days: 1)))) {
        int dayIndex = logDate.difference(startOfPeriod).inDays;
        if (dayIndex >= 0 && dayIndex < 7) {
          double sugar = (log['sugar'] as num).toDouble();
          weeklySugar[dayIndex] += sugar;
          totalSugar += sugar;
          if (weeklySugar[dayIndex] == sugar) {
            daysWithData++;
          }
        }
      }
      if (logDate.year == now.year &&
          logDate.month == now.month &&
          logDate.day == now.day) {
        double sugar = (log['sugar'] as num).toDouble();
        if (sugarHeroToday == null || sugarVillainToday == null) {
          sugarHeroToday = log;
          sugarVillainToday = log;
        } else {
          if (sugar < (sugarHeroToday!['sugar'] as num)) {
            sugarHeroToday = log;
          }
          if (sugar > (sugarVillainToday!['sugar'] as num)) {
            sugarVillainToday = log;
          }
        }
      }
    }

    weeklyAverage = daysWithData > 0 ? totalSugar / daysWithData : 0.0;
    for (int i = 0; i < weeklySugar.length; i++) {
      if (weeklySugar[i] > dailySugarLimit) {
        daysExceededLimit++;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights'),
      ),
      body: foodLogs.isEmpty
          ? const Center(
              child: Text(
                'No food logs yet. Start logging food to see insights!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: ListTile(
                        title: const Text('Weekly Average Sugar Consumption'),
                        subtitle: Text(
                          '${weeklyAverage.toStringAsFixed(1)}g per day',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: ListTile(
                        title: const Text('Days Exceeded Daily Limit'),
                        subtitle: Text(
                          '$daysExceededLimit/7',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: ListTile(
                        title: const Text('Sugar Hero (Lowest Sugar Today)'),
                        subtitle: Text(
                          sugarHeroToday == null
                              ? 'No logs for today'
                              : '${sugarHeroToday!['food']}, ${(sugarHeroToday!['sugar'] as num).toStringAsFixed(1)}g',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: ListTile(
                        title: const Text('Sugar Villain (Highest Sugar Today)'),
                        subtitle: Text(
                          sugarVillainToday == null
                              ? 'No logs for today'
                              : '${sugarVillainToday!['food']}, ${(sugarVillainToday!['sugar'] as num).toStringAsFixed(1)}g',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Weekly Sugar Consumption',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 300,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: (weeklySugar.reduce((a, b) => a > b ? a : b) + 10).toDouble(),
                          barTouchData: BarTouchData(enabled: false),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  DateTime now = DateTime.now();
                                  DateTime startOfPeriod = now.subtract(const Duration(days: 6));
                                  DateTime barDate = startOfPeriod.add(Duration(days: value.toInt()));
                                  return Text(
                                    '${barDate.day}/${barDate.month}',
                                    style: const TextStyle(fontSize: 12),
                                  );
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) => Text(
                                  '${value.toInt()}g',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: List.generate(7, (index) {
                            return BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: weeklySugar[index],
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 20,
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }
}

