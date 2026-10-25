
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  static const Color background = Color(0xFFFFF8F8);
  static const Color textColor = Color(0xFF604A50);
  static const Color pink = Color(0xFFD88FA5);
  static const Color mutedText = Color(0xFF9B838B);

  final TextEditingController _searchController =
      TextEditingController();

  String _selectedFilter = 'Wszystkie';

  final List<Map<String, dynamic>> _activities = [
    {
      'id': 1,
      'name': 'Spacer po parku',
      'date': DateTime(2026, 10, 25, 16, 30),
      'categories': ['Ruch', 'Relaks'],
      'company': 'Samodzielnie',
      'place': 'Na zewnątrz',
      'before': 3,
      'after': 5,
      'pleasure': 5,
      'icon': Icons.park_outlined,
      'color': const Color(0xFFEAF2E6),
      'iconColor': const Color(0xFF729477),
    },
    {
      'id': 2,
      'name': 'Czytanie książki',
      'date': DateTime(2026, 10, 24, 19, 00),
      'categories': ['Relaks'],
      'company': 'Samodzielnie',
      'place': 'Wewnątrz',
      'before': 2,
      'after': 4,
      'pleasure': 5,
      'icon': Icons.menu_book_outlined,
      'color': const Color(0xFFFFEBDC),
      'iconColor': const Color(0xFFC68F6F),
    },
    {
      'id': 3,
      'name': 'Spotkanie z przyjaciółmi',
      'date': DateTime(2026, 10, 23, 17, 00),
      'categories': ['Spotkania', 'Relaks'],
      'company': 'Z innymi',
      'place': 'Wewnątrz',
      'before': 4,
      'after': 5,
      'pleasure': 5,
      'icon': Icons.people_outline,
      'color': const Color(0xFFF6E4ED),
      'iconColor': const Color(0xFFB97D9B),
    },
    {
      'id': 4,
      'name': 'Ćwiczenia fizyczne',
      'date': DateTime(2026, 10, 22, 9, 15),
      'categories': ['Ruch'],
      'company': 'Samodzielnie',
      'place': 'Wewnątrz',
      'before': 3,
      'after': 4,
      'pleasure': 4,
      'icon': Icons.fitness_center_outlined,
      'color': const Color(0xFFEAF2E6),
      'iconColor': const Color(0xFF729477),
    },
    {
      'id': 5,
      'name': 'Rysowanie',
      'date': DateTime(2026, 10, 21, 18, 00),
      'categories': ['Kreatywność'],
      'company': 'Samodzielnie',
      'place': 'Wewnątrz',
      'before': 4,
      'after': 4,
      'pleasure': 4,
      'icon': Icons.brush_outlined,
      'color': const Color(0xFFF6E4ED),
      'iconColor': const Color(0xFFB97D9B),
    },
    {
      'id': 6,
      'name': 'Gotowanie',
      'date': DateTime(2026, 10, 20, 15, 45),
      'categories': ['Kreatywność'],
      'company': 'Z innymi',
      'place': 'Wewnątrz',
      'before': 4,
      'after': 3,
      'pleasure': 3,
      'icon': Icons.restaurant_outlined,
      'color': const Color(0xFFFFEBDC),
      'iconColor': const Color(0xFFC68F6F),
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day.$month.${date.year} • $hour:$minute';
  }

  List<Map<String, dynamic>> get _filteredActivities {
    final query = _searchController.text.trim().toLowerCase();

    final result = _activities.where((activity) {
      final name = (activity['name'] as String).toLowerCase();

      final categories =
          (activity['categories'] as List<String>)
              .join(' ')
              .toLowerCase();

      final before = activity['before'] as int;
      final after = activity['after'] as int;
      final change = after - before;

      final matchesSearch =
          name.contains(query) || categories.contains(query);

      bool matchesFilter;

      switch (_selectedFilter) {
        case 'Poprawa':
          matchesFilter = change > 0;
          break;
        case 'Bez zmian':
          matchesFilter = change == 0;
          break;
        case 'Pogorszenie':
          matchesFilter = change < 0;
          break;
        default:
          matchesFilter = true;
      }

      return matchesSearch && matchesFilter;
    }).toList();

    result.sort((a, b) {
      final dateA = a['date'] as DateTime;
      final dateB = b['date'] as DateTime;
      return dateB.compareTo(dateA);
    });

    return result;
  }

  Widget _filterChip(String title) {
    final selected = _selectedFilter == title;

    return ChoiceChip(
      label: Text(title),
      selected: selected,
      showCheckmark: false,
      selectedColor: const Color(0xFFF8DDE5),
      backgroundColor: Colors.white,
      side: BorderSide(
        color: selected ? pink : const Color(0xFFF0E0E4),
      ),
      labelStyle: TextStyle(
        color: selected ? pink : textColor,
        fontWeight:
            selected ? FontWeight.w600 : FontWeight.normal,
        fontSize: 13,
      ),
      onSelected: (_) {
        setState(() {
          _selectedFilter = title;
        });
      },
    );
  }

  Widget _changeBadge(int change) {
    Color badgeBackground;
    Color badgeText;
    String label;

    if (change > 0) {
      badgeBackground = const Color(0xFFEAF2E6);
      badgeText = const Color(0xFF658A6A);
      label = '+$change';
    } else if (change < 0) {
      badgeBackground = const Color(0xFFFFE8E1);
      badgeText = const Color(0xFFBE766C);
      label = '$change';
    } else {
      badgeBackground = const Color(0xFFF2EFF1);
      badgeText = mutedText;
      label = '0';
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: badgeBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: badgeText,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _activityCard(Map<String, dynamic> activity) {
    final date = activity['date'] as DateTime;
    final categories = activity['categories'] as List<String>;
    final change =
        (activity['after'] as int) - (activity['before'] as int);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _showActivityDetails(activity),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFF2E3E7),
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: activity['color'] as Color,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  activity['icon'] as IconData,
                  color: activity['iconColor'] as Color,
                  size: 23,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity['name'] as String,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      _formatDate(date),
                      style: const TextStyle(
                        color: mutedText,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      categories.join(' • '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: pink,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Column(
                children: [
                  _changeBadge(change),
                  const SizedBox(height: 6),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: mutedText,
                    size: 19,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: mutedText,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: textColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showActivityDetails(Map<String, dynamic> activity) {
    final date = activity['date'] as DateTime;
    final categories = activity['categories'] as List<String>;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9D6DC),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  activity['name'] as String,
                  style: const TextStyle(
                    color: textColor,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  _formatDate(date),
                  style: const TextStyle(
                    color: mutedText,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      _detailRow(
                        'Kategorie',
                        categories.join(', '),
                      ),
                      _detailRow(
                        'Towarzystwo',
                        activity['company'] as String,
                      ),
                      _detailRow(
                        'Miejsce',
                        activity['place'] as String,
                      ),
                      const Divider(
                        color: Color(0xFFF3E6E9),
                      ),
                      _detailRow(
                        'Samopoczucie przed',
                        '${activity['before']}/5',
                      ),
                      _detailRow(
                        'Samopoczucie po',
                        '${activity['after']}/5',
                      ),
                      _detailRow(
                        'Przyjemność',
                        '${activity['pleasure']}/5',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(sheetContext);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Edycję podłączymy w kolejnym etapie.',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.edit_outlined,
                          size: 19,
                        ),
                        label: const Text('Edytuj'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: pink,
                          side: const BorderSide(color: pink),
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(sheetContext);
                          _confirmDelete(activity);
                        },
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          size: 19,
                        ),
                        label: const Text('Usuń'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor:
                              const Color(0xFFBE766C),
                          side: const BorderSide(
                            color: Color(0xFFE9C5BE),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(Map<String, dynamic> activity) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Usunąć wpis?'),
          content: Text(
            'Czy na pewno chcesz usunąć aktywność '
            '„${activity['name']}”?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Anuluj',
                style: TextStyle(color: mutedText),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _activities.removeWhere(
                    (item) => item['id'] == activity['id'],
                  );
                });

                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Usuń',
                style: TextStyle(
                  color: Color(0xFFBE766C),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final activities = _filteredActivities;

    return Container(
      color: background,
      child: SafeArea(
        child: Column(
          children: [
            // Wyszukiwarka i filtry
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Szukaj aktywności...',
                      hintStyle: const TextStyle(
                        color: mutedText,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: pink,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(17),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _filterChip('Wszystkie'),
                        const SizedBox(width: 7),
                        _filterChip('Poprawa'),
                        const SizedBox(width: 7),
                        _filterChip('Bez zmian'),
                        const SizedBox(width: 7),
                        _filterChip('Pogorszenie'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Lista wyników
            Expanded(
              child: activities.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              color: pink,
                              size: 42,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Brak aktywności',
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Nie znaleziono wpisów '
                              'pasujących do wybranych filtrów.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: mutedText,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        20, 6, 20, 28,
                      ),
                      itemCount: activities.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return _activityCard(
                          activities[index],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
