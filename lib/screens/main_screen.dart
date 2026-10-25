
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
  int _selectedIndex = 0;
  bool _showHome = true;
  bool _showSettings = false;

  static const Color pink = Color(0xFFE6A0AA);
  static const Color orange = Color(0xFFF3A078);
  static const Color background = Color(0xFFFFF8F5);
  static const Color textColor = Color(0xFF604A50);

  final List<Widget> _screens = [
    const ListScreen(),
    const HistoryScreen(),
    const AddActivityScreen(),
    const StatisticsScreen(),
    const RecommendationsScreen(),
  ];

  void _openTab(int index) {
    setState(() {
      _selectedIndex = index;
      _showHome = false;
      _showSettings = false;
    });
  }

  String get _title {
    if (_showSettings) return 'Ustawienia';
    if (_showHome) return 'Ekran główny';

    switch (_selectedIndex) {
      case 0:
        return 'Lista aktywności';
      case 1:
        return 'Historia';
      case 2:
        return 'Dodaj aktywność';
      case 3:
        return 'Statystyki';
      case 4:
        return 'Dla Ciebie';
      default:
        return 'Ekran główny';
    }
  }

  Widget _navButton({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final selected = !_showHome &&
        !_showSettings &&
        _selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => _openTab(index),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 23,
                color: selected ? orange : pink,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: selected
                      ? FontWeight.bold
                      : FontWeight.w500,
                  color: selected ? orange : textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _title,
          style: const TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.home_rounded,
            color: textColor,
          ),
          onPressed: () {
            setState(() {
              _showHome = true;
              _showSettings = false;
            });
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: textColor,
            ),
            onPressed: () {
              setState(() {
                _showSettings = true;
                _showHome = false;
              });
            },
          ),
        ],
      ),

      body: _showSettings
          ? const SettingsScreen()
          : _showHome
              ? const HomeScreen()
              : _screens[_selectedIndex],

      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,

      floatingActionButton: Container(
        width: 66,
        height: 66,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: orange,
          boxShadow: [
            BoxShadow(
              color: orange.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: IconButton(
          onPressed: () => _openTab(2),
          icon: const Icon(
            Icons.add_rounded,
            color: Colors.white,
            size: 36,
          ),
          tooltip: 'Dodaj aktywność',
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 0,
        height: 78,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            _navButton(
              icon: Icons.list_alt_rounded,
              label: 'Lista',
              index: 0,
            ),
            _navButton(
              icon: Icons.history_rounded,
              label: 'Historia',
              index: 1,
            ),

            const SizedBox(width: 72),

            _navButton(
              icon: Icons.bar_chart_rounded,
              label: 'Statystyki',
              index: 3,
            ),
            _navButton(
              icon: Icons.auto_awesome_rounded,
              label: 'Dla Ciebie',
              index: 4,
            ),
          ],
        ),
      ),
    );
  }
}
