import 'package:activity_app/enums/activity_category.dart';
import 'package:activity_app/enums/activity_emotion.dart';
import 'package:activity_app/enums/company_type.dart';
import 'package:activity_app/enums/location_type.dart';
import 'package:activity_app/models/activity_entry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Serializes ActivityCreate fields and converts a local date to UTC', () {
    final localDate = DateTime(2025, 10, 5, 18, 30);

    for (final location in LocationType.values) {
      for (final company in CompanyType.values) {
        final entry = ActivityEntry(
          id: 12,
          activityName: ' Spacer ',
          date: localDate,
          categories: {ActivityCategory.physicalActivity},
          locationType: location,
          companyType: company,
          moodBefore: 2,
          moodAfter: 4,
          rating: 5,
          emotions: {ActivityEmotion.calm, ActivityEmotion.joy},
          likes: 'Świeże powietrze',
        );

        expect(entry.toCreateJson(), {
          'activityName': 'Spacer',
          'date': localDate.toUtc().toIso8601String(),
          'categories': ['physical_activity'],
          'locationType': ['indoor', 'outdoor', 'mixed'][location.index],
          'companyType': ['alone', 'withOthers'][company.index],
          'moodBefore': 2,
          'moodAfter': 4,
          'rating': 5,
          'emotions': ['calm', 'joy'],
          'likes': 'Świeże powietrze',
          'dislikes': null,
          'notes': null,
        });
      }
    }
  });
}
