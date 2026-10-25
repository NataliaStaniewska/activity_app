
import 'package:flutter/material.dart';

class SavedActivityItem {
  final int id;
  final String name;
  final String category;
  final String origin;
  final IconData icon;
  final Color iconBackground;

  const SavedActivityItem({
    required this.id,
    required this.name,
    required this.category,
    required this.origin,
    required this.icon,
    required this.iconBackground,
  });
}

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  static const Color background = Color(0xFFFFF8F8);
  static const Color textColor = Color(0xFF604A50);
  static const Color pink = Color(0xFFD88FA5);
  static const Color mutedText = Color(0xFF9B838B);

  final TextEditingController _searchController =
      TextEditingController();

  final TextEditingController _newActivityController =
      TextEditingController();

  bool _showAddForm = false;
  int? _deletingId;
  int _nextId = 4;

  final List<SavedActivityItem> _activities = [
    const SavedActivityItem(
      id: 1,
      name: 'Fotografia przyrodnicza',
      category: 'Kreatywność',
      origin: 'Rekomendacja',
      icon: Icons.camera_alt_outlined,
      iconBackground: Color(0xFFFBE9DC),
    ),
    const SavedActivityItem(
      id: 2,
      name: 'Joga na świeżym powietrzu',
      category: 'Ruch · Relaks',
      origin: 'Rekomendacja',
      icon: Icons.spa_outlined,
      iconBackground: Color(0xFFEAF2E6),
    ),
    const SavedActivityItem(
      id: 3,
      name: 'Nauka gry na gitarze',
      category: 'Kreatywność',
      origin: 'Dodana samodzielnie',
      icon: Icons.music_note_outlined,
      iconBackground: Color(0xFFF7E3EB),
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _newActivityController.dispose();
    super.dispose();
  }

  List<SavedActivityItem> get _filteredActivities {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      return _activities;
    }

    return _activities.where((activity) {
      return activity.name.toLowerCase().contains(query) ||
          activity.category.toLowerCase().contains(query);
    }).toList();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: textColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addActivity() {
    final name = _newActivityController.text.trim();

    if (name.isEmpty) {
      _showMessage('Wpisz nazwę aktywności');
      return;
    }

    final alreadyExists = _activities.any(
      (activity) =>
          activity.name.toLowerCase() == name.toLowerCase(),
    );

    if (alreadyExists) {
      _showMessage('Ta aktywność jest już na liście');
      return;
    }

    setState(() {
      _activities.add(
        SavedActivityItem(
          id: _nextId++,
          name: name,
          category: 'Bez kategorii',
          origin: 'Dodana samodzielnie',
          icon: Icons.bookmark_outline_rounded,
          iconBackground: const Color(0xFFF7E3EB),
        ),
      );

      _newActivityController.clear();
      _searchController.clear();
      _showAddForm = false;
    });

    _showMessage('Dodano aktywność do listy');
  }

  void _deleteActivity(int id) {
    setState(() {
      _activities.removeWhere((activity) => activity.id == id);
      _deletingId = null;
    });

    _showMessage('Usunięto aktywność z listy');
  }

  Widget _searchField() {
    return TextField(
      controller: _searchController,
      onChanged: (_) {
        setState(() {});
      },
      decoration: InputDecoration(
        hintText: 'Szukaj na liście...',
        hintStyle: const TextStyle(
          color: mutedText,
          fontSize: 14,
        ),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: pink,
        ),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() {});
                },
                icon: const Icon(
                  Icons.close_rounded,
                  color: mutedText,
                  size: 19,
                ),
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 17,
          horizontal: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _activityCard(SavedActivityItem activity) {
    final isDeleting = _deletingId == activity.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFF1E2E6),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: activity.iconBackground,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  activity.icon,
                  color: const Color(0xFF996878),
                  size: 23,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.name,
                      style: const TextStyle(
                        color: textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      activity.category,
                      style: const TextStyle(
                        color: mutedText,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      activity.origin,
                      style: const TextStyle(
                        color: pink,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Usuń z listy',
                onPressed: () {
                  setState(() {
                    _deletingId = isDeleting ? null : activity.id;
                  });
                },
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Color(0xFFBE8B91),
                  size: 23,
                ),
              ),
            ],
          ),

          if (isDeleting) ...[
            const SizedBox(height: 12),
            const Divider(
              color: Color(0xFFF3E6E9),
            ),
            const SizedBox(height: 7),
            const Text(
              'Usunąć tę aktywność z listy?',
              style: TextStyle(
                color: textColor,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _deletingId = null;
                    });
                  },
                  child: const Text(
                    'Anuluj',
                    style: TextStyle(color: mutedText),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _deleteActivity(activity.id);
                  },
                  child: const Text(
                    'Usuń z listy',
                    style: TextStyle(
                      color: Color(0xFFBE766C),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                _showMessage(
                  'Powiązanie z formularzem dodawania '
                  'aktywności przygotujemy później',
                );
              },
              icon: const Icon(
                Icons.add_rounded,
                size: 20,
              ),
              label: const Text(
                'Dodaj wpis z tej aktywności',
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFB77F68),
                backgroundColor: const Color(0xFFFFF2EB),
                side: BorderSide.none,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addActivitySection() {
    if (!_showAddForm) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () {
            setState(() {
              _showAddForm = true;
            });
          },
          icon: const Icon(
            Icons.add_circle_outline_rounded,
          ),
          label: const Text(
            'Dodaj własny pomysł',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFB87690),
            backgroundColor: const Color(0xFFF8E3EA),
            side: BorderSide.none,
            padding: const EdgeInsets.symmetric(
              vertical: 17,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFF1E2E6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nowy pomysł na aktywność',
            style: TextStyle(
              color: textColor,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 13),

          TextField(
            controller: _newActivityController,
            autofocus: true,
            maxLength: 100,
            textCapitalization:
                TextCapitalization.sentences,
            onSubmitted: (_) => _addActivity(),
            decoration: InputDecoration(
              hintText: 'Nazwa aktywności',
              filled: true,
              fillColor: background,
              contentPadding:
                  const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 13,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _showAddForm = false;
                    _newActivityController.clear();
                  });
                },
                child: const Text(
                  'Anuluj',
                  style: TextStyle(color: mutedText),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _addActivity,
                style: ElevatedButton.styleFrom(
                  backgroundColor: pink,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 21,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Dodaj'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    final isSearching =
        _searchController.text.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 35,
        horizontal: 15,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.bookmark_border_rounded,
            color: pink,
            size: 43,
          ),
          const SizedBox(height: 13),
          Text(
            isSearching
                ? 'Brak pasujących aktywności'
                : 'Twoja lista jest jeszcze pusta',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: textColor,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isSearching
                ? 'Spróbuj wpisać inną nazwę.'
                : 'Zapisz rekomendację lub dodaj własny pomysł.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: mutedText,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredActivities;

    return Container(
      color: background,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            20, 20, 20, 30,
          ),
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Lista na później',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${_activities.length} zapisane',
                  style: const TextStyle(
                    color: mutedText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _searchField(),

            const SizedBox(height: 16),

            _addActivitySection(),

            const SizedBox(height: 22),

            if (filtered.isEmpty)
              _emptyState()
            else
              for (final activity in filtered)
                _activityCard(activity),
          ],
        ),
      ),
    );
  }
}
