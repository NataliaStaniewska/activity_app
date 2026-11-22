import 'package:flutter/material.dart';

import '../models/saved_activities.dart';
import '../services/activities_api.dart';
import 'history_screen.dart';
import 'add_activity_screen.dart';
import 'statistics_screen.dart';
import 'recommendations_screen.dart';
import 'home_screen.dart';
import 'list_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
    this.activitiesApi = const ActivitiesApi(),
    this.accountEmail,
    this.onLogout,
  });

  final ActivitiesApi activitiesApi;
  final String? accountEmail;
  final Future<void> Function()? onLogout;

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

  final _savedActivities = SavedActivities();
  SavedActivity? _activitySuggestion;

  Widget _screenForTab() => switch (_selectedIndex) {
    0 => ListScreen(
      savedActivities: _savedActivities,
      onLogActivity: (activity) => _openTab(2, suggestion: activity),
    ),
    1 => HistoryScreen(api: widget.activitiesApi),
    2 => AddActivityScreen(
      api: widget.activitiesApi,
      suggestion: _activitySuggestion,
    ),
    3 => StatisticsScreen(api: widget.activitiesApi),
    _ => RecommendationsScreen(
      api: widget.activitiesApi,
      savedActivities: _savedActivities,
    ),
  };

  void _openTab(int index, {SavedActivity? suggestion}) {
    setState(() {
      _activitySuggestion = suggestion;
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
    final selected = !_showHome && !_showSettings && _selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => _openTab(index),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 23, color: selected ? orange : pink),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                  color: selected ? orange : textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addActivityButton() {
    return Expanded(
      child: Center(
        child: Tooltip(
          message: 'Dodaj aktywność',
          child: InkWell(
            onTap: () => _openTab(2),
            customBorder: const CircleBorder(),
            child: Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: orange,
              ),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
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
          style: const TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.home_rounded, color: textColor),
          onPressed: () {
            setState(() {
              _showHome = true;
              _showSettings = false;
            });
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: textColor),
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
          ? SettingsScreen(
              api: widget.activitiesApi,
              accountEmail: widget.accountEmail,
              onLogout: widget.onLogout,
            )
          : _showHome
          ? HomeScreen(
              api: widget.activitiesApi,
              onOpenHistory: () => _openTab(1),
            )
          : _screenForTab(),

      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 0,
        height: 78,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            _navButton(icon: Icons.list_alt_rounded, label: 'Lista', index: 0),
            _navButton(
              icon: Icons.history_rounded,
              label: 'Historia',
              index: 1,
            ),

            _addActivityButton(),

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
