
import 'package:flutter/material.dart';
import 'history_screen.dart';
import 'add_activity_screen.dart';
import 'statistics_screen.dart';
import 'recommendations_screen.dart';
import 'home_screen.dart';
import 'list_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // to remember the selected index of the bottom navigation bar
  int _selectedIndex = 0;

  // is the main screen displayed now NIE ROZUMIEM TEGO MECHANIZMU MAIN SCREEN
  // ROZUMIEM JAK DZIALA ALE DLACZEGO W TAKI SPOSOB????
  bool _showHome = true;
  bool _showSettings = false;
  

  //List of screen
  final List<Widget> _screens = [
    const ListScreen(),
    const HistoryScreen(),
    const AddActivityScreen(),
    const StatisticsScreen(),
    const RecommendationsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // the TOP of the screen
      appBar: AppBar(
        title: _selectedIndex == 1
            ? const Text('Historia aktywności')
            : const Text('Strona główna'),


        // LEFT SIDE
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            // TEGO NIE ROZUMIEM
            setState(
              () {
                _showHome = true;
                _showSettings = false;
              });
          },
        ),


        // RIGHT SIDE
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              setState(() {
                _showSettings = true;
              });
            },
          ),
        ],
      ),


      // the main content of the screen
      body: _showSettings
    ? const SettingsScreen()
    : _showHome
        ? const HomeScreen()
        : _screens[_selectedIndex],
  


      // NAVIGATION BAR- bottom
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
            _showHome = false;
            _showSettings = false;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.list),
            label: 'List',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.add),
            label: 'Add Activity',
          ),
          NavigationDestination(
            icon: Icon(Icons.area_chart),
            label: 'Statistics',
          ),
          NavigationDestination(
            icon: Icon(Icons.star),
            label: 'Get recommendations',
          ),
        ],
      ),
    );
  }
}
