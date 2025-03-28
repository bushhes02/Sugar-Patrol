import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> logs = [];
  List<Map<String, dynamic>> sortedLogs = []; // Sorted list for display
  double dailySugarLimit = 50.0;

  // Sorting option
  String _sortOption = 'Low to High'; // Default sort: low to high
  final List<String> _sortOptions = ['Low to High', 'High to Low'];

  static const Color darkGreen = Color(0xFF2E8B57);

  // Text controllers for the dialog inputs
  final TextEditingController _foodController = TextEditingController();
  final TextEditingController _sugarController = TextEditingController();

  // Total sugar intake for today
  double get totalSugarIntake {
    DateTime today = DateTime.now();
    return logs
        .where((log) {
          DateTime logDate = DateTime.parse(log['timestamp']);
          return logDate.year == today.year &&
              logDate.month == today.month &&
              logDate.day == today.day;
        })
        .fold(0, (sum, log) => sum + (log['sugar'] as num).toDouble());
  }

  @override
  void initState() {
    super.initState();
    _loadLogs();
    _loadSugarLimit();
  }

  Future<void> _loadLogs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedLogs = prefs.getStringList('foodLogs');
    if (savedLogs != null) {
      setState(() {
        logs = savedLogs
            .map((log) => jsonDecode(log) as Map<String, dynamic>)
            .toList();
        _applySort(); // Sort the logs after loading
      });
    }
  }

  Future<void> _loadSugarLimit() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      dailySugarLimit = prefs.getDouble('dailySugarLimit') ?? 50.0;
    });
  }

  Future<void> _saveLogs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> logsToSave = logs.map((log) => jsonEncode(log)).toList();
    await prefs.setStringList('foodLogs', logsToSave);
  }

  // Apply sorting to today's logs
  void _applySort() {
    // Filter logs to show today's logs
    DateTime today = DateTime.now();
    sortedLogs = logs.where((log) {
      DateTime logDate = DateTime.parse(log['timestamp']);
      return logDate.year == today.year &&
          logDate.month == today.month &&
          logDate.day == today.day;
    }).toList();

    // Sort based on the selected option
    if (_sortOption == 'Low to High') {
      sortedLogs.sort((a, b) => (a['sugar'] as num).compareTo(b['sugar'] as num));
    } else {
      sortedLogs.sort((a, b) => (b['sugar'] as num).compareTo(a['sugar'] as num));
    }
  }

  // Add a new log entry via dialog
  void addLogEntry(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Log Entry"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _foodController,
                decoration: const InputDecoration(
                  labelText: "Food Item",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _sugarController,
                decoration: const InputDecoration(
                  labelText: "Sugar Level (g)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_foodController.text.isNotEmpty &&
                    _sugarController.text.isNotEmpty) {
                  double? sugarAmount = double.tryParse(_sugarController.text);
                  if (sugarAmount == null || sugarAmount <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid sugar amount greater than 0')),
                    );
                    return;
                  }
                  setState(() {
                    logs.add({
                      "food": _foodController.text,
                      "sugar": sugarAmount,
                      "timestamp": DateTime.now().toIso8601String(),
                    });
                    _applySort(); // Re-sort after adding a new log
                  });
                  _saveLogs();
                  _foodController.clear();
                  _sugarController.clear();
                  Navigator.pop(context); // Close dialog
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter both food name and sugar amount')),
                  );
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  // Remove a log entry
  void removeLogEntry(int index) {
    setState(() {
      logs.removeAt(index);
      _applySort(); // Re-sort after removing a log
      _saveLogs();
    });
  }

  @override
  void dispose() {
    _foodController.dispose();
    _sugarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the user has exceeded the daily sugar limit
    bool hasExceededLimit = totalSugarIntake > dailySugarLimit;
    String limitMessage = hasExceededLimit
        ? "You’ve exceeded your daily sugar limit! Try to cut back tomorrow."
        : "You’re within your daily sugar limit. Keep it up!";

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Radial Tracker
              SizedBox(
                height: 250,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.surface, 
                      ),
                    ),
                    SizedBox(
                      height: 180,
                      width: 180,
                      child: CircularProgressIndicator(
                        value: totalSugarIntake / 100, 
                        strokeWidth: 14,
                        backgroundColor: Theme.of(context).colorScheme.onSurface.withAlpha((0.2 * 255).round()),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          hasExceededLimit
                              ? Theme.of(context).colorScheme.error // Red if exceeded
                              : darkGreen, // Dark Green if within limit
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${totalSugarIntake.toStringAsFixed(0)}g",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Today’s\nSugar Intake",
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Daily Sugar Limit Card
              Card(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Daily Sugar Limit: ${dailySugarLimit.toStringAsFixed(0)}g",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        limitMessage,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: hasExceededLimit
                                  ? Theme.of(context).colorScheme.error 
                                  : darkGreen, 
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Log List Card (with header and sorting inside)
              Expanded(
                child: Card(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Today’s Logs",
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              // Sorting Dropdown
                              Row(
                                children: [
                                  const Text(
                                    'Sort by: ',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  DropdownButton<String>(
                                    value: _sortOption,
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        setState(() {
                                          _sortOption = newValue;
                                          _applySort();
                                        });
                                      }
                                    },
                                    items: _sortOptions.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: sortedLogs.isEmpty
                              ? Center(
                                  child: Text(
                                    "No logs yet. Add an entry!",
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                )
                              : Scrollbar(
                                  thumbVisibility: true,
                                  thickness: 6,
                                  radius: const Radius.circular(10),
                                  trackVisibility: true,
                                  child: ListView.builder(
                                    itemCount: sortedLogs.length,
                                    itemBuilder: (context, index) {
                                      final log = sortedLogs[index];
                                      return Dismissible(
                                        key: Key(log["food"] + index.toString()),
                                        direction: DismissDirection.endToStart,
                                        onDismissed: (direction) {
                                          removeLogEntry(logs.indexOf(log));
                                        },
                                        background: Container(
                                          color: Theme.of(context).colorScheme.error,
                                          alignment: Alignment.centerRight,
                                          padding: const EdgeInsets.only(right: 16.0),
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        ),
                                        child: ListTile(
                                          contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, 
                                            vertical: 0,
                                          ),
                                          title: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 16.0), 
                                                child: Text(
                                                  log["food"],
                                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    "${log["sugar"]}g",
                                                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                                          fontWeight: FontWeight.bold,
                                                          color: Theme.of(context).colorScheme.primary,
                                                        ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color: Theme.of(context).colorScheme.error,
                                                    ),
                                                    onPressed: () => removeLogEntry(logs.indexOf(log)),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
        child: FloatingActionButton(
          onPressed: () => addLogEntry(context),
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
