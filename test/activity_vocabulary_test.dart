import 'package:activity_app/enums/activity_category.dart';
import 'package:activity_app/enums/activity_emotion.dart';
import 'package:activity_app/enums/company_type.dart';
import 'package:activity_app/enums/location_type.dart';
import 'package:activity_app/models/activity_entry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Maps every category and emotion to its API ID and Polish label', () {
    const categories = {
      'physical_activity': 'Ruch',
      'relaxation': 'Relaks',
      'creativity': 'Kreatywność',
      'socializing': 'Spotkania',
      'learning': 'Nauka',
      'other': 'Inne',
    };
    const emotions = {
      'joy': 'Radość',
      'calm': 'Spokój',
      'satisfaction': 'Zadowolenie',
      'excitement': 'Ekscytacja',
      'sadness': 'Smutek',
      'anger': 'Złość',
      'anxiety': 'Lęk',
      'frustration': 'Frustracja',
      'indifference': 'Obojętność',
      'focus': 'Skupienie',
      'fatigue': 'Zmęczenie',
    };

    expect(
      ActivityCategory.values.map((value) => (value.apiId, value.label)),
      categories.entries.map((entry) => (entry.key, entry.value)),
    );
    expect(
      ActivityEmotion.values.map((value) => (value.apiId, value.label)),
      emotions.entries.map((entry) => (entry.key, entry.value)),
    );

    final json = ActivityEntry(
      activityName: 'Spacer',
      date: DateTime.utc(2025),
      categories: ActivityCategory.values.toSet(),
      locationType: LocationType.outdoor,
      companyType: CompanyType.alone,
      moodAfter: 4,
      rating: 4,
      emotions: ActivityEmotion.values.toSet(),
    ).toCreateJson();

    expect(json['categories'], categories.keys.toList());
    expect(json['emotions'], emotions.keys.toList());
  });
}
