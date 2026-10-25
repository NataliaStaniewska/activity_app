
import 'package:flutter/material.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({super.key});

  @override
  State<AddActivityScreen> createState() =>
      _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  // Kolorystyka
  static const Color background = Color(0xFFFFF8F8);
  static const Color textColor = Color(0xFF604A50);
  static const Color pink = Color(0xFFD88FA5);
  static const Color orange = Color(0xFFF3A078);
  static const Color mutedText = Color(0xFF9B838B);

  final _formKey = GlobalKey<FormState>();

  final _activitySearchController = TextEditingController();
  final _customNameController = TextEditingController();

  final List<String> _activities = [
    'Spacer',
    'Czytanie książki',
    'Jazda na rowerze',
    'Gotowanie',
    'Rysowanie',
    'Ćwiczenia fizyczne',
  ];

  final List<String> _categories = [
    'Ruch',
    'Relaks',
    'Kreatywność',
    'Spotkania',
    'Nauka',
    'Inne',
  ];

  String? _selectedActivity;
  bool _showActivitySuggestions = false;
  bool _addingCustomActivity = false;

  final Set<String> _selectedCategories = {};

  String _company = 'Samodzielnie';
  String _place = 'Wewnątrz';

  int? _moodBefore;
  int? _moodAfter;
  int? _pleasure;

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void dispose() {
    _activitySearchController.dispose();
    _customNameController.dispose();
    super.dispose();
  }

  Widget _section({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFF2E3E7),
        ),
      ),
      child: child,
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: textColor,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: textColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // Wybór istniejącej lub dodawanie nowej aktywności
  Widget _activitySelector() {
    final query =
        _activitySearchController.text.trim().toLowerCase();

    final filteredActivities = _activities.where((activity) {
      return activity.toLowerCase().contains(query);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Nazwa aktywności'),
        const SizedBox(height: 12),

        TextField(
          controller: _activitySearchController,
          onTap: () {
            setState(() {
              _showActivitySuggestions = true;
              _addingCustomActivity = false;
            });
          },
          onChanged: (_) {
            setState(() {
              _showActivitySuggestions = true;
              _selectedActivity = null;
            });
          },
          decoration: InputDecoration(
            hintText: 'Wyszukaj lub wybierz aktywność',
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: pink,
            ),
            suffixIcon: _selectedActivity != null
                ? const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF729477),
                  )
                : null,
            filled: true,
            fillColor: background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        if (_showActivitySuggestions &&
            !_addingCustomActivity) ...[
          const SizedBox(height: 8),

          Container(
            constraints: const BoxConstraints(maxHeight: 220),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFF2E3E7),
              ),
              boxShadow: [
                BoxShadow(
                  color: pink.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: filteredActivities.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Nie znaleziono aktywności',
                      style: TextStyle(color: mutedText),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: filteredActivities.length,
                    separatorBuilder: (_, _) =>
                        const Divider(
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                          color: Color(0xFFF5ECEF),
                        ),
                    itemBuilder: (context, index) {
                      final activity =
                          filteredActivities[index];

                      return ListTile(
                        leading: const Icon(
                          Icons.circle_outlined,
                          color: pink,
                          size: 20,
                        ),
                        title: Text(
                          activity,
                          style: const TextStyle(
                            color: textColor,
                            fontSize: 14,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right_rounded,
                          color: mutedText,
                          size: 20,
                        ),
                        onTap: () {
                          setState(() {
                            _selectedActivity = activity;
                            _activitySearchController.text =
                                activity;
                            _showActivitySuggestions = false;
                          });

                          FocusScope.of(context).unfocus();
                        },
                      );
                    },
                  ),
          ),
        ],

        const SizedBox(height: 12),

        if (!_addingCustomActivity)
          TextButton.icon(
            onPressed: () {
              setState(() {
                _addingCustomActivity = true;
                _showActivitySuggestions = false;
              });
            },
            icon: const Icon(
              Icons.add_circle_outline_rounded,
            ),
            label: const Text('Dodaj nową aktywność'),
            style: TextButton.styleFrom(
              foregroundColor: pink,
            ),
          ),

        if (_addingCustomActivity) ...[
          const SizedBox(height: 8),

          TextField(
            controller: _customNameController,
            maxLength: 100,
            decoration: InputDecoration(
              hintText: 'Nazwa nowej aktywności',
              filled: true,
              fillColor: background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _addingCustomActivity = false;
                    _customNameController.clear();
                  });
                },
                child: const Text(
                  'Anuluj',
                  style: TextStyle(color: mutedText),
                ),
              ),

              const SizedBox(width: 8),

              ElevatedButton.icon(
                onPressed: () {
                  final name =
                      _customNameController.text.trim();

                  if (name.isEmpty) {
                    _showMessage('Wpisz nazwę aktywności');
                    return;
                  }

                  String selectedName = name;

                  for (final activity in _activities) {
                    if (activity.toLowerCase() ==
                        name.toLowerCase()) {
                      selectedName = activity;
                      break;
                    }
                  }

                  setState(() {
                    final exists = _activities.any(
                      (activity) =>
                          activity.toLowerCase() ==
                          name.toLowerCase(),
                    );

                    if (!exists) {
                      _activities.add(name);
                      _activities.sort();
                    }

                    _selectedActivity = selectedName;
                    _activitySearchController.text =
                        selectedName;

                    _addingCustomActivity = false;
                    _showActivitySuggestions = false;
                    _customNameController.clear();
                  });

                  FocusScope.of(context).unfocus();
                },
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Dodaj'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: pink,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  // Wybór wielu kategorii
  Widget _categorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Kategorie aktywności'),
        const SizedBox(height: 12),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _categories.map((category) {
            final selected =
                _selectedCategories.contains(category);

            return FilterChip(
              label: Text(category),
              selected: selected,
              showCheckmark: true,
              selectedColor: const Color(0xFFF8DDE5),
              backgroundColor: background,
              checkmarkColor: pink,
              side: BorderSide(
                color: selected
                    ? pink
                    : const Color(0xFFF0E0E4),
              ),
              labelStyle: TextStyle(
                color: textColor,
                fontWeight: selected
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
              onSelected: (isSelected) {
                setState(() {
                  if (isSelected) {
                    _selectedCategories.add(category);
                  } else {
                    _selectedCategories.remove(category);
                  }
                });
              },
            );
          }).toList(),
        ),

        const SizedBox(height: 8),

        const Text(
          'Możesz wybrać więcej niż jedną kategorię.',
          style: TextStyle(
            color: mutedText,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // Wybór jednej z dostępnych opcji
  Widget _optionSelector({
    required String title,
    required List<String> options,
    required String selected,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(title),
        const SizedBox(height: 12),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final active = selected == option;

            return ChoiceChip(
              label: Text(option),
              selected: active,
              showCheckmark: false,
              selectedColor: const Color(0xFFF8DDE5),
              backgroundColor: background,
              side: BorderSide(
                color: active
                    ? pink
                    : const Color(0xFFF0E0E4),
              ),
              labelStyle: TextStyle(
                color: active ? pink : textColor,
                fontWeight: active
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
              onSelected: (_) => onChanged(option),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Skala ocen 1-5
  Widget _ratingSelector({
    required String title,
    required int? value,
    required ValueChanged<int> onChanged,
    Color activeColor = pink,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(title),
        const SizedBox(height: 12),

        Row(
          children: List.generate(5, (index) {
            final number = index + 1;
            final selected = value == number;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: index == 4 ? 0 : 7,
                ),
                child: InkWell(
                  onTap: () => onChanged(number),
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration:
                        const Duration(milliseconds: 180),
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected
                          ? activeColor
                          : background,
                      borderRadius:
                          BorderRadius.circular(12),
                      border: Border.all(
                        color: selected
                            ? activeColor
                            : const Color(0xFFF0E0E4),
                      ),
                    ),
                    child: Text(
                      '$number',
                      style: TextStyle(
                        color: selected
                            ? Colors.white
                            : textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: now,
      helpText: 'Wybierz datę aktywności',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: pink,
              onPrimary: Colors.white,
              surface: background,
              onSurface: textColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      helpText: 'Wybierz godzinę aktywności',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: pink,
              onPrimary: Colors.white,
              surface: background,
              onSurface: textColor,
            ),
            timePickerTheme: const TimePickerThemeData(
              dialBackgroundColor: Color(0xFFF9E4EA),
              hourMinuteColor: Color(0xFFF9E4EA),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  String _formattedDate() {
    final day =
        _selectedDate.day.toString().padLeft(2, '0');
    final month =
        _selectedDate.month.toString().padLeft(2, '0');

    return '$day.$month.${_selectedDate.year}';
  }

  String _formattedTime() {
    final hour =
        _selectedTime.hour.toString().padLeft(2, '0');
    final minute =
        _selectedTime.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  Widget _dateTimeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Data i godzina'),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(
                  Icons.calendar_today_outlined,
                  size: 19,
                ),
                label: Text(_formattedDate()),
                style: OutlinedButton.styleFrom(
                  foregroundColor: textColor,
                  backgroundColor: background,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  side: const BorderSide(
                    color: Color(0xFFF0E0E4),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: OutlinedButton.icon(
                onPressed: _pickTime,
                icon: const Icon(
                  Icons.access_time_rounded,
                  size: 19,
                ),
                label: Text(_formattedTime()),
                style: OutlinedButton.styleFrom(
                  foregroundColor: textColor,
                  backgroundColor: background,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  side: const BorderSide(
                    color: Color(0xFFF0E0E4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: textColor,
      ),
    );
  }

  // Walidacja danych - zapis do API dodamy później
  void _saveActivity() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Trzeba wskazać aktywność z listy lub
    // zatwierdzić nową przyciskiem "Dodaj".
    final activityName = _selectedActivity;

    if (activityName == null || activityName.isEmpty) {
      _showMessage('Wybierz lub dodaj aktywność');
      return;
    }

    if (_selectedCategories.isEmpty) {
      _showMessage(
        'Wybierz przynajmniej jedną kategorię',
      );
      return;
    }

    if (_moodBefore == null ||
        _moodAfter == null ||
        _pleasure == null) {
      _showMessage('Uzupełnij wszystkie oceny');
      return;
    }

    final dateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    if (dateTime.isAfter(DateTime.now())) {
      _showMessage(
        'Data i godzina nie mogą być w przyszłości',
      );
      return;
    }

    final entry = {
      'activityName': activityName,
      'categories': _selectedCategories.toList(),
      'company': _company,
      'place': _place,
      'moodBefore': _moodBefore,
      'moodAfter': _moodAfter,
      'pleasure': _pleasure,
      'date': dateTime.toIso8601String(),
    };

    debugPrint('Przygotowany wpis: $entry');

    _showMessage(
      'Formularz jest poprawny. '
      'Zapis do bazy podłączymy w kolejnym kroku.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              20, 20, 20, 30,
            ),
            children: [
              const Text(
                'Nowa aktywność',
                style: TextStyle(
                  color: textColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 22),

              // Informacje o aktywności
              _section(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    _activitySelector(),

                    const SizedBox(height: 22),

                    const Divider(
                      color: Color(0xFFF5E9EB),
                    ),

                    const SizedBox(height: 20),

                    _categorySelector(),

                    const SizedBox(height: 24),

                    _optionSelector(
                      title: 'Towarzystwo',
                      options: const [
                        'Samodzielnie',
                        'Z innymi',
                      ],
                      selected: _company,
                      onChanged: (value) {
                        setState(() {
                          _company = value;
                        });
                      },
                    ),

                    const SizedBox(height: 24),

                    _optionSelector(
                      title: 'Miejsce',
                      options: const [
                        'Wewnątrz',
                        'Na zewnątrz',
                        'W obu środowiskach',
                      ],
                      selected: _place,
                      onChanged: (value) {
                        setState(() {
                          _place = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Oceny samopoczucia
              _section(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('Ocena samopoczucia'),

                    const SizedBox(height: 8),

                    const Text(
                      '1 – bardzo złe, 5 – bardzo dobre',
                      style: TextStyle(
                        color: mutedText,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 22),

                    _ratingSelector(
                      title: 'Przed aktywnością',
                      value: _moodBefore,
                      onChanged: (value) {
                        setState(() {
                          _moodBefore = value;
                        });
                      },
                    ),

                    const SizedBox(height: 24),

                    _ratingSelector(
                      title: 'Po aktywności',
                      value: _moodAfter,
                      onChanged: (value) {
                        setState(() {
                          _moodAfter = value;
                        });
                      },
                    ),

                    const SizedBox(height: 22),

                    const Divider(
                      color: Color(0xFFF5E9EB),
                    ),

                    const SizedBox(height: 20),

                    _ratingSelector(
                      title: 'Przyjemność z aktywności',
                      value: _pleasure,
                      activeColor: orange,
                      onChanged: (value) {
                        setState(() {
                          _pleasure = value;
                        });
                      },
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      '1 – bardzo mała, 5 – bardzo duża',
                      style: TextStyle(
                        color: mutedText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Data i godzina
              _section(
                child: _dateTimeSelector(),
              ),

              const SizedBox(height: 24),

              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _saveActivity,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orange,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Zapisz',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
