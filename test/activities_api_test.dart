import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:activity_app/enums/activity_category.dart';
import 'package:activity_app/enums/activity_emotion.dart';
import 'package:activity_app/enums/company_type.dart';
import 'package:activity_app/enums/location_type.dart';
import 'package:activity_app/models/activity_entry.dart';
import 'package:activity_app/services/activities_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  final entry = ActivityEntry(
    activityName: 'Ćwiczenia',
    date: DateTime.utc(2025, 10, 5, 16, 30),
    categories: {ActivityCategory.physicalActivity},
    locationType: LocationType.indoor,
    companyType: CompanyType.alone,
    moodAfter: 4,
    rating: 5,
    emotions: {ActivityEmotion.joy},
  );

  ActivitiesApi apiWith(MockClientHandler handler) {
    final client = MockClient(handler);
    addTearDown(client.close);
    return ActivitiesApi(
      baseUrl: 'https://backend.example/api/',
      client: client,
      timeout: const Duration(milliseconds: 25),
    );
  }

  Matcher saveError(String message) => isA<ActivitySaveException>().having(
    (error) => error.message,
    'message',
    contains(message),
  );

  test('POSTs UTF-8 ActivityCreate JSON and accepts 201', () async {
    final api = apiWith((request) async {
      expect(request.method, 'POST');
      expect(request.url.toString(), 'https://backend.example/api/activities');
      expect(
        request.headers['content-type'],
        'application/json; charset=utf-8',
      );
      expect(jsonDecode(utf8.decode(request.bodyBytes)), entry.toCreateJson());
      return http.Response('{}', 201);
    });

    await api.createActivity(entry);
  });

  test('Reports validation and unexpected HTTP responses', () async {
    for (final (status, message) in [
      (422, 'odrzucił dane'),
      (500, 'HTTP 500'),
    ]) {
      final api = apiWith((_) async => http.Response('', status));
      await expectLater(api.createActivity(entry), throwsA(saveError(message)));
    }
  });

  test('Reports connection errors', () async {
    final api = apiWith((_) async => throw http.ClientException('offline'));
    await expectLater(
      api.createActivity(entry),
      throwsA(saveError('Błąd połączenia')),
    );
  });

  test('Reports TLS errors', () async {
    final api = apiWith((_) async => throw const HandshakeException());
    await expectLater(
      api.createActivity(entry),
      throwsA(saveError('bezpiecznego połączenia')),
    );
  });

  test('Reports timeout without retrying the POST', () async {
    final pending = Completer<http.Response>();
    var requests = 0;
    final api = apiWith((_) {
      requests++;
      return pending.future;
    });
    await expectLater(
      api.createActivity(entry),
      throwsA(saveError('Upłynął czas oczekiwania')),
    );
    expect(requests, 1);
    pending.complete(http.Response('', 201));
  });

  test('Rejects a missing or invalid API URL', () async {
    for (final baseUrl in ['', 'host:8000', 'http://', 'https://host?s=x']) {
      final api = ActivitiesApi(baseUrl: baseUrl);
      await expectLater(
        api.createActivity(entry),
        throwsA(saveError('API_BASE_URL')),
      );
    }
  });
}
