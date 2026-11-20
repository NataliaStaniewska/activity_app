import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/activity_entry.dart';

class ActivitySaveException implements Exception {
  const ActivitySaveException(this.message);

  final String message;
}

class ActivitiesApi {
  const ActivitiesApi({
    this._baseUrl = const String.fromEnvironment('API_BASE_URL'),
    this._client,
    this._timeout = const Duration(seconds: 15),
  });

  final String _baseUrl;
  final http.Client? _client;
  final Duration _timeout;

  Future<void> createActivity(ActivityEntry entry) async {
    final baseUri = Uri.tryParse(_baseUrl.trim());
    if (baseUri == null ||
        (baseUri.scheme != 'http' && baseUri.scheme != 'https') ||
        baseUri.host.isEmpty ||
        baseUri.userInfo.isNotEmpty ||
        baseUri.hasQuery ||
        baseUri.hasFragment) {
      throw const ActivitySaveException(
        'Ustaw poprawny adres API w parametrze API_BASE_URL.',
      );
    }

    final endpoint = baseUri.replace(
      pathSegments: [
        ...baseUri.pathSegments.where((segment) => segment.isNotEmpty),
        'activities',
      ],
    );
    final client = _client ?? http.Client();
    try {
      final response = await client
          .post(
            endpoint,
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
              'Accept': 'application/json',
            },
            body: jsonEncode(entry.toCreateJson()),
          )
          .timeout(_timeout);

      if (response.statusCode == 201) return;
      if (response.statusCode == 422) {
        throw const ActivitySaveException(
          'Serwer odrzucił dane aktywności. Sprawdź pola formularza.',
        );
      }
      throw ActivitySaveException(
        'Serwer nie potwierdził zapisu (HTTP ${response.statusCode}).',
      );
    } on TimeoutException {
      throw const ActivitySaveException(
        'Upłynął czas oczekiwania. Zapis mógł się powieść.',
      );
    } on http.ClientException {
      throw const ActivitySaveException(
        'Błąd połączenia z serwerem. Sprawdź adres API i połączenie.',
      );
    } on TlsException {
      throw const ActivitySaveException(
        'Nie udało się nawiązać bezpiecznego połączenia z serwerem.',
      );
    } finally {
      if (_client == null) client.close();
    }
  }
}
