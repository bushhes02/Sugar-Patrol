import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  // Mock data for log entries (food item and sugar level)
  List<Map<String, dynamic>> logs = [
    {"food": "Apple", "sugar": 19},
    {"food": "Soda", "sugar": 39},
    {"food": "Yogurt", "sugar": 12},
    {"food": "Candy", "sugar": 25},
  ];

  // Mock total sugar intake for the day (sum of sugar levels)
  double get totalSugarIntake => logs.fold(0, (sum, log) => sum + log["sugar"]);

  // Daily sugar limit (in grams)
  final double dailySugarLimit = 50.0;

  // Darker green for tracker and message
  static const Color darkGreen = Color(0xFF2E8B57);

  // Text controllers for the dialog inputs
  final TextEditingController _foodController = TextEditingController();
  final TextEditingController _sugarController = TextEditingController();

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
                  setState(() {
                    logs.add({
                      "food": _foodController.text,
                      "sugar": int.parse(_sugarController.text),
                    });
                  });
                  _foodController.clear();
                  _sugarController.clear();
                  Navigator.pop(context); // Close dialog
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
                        color: Theme.of(context).colorScheme.surface, // White
                      ),
                    ),
                    SizedBox(
                      height: 180,
                      width: 180,
                      child: CircularProgressIndicator(
                        value: totalSugarIntake / 100, // Scale for visual purposes (max 100g for display)
                        strokeWidth: 14,
                        backgroundColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
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
                                  ? Theme.of(context).colorScheme.error // Red
                                  : darkGreen, // Dark Green
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Log List Card (with header inside)
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
                          child: Text(
                            "Today’s Logs",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: logs.isEmpty
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
                                    itemCount: logs.length,
                                    itemBuilder: (context, index) {
                                      final log = logs[index];
                                      return Dismissible(
                                        key: Key(log["food"] + index.toString()),
                                        direction: DismissDirection.endToStart,
                                        onDismissed: (direction) {
                                          removeLogEntry(index);
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
                                            horizontal: 16.0, // Consistent padding on both sides
                                            vertical: 0,
                                          ),
                                          title: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 16.0), // Match trash can padding
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
                                                    onPressed: () => removeLogEntry(index),
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
        padding: const EdgeInsets.only(right: 16.0, bottom: 16.0), // Move further left
        child: FloatingActionButton(
          onPressed: () => addLogEntry(context),
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
