
import 'package:flutter/material.dart';

import '../enums/activity_category.dart';
import '../enums/activity_emotion.dart';
import '../enums/company_type.dart';
import '../enums/location_type.dart';
import '../models/activity_entry.dart';
import '../services/activities_api.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({super.key, this.api = const ActivitiesApi()});

  final ActivitiesApi api;

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

  final _activitySearchController = TextEditingController();
  final _customNameController = TextEditingController();
  final _likesController = TextEditingController();
  final _dislikesController = TextEditingController();
  final _notesController = TextEditingController();

  final List<String> _activities = [
    'Spacer',
    'Czytanie książki',
    'Jazda na rowerze',
    'Gotowanie',
    'Rysowanie',
    'Ćwiczenia fizyczne',
  ];

  String? _selectedActivity;
  bool _showActivitySuggestions = false;
  bool _addingCustomActivity = false;

  final Set<ActivityCategory> _selectedCategories = {};
  final Set<ActivityEmotion> _selectedEmotions = {};
  CompanyType _companyType = CompanyType.alone;
  LocationType _locationType = LocationType.indoor;

  int? _moodBefore;
  int? _moodAfter;
  int? _rating;

  bool _isSaving = false;
  DateTime _initialDate = DateTime.now();
  late DateTime _selectedDate = _initialDate;
  late TimeOfDay _selectedTime;
  bool _timePicked = false;

  @override
  void initState() {
    super.initState();
    _selectedTime = TimeOfDay.fromDateTime(_selectedDate);
  }

  @override
  void dispose() {
    _activitySearchController.dispose();
    _customNameController.dispose();
    _likesController.dispose();
    _dislikesController.dispose();
    _notesController.dispose();
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
                : Material(
                    type: MaterialType.transparency,
                    borderRadius: BorderRadius.circular(16),
                    clipBehavior: Clip.antiAlias,
                    child: ListView.separated(
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

  Widget _multiSelector<T>({
    required String title,
    required List<T> options,
    required String Function(T) labelFor,
    required Set<T> selection,
    required String hint,
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
            final selected =
                selection.contains(option);

            return FilterChip(
              label: Text(labelFor(option)),
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
                    selection.add(option);
                  } else {
                    selection.remove(option);
                  }
                });
              },
            );
          }).toList(),
        ),

        const SizedBox(height: 8),

        Text(
          hint,
          style: const TextStyle(
            color: mutedText,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // Wybór jednej z dostępnych opcji
  Widget _optionSelector<T>({
    required String title,
    required Map<T, String> options,
    required T selected,
    required ValueChanged<T> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(title),
        const SizedBox(height: 12),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.entries.map((option) {
            final active = selected == option.key;

            return ChoiceChip(
              label: Text(option.value),
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
              onSelected: (_) => onChanged(option.key),
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
        _timePicked = true;
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

  Widget _optionalTextField(
    String label,
    TextEditingController controller,
    int maxLength,
  ) {
    return TextField(
      controller: controller,
      maxLength: maxLength,
      maxLines: null,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  String? _optionalText(TextEditingController controller) {
    final text = controller.text.trim();
    return text.isEmpty ? null : text;
  }

  Future<void> _saveActivity() async {
    if (_isSaving) return;

    final activityName = _selectedActivity;
    if (activityName == null || activityName.isEmpty || _addingCustomActivity) {
      _showMessage('Wybierz lub dodaj aktywność');
      return;
    }

    if (_selectedCategories.isEmpty) {
      _showMessage('Wybierz przynajmniej jedną kategorię');
      return;
    }

    final moodAfter = _moodAfter;
    final rating = _rating;
    if (moodAfter == null || rating == null) {
      _showMessage('Oceń samopoczucie po aktywności i przyjemność');
      return;
    }

    if (_selectedEmotions.isEmpty) {
      _showMessage('Wybierz przynajmniej jedną emocję');
      return;
    }

    final dateTime = !_timePicked && DateUtils.isSameDay(_selectedDate, _initialDate)
        ? _initialDate.subtract(Duration(
            seconds: _initialDate.second,
            milliseconds: _initialDate.millisecond,
            microseconds: _initialDate.microsecond,
          ))
        : DateTime(
            _selectedDate.year,
            _selectedDate.month,
            _selectedDate.day,
            _selectedTime.hour,
            _selectedTime.minute,
          );

    if (!DateUtils.isSameDay(dateTime, _selectedDate) ||
        TimeOfDay.fromDateTime(dateTime) != _selectedTime) {
      _showMessage('Ta godzina nie występuje w wybranym dniu');
      return;
    }

    if (dateTime.isAfter(DateTime.now())) {
      _showMessage('Data i godzina nie mogą być w przyszłości');
      return;
    }

    final likes = _optionalText(_likesController);
    final dislikes = _optionalText(_dislikesController);
    final notes = _optionalText(_notesController);
    if (activityName.runes.length > 100 ||
        (likes?.runes.length ?? 0) > 200 ||
        (dislikes?.runes.length ?? 0) > 200 ||
        (notes?.runes.length ?? 0) > 300) {
      _showMessage('Skróć nazwę lub opis aktywności');
      return;
    }

    final entry = ActivityEntry(
      activityName: activityName,
      date: dateTime,
      categories: _selectedCategories,
      locationType: _locationType,
      companyType: _companyType,
      moodBefore: _moodBefore,
      moodAfter: moodAfter,
      rating: rating,
      emotions: _selectedEmotions,
      likes: likes,
      dislikes: dislikes,
      notes: notes,
    );

    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    setState(() => _isSaving = true);
    try {
      await widget.api.createActivity(entry);
      if (!mounted) return;

      setState(_resetForm);
      _showMessage('Aktywność została zapisana.');
    } on ActivitySaveException catch (error) {
      if (mounted) _showMessage(error.message);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _resetForm() {
    _activitySearchController.clear();
    _customNameController.clear();
    _likesController.clear();
    _dislikesController.clear();
    _notesController.clear();
    _selectedActivity = null;
    _showActivitySuggestions = false;
    _addingCustomActivity = false;
    _selectedCategories.clear();
    _selectedEmotions.clear();
    _companyType = CompanyType.alone;
    _locationType = LocationType.indoor;
    _moodBefore = null;
    _moodAfter = null;
    _rating = null;
    _initialDate = DateTime.now();
    _selectedDate = _initialDate;
    _selectedTime = TimeOfDay.fromDateTime(_initialDate);
    _timePicked = false;
  }

  @override
  Widget build(BuildContext context) {
    final form = Container(
      color: background,
      child: SafeArea(
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

                  _multiSelector(
                    title: 'Kategorie aktywności',
                    options: ActivityCategory.values,
                    labelFor: (category) => category.label,
                    selection: _selectedCategories,
                    hint: 'Możesz wybrać więcej niż jedną kategorię.',
                  ),

                  const SizedBox(height: 24),

                  _optionSelector(
                    title: 'Towarzystwo',
                    options: const {
                      CompanyType.alone: 'Samodzielnie',
                      CompanyType.withOthers: 'Z innymi',
                    },
                    selected: _companyType,
                    onChanged: (value) {
                      setState(() {
                        _companyType = value;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  _optionSelector(
                    title: 'Miejsce',
                    options: const {
                      LocationType.indoor: 'Wewnątrz',
                      LocationType.outdoor: 'Na zewnątrz',
                      LocationType.mixed: 'W obu środowiskach',
                    },
                    selected: _locationType,
                    onChanged: (value) {
                      setState(() {
                        _locationType = value;
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
                    title: 'Przed aktywnością (opcjonalnie)',
                    value: _moodBefore,
                    onChanged: (value) {
                      setState(() {
                        _moodBefore = _moodBefore == value ? null : value;
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
                    value: _rating,
                    activeColor: orange,
                    onChanged: (value) {
                      setState(() {
                        _rating = value;
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
                  const SizedBox(height: 24),

                  _multiSelector(
                    title: 'Emocje po aktywności',
                    options: ActivityEmotion.values,
                    labelFor: (emotion) => emotion.label,
                    selection: _selectedEmotions,
                    hint: 'Możesz wybrać więcej niż jedną emocję.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Data i godzina
            _section(
              child: _dateTimeSelector(),
            ),

            const SizedBox(height: 16),

            _section(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Refleksje (opcjonalnie)'),
                  const SizedBox(height: 16),
                  _optionalTextField('Co Ci się podobało?', _likesController, 200),
                  const SizedBox(height: 8),
                  _optionalTextField('Co Ci się nie podobało?', _dislikesController, 200),
                  const SizedBox(height: 8),
                  _optionalTextField('Notatki', _notesController, 300),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveActivity,
                style: ElevatedButton.styleFrom(
                  backgroundColor: orange,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox.square(
                        dimension: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          semanticsLabel: 'Zapisywanie aktywności',
                        ),
                      )
                    : const Text(
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
    );

    return AbsorbPointer(absorbing: _isSaving, child: form);
  }
}
