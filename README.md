# activity_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Zapis aktywności w lokalnym API

Skonfiguruj bazę i środowisko Pythona według [instrukcji backendu](../activity_app_backend/README.md).
W katalogu `activity_app_backend` uruchom migracje i serwer:

```bash
source .venv/bin/activate
alembic upgrade head
python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

W katalogu `activity_app` uruchom `flutter pub get`, a następnie wybierz polecenie dla urządzenia.
Identyfikator urządzenia znajdziesz przez `flutter devices`.

- Symulator iOS: `flutter run -d "$DEVICE_ID" --dart-define=API_BASE_URL=http://localhost:8000`.
- Standardowy emulator Androida: `flutter run -d "$DEVICE_ID" --dart-define=API_BASE_URL=http://10.0.2.2:8000`.
- Fizyczny iPhone lub Android: połącz telefon i komputer z tą samą siecią. Ustaw zmienną `BACKEND_HOST` na adres LAN komputera. Na iPhonie można użyć także nazwy komputera kończącej się na `.local`. Uruchom `flutter run -d "$DEVICE_ID" --dart-define=API_BASE_URL="http://${BACKEND_HOST}:8000"`. Upewnij się, że zapora komputera dopuszcza połączenia na porcie 8000. Na iPhonie zezwól aplikacji na dostęp do sieci lokalnej, gdy system o to poprosi.

Podaj adres bazowy, bez końcówki `/activities`. Zmiana `API_BASE_URL` wymaga ponownego uruchomienia polecenia `flutter run`. Na Androidzie lokalne połączenia HTTP korzystają z konfiguracji wariantu debug.
