
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color background = Color(0xFFFFF8F8);
  static const Color textColor = Color(0xFF604A50);
  static const Color pink = Color(0xFFD88FA5);
  static const Color mutedText = Color(0xFF9B838B);

  // Dane przykładowe — później pobierzemy je z backendu.
  static const List<Map<String, dynamic>> activities = [
    {
      'name': 'Spacer po parku',
      'date': 'Dzisiaj, 16:30',
      'icon': Icons.park_outlined,
      'change': 2,
      'color': Color(0xFFE9F2E5),
      'iconColor': Color(0xFF729477),
    },
    {
      'name': 'Czytanie książki',
      'date': 'Wczoraj, 19:00',
      'icon': Icons.menu_book_outlined,
      'change': 1,
      'color': Color(0xFFFBE9DC),
      'iconColor': Color(0xFFC68F6F),
    },
    {
      'name': 'Spotkanie z przyjaciółmi',
      'date': '23 października',
      'icon': Icons.people_outline,
      'change': 1,
      'color': Color(0xFFF6E4ED),
      'iconColor': Color(0xFFB97D9B),
    },
  ];

  Widget _activityTile(Map<String, dynamic> activity) {
    final change = activity['change'] as int;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: activity['color'] as Color,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              activity['icon'] as IconData,
              color: activity['iconColor'] as Color,
              size: 23,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['name'] as String,
                  style: const TextStyle(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity['date'] as String,
                  style: const TextStyle(
                    color: mutedText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            change > 0 ? '+$change' : '$change',
            style: const TextStyle(
              color: Color(0xFF729477),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
          children: [
            const Text(
              'Cześć!',
              style: TextStyle(
                fontSize: 29,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFFF3E3E9),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ostatnie aktywności',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (int i = 0; i < activities.length; i++) ...[
                    _activityTile(activities[i]),
                    if (i < activities.length - 1)
                      const Divider(
                        height: 1,
                        color: Color(0xFFF5ECEF),
                      ),
                  ],
                  const SizedBox(height: 12),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Historia aktywności',
                      style: TextStyle(
                        color: pink,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
