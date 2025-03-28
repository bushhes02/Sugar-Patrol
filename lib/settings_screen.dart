import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_provider.dart';
import 'login_screen.dart';

// Defines the SettingsScreen widget as a StatefulWidget
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

// State class for SettingsScreen to manage settings-related state
class SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _sugarLimitController = TextEditingController();
  double _currentLimit = 50.0; //Default daily sugar limit in grams

  @override
  void initState() {
    super.initState();
    _loadSugarLimit(); // Load the saved sugar limit when the screen initializes
  }

  //Loads the saved daily sugar limit from Shared Preferences
  Future<void> _loadSugarLimit() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentLimit = prefs.getDouble('dailySugarLimit') ?? 50.0; // Default to 50.0 if not set
      _sugarLimitController.text = _currentLimit.toString(); // Update the text field 
    });
  }

  // Saves the new sugar limit to SharedPreferences
  Future<void> _saveSugarLimit() async {
    final prefs = await SharedPreferences.getInstance();
    double? newLimit = double.tryParse(_sugarLimitController.text); 
    if (newLimit != null && newLimit > 0) {
      setState(() {
        _currentLimit = newLimit; // Update the current limit
      });
      await prefs.setDouble('dailySugarLimit', newLimit); //Save to SharedPreferences
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Daily sugar limit updated!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number greater than 0')),
      );
    }
  }

  //Displays an "About" dialog with app information
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('About'),
          content: const Text(
            'Sugar Patrol v1.0.0\n\n'
            'A simple app to track your daily sugar intake and help you stay within your limits.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  //Displays a "Help" dialog with usage instructions
  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Help'),
          content: const Text(
            'Welcome to Sugar Patrol!\n\n'
            '- Use the Home Screen to log your daily sugar intake.\n'
            '- Check the Insights Screen to see your weekly sugar consumption and trends.\n'
            '- Set your daily sugar limit here in the Settings Screen.\n'
            '- Toggle between light and dark mode for better visibility.\n'
            '- Log out to return to the login screen.\n\n'
            'For more assistance, contact support at support@sugarpatrol.com.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Displays a confirmation dialog for logging out
  void _logOut() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _sugarLimitController.dispose(); //Clean up controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context); // Access Theme Provider for dark mode state
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // About Section
          ListTile(
            leading: Icon(
              Icons.info_outline,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            title: Text(
              'About',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            onTap: _showAboutDialog,
          ),
          Divider(
            color: isDarkMode ? Colors.grey : Colors.grey[300],
          ),
          // Appearance Section
          ListTile(
            leading: Icon(
              Icons.brightness_6,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            title: Text(
              'Appearance',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme(value); // Toggle theme on
              },
            ),
          ),
          Divider(
            color: isDarkMode ? Colors.grey : Colors.grey[300],
          ),
          // Set Daily Target Section
          ListTile(
            leading: Icon(
              Icons.track_changes,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            title: Text(
              'Set Daily Target',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _sugarLimitController,
                    decoration: InputDecoration(
                      labelText: 'Daily Sugar Limit (g)',
                      border: const OutlineInputBorder(),
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _saveSugarLimit,
                    child: const Text('Save'),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Current Limit: ${_currentLimit.toStringAsFixed(1)}g',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: isDarkMode ? Colors.grey : Colors.grey[300],
          ),
          // Help Section
          ListTile(
            leading: Icon(
              Icons.help_outline,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            title: Text(
              'Help',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            onTap: _showHelpDialog,
          ),
          Divider(
            color: isDarkMode ? Colors.grey : Colors.grey[300],
          ),
          // Log Out Section
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: const Text(
              'Log Out',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            onTap: _logOut,
          ),
        ],
      ),
    );
  }
}
