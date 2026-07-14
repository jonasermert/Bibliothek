# Bibliothek

Moderne Flutter-Bibliotheksapp mit Open Library, Material 3, Suche, Favoriten, Sternebewertungen und Dark Mode.

## Architektur

- Feature-first Ordnerstruktur
- Riverpod für State Management und Dependency Injection
- Dio für robuste HTTP-Kommunikation
- GoRouter für Navigation
- SharedPreferences für lokale Favoriten
- CachedNetworkImage für Cover-Caching
- flutter_rating_bar für Bewertungen

## Start

```bash
flutter create . --platforms=android,ios,web,macos,windows,linux
flutter pub get
flutter run
```

`flutter create .` ergänzt lediglich die nativen Plattformordner. Der vorhandene `lib`-Ordner bleibt erhalten.

## API

Die App nutzt die öffentliche Open Library Search API ohne API-Key:

- Suche: `https://openlibrary.org/search.json`
- Cover: `https://covers.openlibrary.org/b/id/{coverId}-L.jpg`

## Hinweise

Die angezeigte Verfügbarkeit und Vollständigkeit hängt von den Open-Library-Daten ab. Favoriten werden lokal auf dem Gerät gespeichert.

## Qualitätssicherung

Ein ausführlicher Quellcode-Audit befindet sich in `TEST_REPORT.md`.

```bash
flutter analyze
flutter test
```
