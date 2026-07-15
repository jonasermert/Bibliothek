# 📚 Bibliothek

Eine moderne Bücher-App für Android & iOS, gebaut mit Flutter und Material 3. Durchsuche Millionen von Büchern über die
Open Library, speichere Favoriten und vergib Sternebewertungen – mit elegantem Dark Mode.

---

## Screenshots

<p float="left">
  <img src="screenshots/Screenshot_1784038340.png" width="22%" />
  <img src="screenshots/Screenshot_1784038344.png" width="22%" />
  <img src="screenshots/Screenshot_1784038361.png" width="22%" />
  <img src="screenshots/Screenshot_1784109956.png" width="22%" />
</p>

---

## Features

- 🔍 **Buchsuche** via Open Library (kein API-Key erforderlich)
- ⭐ **Sternebewertungen** für gespeicherte Bücher
- ❤️ **Favoriten** – lokal gespeichert auf dem Gerät
- 🌙 **Dark Mode** mit Material 3 Design
- 🖼️ **Cover-Caching** für schnelle Ladezeiten

## Architektur

| Bereich               | Technologie        |
|-----------------------|--------------------|
| State Management & DI | Riverpod           |
| Navigation            | GoRouter           |
| HTTP                  | Dio                |
| Lokale Speicherung    | SharedPreferences  |
| Cover-Caching         | CachedNetworkImage |
| Bewertungen           | flutter_rating_bar |

Ordnerstruktur: **Feature-first** (`books`, `favorites`, `settings`)

## Setup

```bash
flutter pub get
flutter run
```

> Falls native Plattformordner fehlen:
> ```bash
> flutter create . --platforms=android,ios,web,macos,windows,linux
> ```
> Der `lib`-Ordner bleibt dabei unverändert erhalten.

## API

Die App nutzt die öffentliche Open Library Search API:

| Endpunkt | URL                                                   |
|----------|-------------------------------------------------------|
| Suche    | `https://openlibrary.org/search.json`                 |
| Cover    | `https://covers.openlibrary.org/b/id/{coverId}-L.jpg` |

## Qualitätssicherung

Einen ausführlichen Code-Audit findest du in [`TEST_REPORT.md`](TEST_REPORT.md).

```bash
flutter analyze
flutter test
```

## Hinweise

Die Verfügbarkeit und Vollständigkeit der Buchdaten hängt von Open Library ab. Favoriten und Bewertungen werden
ausschließlich lokal auf dem Gerät gespeichert.

## Lizenz

Siehe [LICENSE](LICENSE).
