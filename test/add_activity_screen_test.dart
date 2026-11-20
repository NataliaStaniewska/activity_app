import 'dart:async';
import 'dart:convert';

import 'package:activity_app/services/activities_api.dart';
import 'package:activity_app/screens/add_activity_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  testWidgets('Validates, preserves input on failure, and resets on success', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 1700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final requests = <http.Request>[];
    final pending = Completer<http.Response>();
    final client = MockClient((request) async {
      requests.add(request);
      return requests.length == 1 ? http.Response('', 422) : pending.future;
    });
    addTearDown(client.close);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AddActivityScreen(
            api: ActivitiesApi(
              baseUrl: 'https://backend.example',
              client: client,
            ),
          ),
        ),
      ),
    );

    Future<void> tap(Finder finder) async {
      if (finder.evaluate().isEmpty) {
        await tester.scrollUntilVisible(
          finder,
          300,
          scrollable: find.byType(Scrollable).first,
        );
      }
      if (finder.hitTestable().evaluate().isEmpty) {
        await tester.ensureVisible(finder);
        await tester.pumpAndSettle();
      }
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }

    await tap(find.byType(TextField).first);
    await tap(find.widgetWithText(ListTile, 'Spacer'));
    await tap(find.text('Ruch'));
    await tap(find.text('Z innymi'));
    await tap(find.text('W obu środowiskach'));
    await tap(find.text('4').at(1)); // Mood after.
    await tap(find.text('5').at(2)); // Pleasure.
    await tap(find.text('Zapisz'));

    expect(requests, isEmpty);
    expect(find.text('Wybierz przynajmniej jedną emocję'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await tap(find.text('Radość'));
    await tap(find.text('Spokój'));
    await tap(find.text('Skupienie'));
    await tap(find.text('Zmęczenie'));
    final notes = find.widgetWithText(TextField, 'Notatki');
    await tester.ensureVisible(notes);
    await tester.enterText(notes, '  Krótki spacer  ');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await tap(find.text('Zapisz'));

    expect(find.textContaining('Serwer odrzucił dane'), findsOneWidget);
    expect(requests, hasLength(1));

    final payload = jsonDecode(requests.single.body);
    expect(requests.single.method, 'POST');
    expect(requests.single.url.path, '/activities');
    expect(payload, containsPair('activityName', 'Spacer'));
    expect(payload, containsPair('categories', ['physical_activity']));
    expect(payload, containsPair('companyType', 'withOthers'));
    expect(payload, containsPair('locationType', 'mixed'));
    expect(payload, containsPair('moodBefore', null));
    expect(payload, containsPair('moodAfter', 4));
    expect(payload, containsPair('rating', 5));
    expect(
      payload,
      containsPair('emotions', ['joy', 'calm', 'focus', 'fatigue']),
    );
    expect(payload, containsPair('notes', 'Krótki spacer'));
    expect(DateTime.parse(payload['date'] as String).isUtc, isTrue);

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    final save = find.widgetWithText(ElevatedButton, 'Zapisz');
    await tester.tap(save);
    await tester.pump();
    final spinner = find.byType(CircularProgressIndicator);
    expect(spinner, findsOneWidget);
    final savingButton = find.ancestor(
      of: spinner,
      matching: find.byType(ElevatedButton),
    );
    expect(tester.widget<ElevatedButton>(savingButton).onPressed, isNull);
    await tester.tap(savingButton, warnIfMissed: false);
    expect(requests, hasLength(2));
    expect(requests.last.body, requests.first.body);

    pending.complete(http.Response('{}', 201));
    await tester.pumpAndSettle();

    expect(find.text('Aktywność została zapisana.'), findsOneWidget);
    expect(spinner, findsNothing);
    expect(tester.widget<ElevatedButton>(save).onPressed, isNotNull);
    expect(tester.widget<TextField>(notes).controller!.text, isEmpty);
    expect(find.text('Spacer'), findsNothing);
    expect(
      tester
          .widget<FilterChip>(find.widgetWithText(FilterChip, 'Radość'))
          .selected,
      isFalse,
    );
  });
}
