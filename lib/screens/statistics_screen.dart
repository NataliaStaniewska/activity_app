
import 'package:flutter/material.dart';

// Dane pojedynczego wpisu
class ActivityRecord {
  final String name;
  final List<String> categories;
  final String company;
  final String place;
  final int moodBefore;
  final int moodAfter;
  final int pleasure;
  final DateTime date;

  ActivityRecord({
    required this.name,
    required this.categories,
    required this.company,
    required this.place,
    required this.moodBefore,
    required this.moodAfter,
    required this.pleasure,
    required this.date,
  });

  int get change => moodAfter - moodBefore;
}

// Statystyki wyliczane z grupy wpisów
class ActivityStats {
  final String name;
  final List<ActivityRecord> records;

  ActivityStats(this.name, this.records);

  int get count => records.length;

  double average(int Function(ActivityRecord) getValue) {
    if (records.isEmpty) return 0;

    int sum = 0;
    for (final record in records) {
      sum += getValue(record);
    }

    return sum / count;
  }

  double get averagePleasure =>
      average((r) => r.pleasure);

  double get averageBefore =>
      average((r) => r.moodBefore);

  double get averageAfter =>
      average((r) => r.moodAfter);

  double get averageChange =>
      average((r) => r.change);

  int get improvements =>
      records.where((r) => r.change > 0).length;

  int get unchanged =>
      records.where((r) => r.change == 0).length;

  int get worsening =>
      records.where((r) => r.change < 0).length;

  double get improvementRate =>
      count == 0 ? 0 : improvements / count * 100;

  double get medianChange {
    if (records.isEmpty) return 0;

    final changes = records.map((r) => r.change).toList();
    changes.sort();

    final middle = changes.length ~/ 2;

    if (changes.length.isOdd) {
      return changes[middle].toDouble();
    }

    return (changes[middle - 1] + changes[middle]) / 2;
  }
}

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() =>
      _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  static const Color background = Color(0xFFFFF8F8);
  static const Color textColor = Color(0xFF604A50);
  static const Color pink = Color(0xFFD88FA5);
  static const Color orange = Color(0xFFF3A078);
  static const Color mutedText = Color(0xFF9B838B);
  static const Color palePink = Color(0xFFF8E3EA);

  String selectedPeriod = 'all';
  String selectedMoodView = 'improvement';
  String selectedCategoryView = 'pleasure';
  String selectedContextView = 'company';

  late final List<ActivityRecord> records;

  @override
  void initState() {
    super.initState();
    records = createDemoRecords();
  }

  // Przykładowe wpisy do prezentacji aplikacji
  List<ActivityRecord> createDemoRecords() {
    final today = DateTime.now();

    ActivityRecord entry(
      String name,
      List<String> categories,
      String company,
      String place,
      int before,
      int after,
      int pleasure,
      int daysAgo,
    ) {
      return ActivityRecord(
        name: name,
        categories: categories,
        company: company,
        place: place,
        moodBefore: before,
        moodAfter: after,
        pleasure: pleasure,
        date: DateTime(
          today.year,
          today.month,
          today.day - daysAgo,
          12,
        ),
      );
    }

    return [
      entry('Spacer', ['Ruch', 'Relaks'], 'Samodzielnie',
          'Na zewnątrz', 3, 5, 5, 0),
      entry('Czytanie książki', ['Relaks'], 'Samodzielnie',
          'Wewnątrz', 3, 4, 5, 1),
      entry('Rysowanie', ['Kreatywność'], 'Samodzielnie',
          'Wewnątrz', 4, 4, 4, 2),
      entry('Spacer', ['Ruch', 'Relaks'], 'Z innymi',
          'Na zewnątrz', 2, 4, 5, 3),
      entry('Gotowanie', ['Kreatywność'], 'Z innymi',
          'Wewnątrz', 4, 3, 3, 4),
      entry('Czytanie książki', ['Relaks'], 'Samodzielnie',
          'Wewnątrz', 2, 4, 5, 5),
      entry('Spacer', ['Ruch'], 'Samodzielnie',
          'Na zewnątrz', 3, 4, 4, 6),
      entry('Rysowanie', ['Kreatywność'], 'Samodzielnie',
          'Wewnątrz', 2, 3, 5, 8),
      entry('Spacer', ['Ruch', 'Relaks'], 'Z innymi',
          'Na zewnątrz', 3, 5, 5, 9),
      entry('Gotowanie', ['Kreatywność'], 'Samodzielnie',
          'Wewnątrz', 3, 3, 3, 10),
      entry('Czytanie książki', ['Relaks'], 'Samodzielnie',
          'Wewnątrz', 4, 5, 5, 11),
      entry('Spacer', ['Ruch'], 'Z innymi',
          'Na zewnątrz', 3, 4, 4, 12),
      entry('Rysowanie', ['Kreatywność'], 'Samodzielnie',
          'Wewnątrz', 3, 4, 4, 13),
      entry('Czytanie książki', ['Relaks'], 'Samodzielnie',
          'Wewnątrz', 4, 4, 4, 14),
      entry('Spacer', ['Ruch', 'Relaks'], 'Samodzielnie',
          'Na zewnątrz', 2, 4, 5, 16),
      entry('Gotowanie', ['Kreatywność'], 'Z innymi',
          'Wewnątrz', 4, 4, 4, 18),
      entry('Rysowanie', ['Kreatywność'], 'Z innymi',
          'Wewnątrz', 4, 3, 4, 20),
      entry('Czytanie książki', ['Relaks'], 'Samodzielnie',
          'Wewnątrz', 3, 5, 5, 23),
      entry('Spacer', ['Ruch'], 'Samodzielnie',
          'Na zewnątrz', 4, 5, 4, 25),
      entry('Gotowanie', ['Kreatywność'], 'Z innymi',
          'Wewnątrz', 3, 4, 4, 27),
      entry('Czytanie książki', ['Relaks'], 'Samodzielnie',
          'Wewnątrz', 3, 4, 4, 32),
      entry('Spacer', ['Ruch', 'Relaks'], 'Z innymi',
          'Na zewnątrz', 3, 5, 5, 35),
      entry('Rysowanie', ['Kreatywność'], 'Samodzielnie',
          'Wewnątrz', 4, 4, 4, 39),
      entry('Gotowanie', ['Kreatywność'], 'Samodzielnie',
          'Wewnątrz', 3, 2, 2, 43),
    ];
  }

  // FILTRY OKRESU
  List<ActivityRecord> get filteredRecords {
    if (selectedPeriod == 'all') {
      return List.from(records);
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final days = selectedPeriod == 'week' ? 7 : 30;

    final start =
        today.subtract(Duration(days: days - 1));
    final end = today.add(const Duration(days: 1));

    return records.where((record) {
      return !record.date.isBefore(start) &&
          record.date.isBefore(end);
    }).toList();
  }

  // Grupowanie po nazwach aktywności
  List<ActivityStats> get activityStats {
    final groups = <String, List<ActivityRecord>>{};

    for (final record in filteredRecords) {
      groups.putIfAbsent(record.name, () => []);
      groups[record.name]!.add(record);
    }

    return groups.entries.map((entry) {
      return ActivityStats(entry.key, entry.value);
    }).toList();
  }

  // Jeden wpis może należeć do kilku kategorii
  List<ActivityStats> get categoryStats {
    final groups = <String, List<ActivityRecord>>{};

    for (final record in filteredRecords) {
      for (final category in record.categories.toSet()) {
        groups.putIfAbsent(category, () => []);
        groups[category]!.add(record);
      }
    }

    return groups.entries.map((entry) {
      return ActivityStats(entry.key, entry.value);
    }).toList();
  }

  // Grupowanie według towarzystwa lub miejsca
  List<ActivityStats> get contextStats {
    final groups = <String, List<ActivityRecord>>{};

    for (final record in filteredRecords) {
      final key = selectedContextView == 'company'
          ? record.company
          : record.place;

      groups.putIfAbsent(key, () => []);
      groups[key]!.add(record);
    }

    return groups.entries.map((entry) {
      return ActivityStats(entry.key, entry.value);
    }).toList();
  }

  String formatNumber(double value) {
    return value.toStringAsFixed(1).replaceAll('.', ',');
  }

  String formatChange(double value) {
    final prefix = value > 0 ? '+' : '';
    return '$prefix${formatNumber(value)}';
  }

  Widget section(Widget child) {
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

  Widget sectionTitle(
    String title,
    IconData icon, {
    Color color = pink,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 23),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget description(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: mutedText,
        fontSize: 12,
        height: 1.4,
      ),
    );
  }

  // Uniwersalny przełącznik widoków
  Widget toggle({
    required List<String> values,
    required List<String> labels,
    required String selected,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: List.generate(values.length, (index) {
          final active = values[index] == selected;

          return Expanded(
            child: InkWell(
              onTap: () => onChanged(values[index]),
              borderRadius: BorderRadius.circular(11),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  vertical: 11,
                  horizontal: 3,
                ),
                decoration: BoxDecoration(
                  color: active
                      ? Colors.white
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(11),
                  border: active
                      ? Border.all(
                          color: const Color(0xFFF2E3E7),
                        )
                      : null,
                ),
                child: Text(
                  labels[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: active ? pink : mutedText,
                    fontSize: 11,
                    fontWeight: active
                        ? FontWeight.bold
                        : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // Poziomy pasek wartości
  Widget progressRow({
    required String title,
    required String value,
    required String subtitle,
    required double fraction,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (onTap != null)
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: mutedText,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                value: fraction.clamp(0.0, 1.0).toDouble(),
                minHeight: 8,
                backgroundColor: const Color(0xFFF7EEF1),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(
                color: mutedText,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // OSTATNI TYDZIEŃ / MIESIĄC / CAŁY OKRES
  Widget periodSelector() {
    return toggle(
      values: const ['week', 'month', 'all'],
      labels: const [
        'Ostatni tydzień',
        'Ostatni miesiąc',
        'Cały okres',
      ],
      selected: selectedPeriod,
      onChanged: (value) {
        setState(() {
          selectedPeriod = value;
        });
      },
    );
  }

  Widget summaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palePink,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Zarejestrowane aktywności',
            style: TextStyle(
              color: Color(0xFF956F7C),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${filteredRecords.length}',
                style: const TextStyle(
                  color: textColor,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 9),
              const Padding(
                padding: EdgeInsets.only(bottom: 7),
                child: Text(
                  'wpisów',
                  style: TextStyle(
                    color: Color(0xFF956F7C),
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 1. ULUBIONE AKTYWNOŚCI
  Widget favoritesSection() {
    final items = activityStats;

    items.sort(
      (a, b) =>
          b.averagePleasure.compareTo(a.averagePleasure),
    );

    return section(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle(
            'Twoje ulubione aktywności',
            Icons.favorite_outline_rounded,
          ),
          const SizedBox(height: 9),
          description(
            'Ranking według średniej oceny przyjemności.',
          ),
          const SizedBox(height: 16),
          for (int i = 0; i < items.length; i++)
            progressRow(
              title: '${i + 1}. ${items[i].name}',
              value:
                  '${formatNumber(items[i].averagePleasure)}/5',
              subtitle: '${items[i].count} wpisów',
              fraction: items[i].averagePleasure / 5,
              color: pink,
              onTap: () => showDetails(items[i]),
            ),
        ],
      ),
    );
  }

  // 2. AKTYWNOŚCI A SAMOPOCZUCIE
  Widget moodSection() {
    final items = activityStats;

    if (selectedMoodView == 'improvement') {
      items.sort(
        (a, b) =>
            b.improvementRate.compareTo(a.improvementRate),
      );
    } else {
      items.sort(
        (a, b) =>
            b.averageAfter.compareTo(a.averageAfter),
      );
    }

    return section(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle(
            'Aktywności a samopoczucie',
            Icons.trending_up_rounded,
            color: orange,
          ),
          const SizedBox(height: 16),
          toggle(
            values: const ['improvement', 'after'],
            labels: const [
              'Częstość poprawy',
              'Samopoczucie po',
            ],
            selected: selectedMoodView,
            onChanged: (value) {
              setState(() {
                selectedMoodView = value;
              });
            },
          ),
          const SizedBox(height: 13),
          description(
            selectedMoodView == 'improvement'
                ? 'Jak często samopoczucie po aktywności było lepsze niż przed?'
                : 'Średnia ocena samopoczucia po aktywności (1–5).',
          ),
          const SizedBox(height: 12),
          for (final item in items)
            progressRow(
              title: item.name,
              value: selectedMoodView == 'improvement'
                  ? '${formatNumber(item.improvementRate)}%'
                  : '${formatNumber(item.averageAfter)}/5',
              subtitle: selectedMoodView == 'improvement'
                  ? '${item.improvements} popraw na ${item.count} wpisów'
                  : 'Przed: ${formatNumber(item.averageBefore)}/5 · ${item.count} wpisów',
              fraction: selectedMoodView == 'improvement'
                  ? item.improvementRate / 100
                  : item.averageAfter / 5,
              color: orange,
              onTap: () => showDetails(item),
            ),
        ],
      ),
    );
  }

  // 3. KATEGORIE AKTYWNOŚCI
  Widget categoriesSection() {
    final items = categoryStats;

    double score(ActivityStats item) {
      return selectedCategoryView == 'pleasure'
          ? item.averagePleasure
          : item.averageAfter;
    }

    items.sort(
      (a, b) => score(b).compareTo(score(a)),
    );

    return section(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle(
            'Kategorie aktywności',
            Icons.category_outlined,
          ),
          const SizedBox(height: 16),
          toggle(
            values: const ['pleasure', 'after'],
            labels: const [
              'Przyjemność',
              'Samopoczucie po',
            ],
            selected: selectedCategoryView,
            onChanged: (value) {
              setState(() {
                selectedCategoryView = value;
              });
            },
          ),
          const SizedBox(height: 13),
          for (final item in items)
            progressRow(
              title: item.name,
              value: '${formatNumber(score(item))}/5',
              subtitle: '${item.count} obserwacji',
              fraction: score(item) / 5,
              color: const Color(0xFFDAA0B4),
            ),
          const SizedBox(height: 8),
          description(
            'Jeden wpis może należeć do kilku kategorii.',
          ),
        ],
      ),
    );
  }

  // 4. OKOLICZNOŚCI AKTYWNOŚCI
  Widget circumstancesSection() {
    final items = contextStats;

    items.sort(
      (a, b) =>
          b.averageAfter.compareTo(a.averageAfter),
    );

    return section(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle(
            'Okoliczności aktywności',
            Icons.place_outlined,
            color: orange,
          ),
          const SizedBox(height: 16),
          toggle(
            values: const ['company', 'place'],
            labels: const [
              'Towarzystwo',
              'Miejsce',
            ],
            selected: selectedContextView,
            onChanged: (value) {
              setState(() {
                selectedContextView = value;
              });
            },
          ),
          const SizedBox(height: 13),
          description(
            'Średnie samopoczucie po aktywności w danych warunkach.',
          ),
          const SizedBox(height: 12),
          for (final item in items)
            progressRow(
              title: item.name,
              value:
                  '${formatNumber(item.averageAfter)}/5',
              subtitle:
                  '${item.count} obserwacji · przed: ${formatNumber(item.averageBefore)}/5',
              fraction: item.averageAfter / 5,
              color: const Color(0xFFDAA0B4),
            ),
        ],
      ),
    );
  }

  // Szczegółowe statystyki konkretnej aktywności
  Widget detailValue(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: mutedText,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void showDetails(ActivityStats stats) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: FractionallySizedBox(
            heightFactor: 0.85,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                20, 20, 20, 30,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          stats.name,
                          style: const TextStyle(
                            color: textColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(sheetContext);
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  Text(
                    '${stats.count} obserwacji',
                    style: const TextStyle(
                      color: mutedText,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 18),

                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.8,
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    children: [
                      detailValue(
                        'Średnia przyjemność',
                        '${formatNumber(stats.averagePleasure)}/5',
                      ),
                      detailValue(
                        'Samopoczucie przed',
                        '${formatNumber(stats.averageBefore)}/5',
                      ),
                      detailValue(
                        'Samopoczucie po',
                        '${formatNumber(stats.averageAfter)}/5',
                      ),
                      detailValue(
                        'Średnia zmiana',
                        formatChange(stats.averageChange),
                      ),
                      detailValue(
                        'Mediana zmiany',
                        formatChange(stats.medianChange),
                      ),
                      detailValue(
                        'Częstość poprawy',
                        '${formatNumber(stats.improvementRate)}%',
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    'Rozkład zmian samopoczucia',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  progressRow(
                    title: 'Poprawa',
                    value: '${stats.improvements}',
                    subtitle:
                        '${stats.improvements} z ${stats.count} wpisów',
                    fraction: stats.improvements / stats.count,
                    color: const Color(0xFF91B99A),
                  ),

                  progressRow(
                    title: 'Bez zmian',
                    value: '${stats.unchanged}',
                    subtitle:
                        '${stats.unchanged} z ${stats.count} wpisów',
                    fraction: stats.unchanged / stats.count,
                    color: const Color(0xFFB8A8AD),
                  ),

                  progressRow(
                    title: 'Pogorszenie',
                    value: '${stats.worsening}',
                    subtitle:
                        '${stats.worsening} z ${stats.count} wpisów',
                    fraction: stats.worsening / stats.count,
                    color: orange,
                  ),

                  const SizedBox(height: 12),
                  description(
                    'Wyniki przedstawiają zaobserwowane '
                    'zależności, a nie dowód wpływu przyczynowego.',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasRecords = filteredRecords.isNotEmpty;

    return Container(
      color: background,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            20, 16, 20, 28,
          ),
          children: [
            periodSelector(),
            const SizedBox(height: 18),
            summaryCard(),
            const SizedBox(height: 16),

            if (!hasRecords)
              section(
                const Column(
                  children: [
                    Icon(
                      Icons.bar_chart_rounded,
                      size: 42,
                      color: pink,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Brak danych w wybranym okresie',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Wybierz inny okres.',
                      style: TextStyle(
                        color: mutedText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              favoritesSection(),
              const SizedBox(height: 16),

              moodSection(),
              const SizedBox(height: 16),

              categoriesSection(),
              const SizedBox(height: 16),

              circumstancesSection(),
              const SizedBox(height: 18),

              const Text(
                'Wyniki przedstawiają zaobserwowane '
                'zależności, a nie dowód wpływu przyczynowego.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: mutedText,
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
