
import 'package:flutter/material.dart';

// Model pojedynczej rekomendacji
class ActivityRecommendation {
  final int id;
  final String name;
  final String category;
  final String reason;
  final IconData icon;
  final Color iconBackground;

  const ActivityRecommendation({
    required this.id,
    required this.name,
    required this.category,
    required this.reason,
    required this.icon,
    required this.iconBackground,
  });
}

class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  State<RecommendationsScreen> createState() =>
      _RecommendationsScreenState();
}

class _RecommendationsScreenState
    extends State<RecommendationsScreen> {
  static const Color background = Color(0xFFFFF8F8);
  static const Color textColor = Color(0xFF604A50);
  static const Color pink = Color(0xFFD88FA5);
  static const Color pinkDark = Color(0xFFC98098);
  static const Color mutedText = Color(0xFF9B838B);

  // Przykładowe rekomendacje.
  // Później będą pobierane z API backendu.
  final List<ActivityRecommendation> _demoRecommendations = const [
    ActivityRecommendation(
      id: 1,
      name: 'Fotografia przyrodnicza',
      category: 'Kreatywność · Na zewnątrz',
      reason:
          'Spacery często wiązały się u Ciebie z poprawą '
          'samopoczucia, a aktywności kreatywne były '
          'oceniane jako przyjemne. Fotografia przyrodnicza '
          'może połączyć te zainteresowania.',
      icon: Icons.camera_alt_outlined,
      iconBackground: Color(0xFFFBE9DC),
    ),
    ActivityRecommendation(
      id: 2,
      name: 'Joga na świeżym powietrzu',
      category: 'Ruch · Relaks',
      reason:
          'W Twojej przykładowej historii aktywności '
          'wykonywane na zewnątrz często wiązały się '
          'z poprawą samopoczucia. Joga może być nowym '
          'sposobem połączenia ruchu z relaksem.',
      icon: Icons.spa_outlined,
      iconBackground: Color(0xFFEAF2E6),
    ),
    ActivityRecommendation(
      id: 3,
      name: 'Warsztaty ceramiki',
      category: 'Kreatywność · Z innymi',
      reason:
          'W przykładowych danych wysoko oceniasz '
          'przyjemność z rysowania. Warsztaty ceramiki '
          'mogą być okazją do rozwijania podobnych '
          'zainteresowań i wypróbowania czegoś nowego.',
      icon: Icons.palette_outlined,
      iconBackground: Color(0xFFF7E3EB),
    ),
  ];

  List<ActivityRecommendation> _recommendations = [];

  final Set<int> _savedIds = {};
  final Set<int> _expandedIds = {};

  bool _isGenerating = false;

  // Generowanie demonstracyjne - bez LLM.
  Future<void> _generateRecommendations() async {
    setState(() {
      _isGenerating = true;
    });

    // Symulacja czasu oczekiwania na odpowiedź.
    await Future.delayed(
      const Duration(milliseconds: 700),
    );

    if (!mounted) return;

    setState(() {
      _recommendations = List.from(_demoRecommendations);
      _expandedIds.clear();
      _isGenerating = false;
    });
  }

  // Zaznaczanie propozycji jako zapisanej.
  void _toggleSaved(ActivityRecommendation recommendation) {
    final wasSaved = _savedIds.contains(recommendation.id);

    setState(() {
      if (wasSaved) {
        _savedIds.remove(recommendation.id);
      } else {
        _savedIds.add(recommendation.id);
      }
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          wasSaved
              ? 'Usunięto z zapisanych'
              : 'Dodano do listy na później',
        ),
        backgroundColor: textColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Rozwijanie uzasadnienia.
  void _toggleReason(int id) {
    setState(() {
      if (_expandedIds.contains(id)) {
        _expandedIds.remove(id);
      } else {
        _expandedIds.add(id);
      }
    });
  }

  Widget _headerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFF9E4EA),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Text(
            'Znajdź coś dla siebie',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 9),
          const Text(
            'Odkryj trzy aktywności dopasowane '
            'do Twoich doświadczeń.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF93737F),
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 22),

          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: _isGenerating
                  ? null
                  : _generateRecommendations,
              icon: _isGenerating
                  ? const SizedBox(
                      width: 19,
                      height: 19,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.auto_awesome_rounded,
                      size: 20,
                    ),
              label: Text(
                _isGenerating
                    ? 'Generowanie...'
                    : 'Generuj rekomendacje',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: pinkDark,
                foregroundColor: Colors.white,
                disabledBackgroundColor:
                    const Color(0xFFD6A7B7),
                disabledForegroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recommendationCard(
    ActivityRecommendation recommendation,
  ) {
    final isSaved = _savedIds.contains(recommendation.id);
    final isExpanded =
        _expandedIds.contains(recommendation.id);

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
          Row(
            children: [
              Container(
                width: 49,
                height: 49,
                decoration: BoxDecoration(
                  color: recommendation.iconBackground,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  recommendation.icon,
                  size: 24,
                  color: const Color(0xFF996878),
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      recommendation.name,
                      style: const TextStyle(
                        color: textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      recommendation.category,
                      style: const TextStyle(
                        color: mutedText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 5),

              IconButton(
                tooltip: isSaved
                    ? 'Usuń z listy'
                    : 'Zapisz na później',
                onPressed: () =>
                    _toggleSaved(recommendation),
                icon: Icon(
                  isSaved
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: pinkDark,
                  size: 27,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _toggleReason(recommendation.id),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 7,
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Dlaczego ta aktywność?',
                      style: TextStyle(
                        color: pinkDark,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: pinkDark,
                  ),
                ],
              ),
            ),
          ),

          if (isExpanded) ...[
            const SizedBox(height: 9),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                recommendation.reason,
                style: const TextStyle(
                  color: Color(0xFF735C65),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ),
          ],

          if (isSaved) ...[
            const SizedBox(height: 13),
            const Row(
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  color: Color(0xFF779B7B),
                  size: 17,
                ),
                SizedBox(width: 6),
                Text(
                  'Dodano do listy',
                  style: TextStyle(
                    color: Color(0xFF779B7B),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 48,
        horizontal: 22,
      ),
      child: Column(
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            size: 43,
            color: pink.withValues(alpha: 0.75),
          ),
          const SizedBox(height: 13),
          const Text(
            'Twoje propozycje pojawią się tutaj',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Kliknij „Generuj rekomendacje”, '
            'aby odkryć nowe aktywności.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: mutedText,
              fontSize: 13,
              height: 1.4,
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
          padding: const EdgeInsets.fromLTRB(
            20, 20, 20, 30,
          ),
          children: [
            _headerCard(),

            const SizedBox(height: 24),

            if (_recommendations.isEmpty)
              _emptyState()
            else ...[
              const Text(
                'Twoje propozycje',
                style: TextStyle(
                  color: textColor,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              for (final recommendation
                  in _recommendations) ...[
                _recommendationCard(recommendation),
                const SizedBox(height: 13),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
