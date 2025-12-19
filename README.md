# GymBeast

Aplikacja mobilna dla entuzjastów siłowni, pozwalająca na przeglądanie bazy ćwiczeń, ich szczegółów oraz wyszukiwanie. Projekt zrobiony na zaliczenie przedmiotu Programowanie aplikacji mobilnych.

## Wykorzystane API
Aplikacja korzysta z **ExerciseDB** dostępnego na platformie RapidAPI.
- Link: [ExerciseDB API](https://rapidapi.com/justin-wf/api/exercisedb)

## Jak uruchomić

Aby uruchomić projekt na lokalnym środowisku:

1. Pobierz zależności:
   ```bash
   flutter pub get
   ```

2. Uruchom aplikację:
   ```bash
   flutter run
   ```

## Wspierane platformy
- **Android** (Główna platforma docelowa, pełne wsparcie Firebase)
- **iOS** (Wymaga osobnej konfiguracji `GoogleService-Info.plist` dla Firebase)
- Flutter Web / Desktop (Zależnie od konfiguracji pluginów Firebase)

## Firebase & Analytics (Wersja 5.0)

W projekcie zintegrowano usługi Firebase w celu monitorowania stabilności i zaangażowania użytkowników.

### Używane moduły:
- **Firebase Core**: Inicjalizacja usług.
- **Firebase Crashlytics**: Raportowanie błędów w czasie rzeczywistym (obsługa błędów Fluttera i strefy natywnej).
- **Firebase Analytics**: Analiza zachowań użytkowników.

### Logowane zdarzenia (Custom Events):
1. **exercise_list_loaded**
   - Logowany po załadowaniu pierwszej strony listy ćwiczeń.
   - Parametry:
     - `count`: liczba pobranych ćwiczeń.
     - `source`: źródło danych (`api` lub `cache`).
2. **exercise_detail_opened**
   - Logowany przy wejściu na ekran szczegółów ćwiczenia.
   - Parametry:
     - `exercise_id`: ID ćwiczenia.
     - `exercise_name`: nazwa ćwiczenia.
3. **exercise_search_performed**
   - Logowany podczas wpisywania frazy w wyszukiwarce.
   - Parametry:
     - `query_length`: długość zapytania.
     - `results_count`: liczba znalezionych wyników.

## Konfiguracja Firebase (Android)

Aby uruchomić aplikację z pełną funkcjonalnością Firebase oraz korzystać z App Distribution, wykonaj poniższe kroki:

1. **Utwórz projekt w Firebase Console**:
   - Wejdź na [console.firebase.google.com](https://console.firebase.google.com/).
   - Dodaj nowy projekt "GymBeast".

2. **Dodaj aplikację Android**:
   - Kliknij ikonę Androida.
   - Package name: `com.example.gymbeast` (sprawdź w `android/app/build.gradle.kts` jeśli zmieniałeś).

3. **Pobierz plik konfiguracyjny**:
   - Pobierz `google-services.json`.
   - Umieść go w katalogu: `android/app/google-services.json`.

4. **Konfiguracja App Distribution**:
   - W pliku `android/app/build.gradle.kts` znajdź sekcję `firebaseAppDistribution` (wewnątrz `buildTypes { release { ... } }`).
   - Uzupełnij `appId` (znajdziesz go w ustawieniach projektu Firebase).
   - Dodaj testerów w polu `testers` lub skonfiguruj `groups`.

5. **Budowanie i dystrybucja**:
   Aby zbudować wersję release i wysłać do App Distribution (jeśli wtyczka jest skonfigurowana z tokenem CI lub masz zainstalowane Firebase CLI):
   
   ```bash
   cd android
   ./gradlew app:assembleRelease app:appDistributionUpload
   ```
   
   Lub samo zbudowanie APK do ręcznego wrzucenia:
   
   ```bash
   ./gradlew app:assembleRelease
   ```
   Plik wynikowy znajdziesz w `android/app/build/outputs/apk/release/app-release.apk`.
