# Prüfbericht

## Behoben

- Ungültiger bedingter Eintrag in `Book.toJson()` korrigiert.
- Den von `flutter create .` erzeugten Standardtest durch einen passenden App-Smoke-Test ersetzt.
- Veraltete `RadioListTile.groupValue`- und `onChanged`-Parameter auf `RadioGroup` umgestellt.
- Analyzer-Hinweise zu mehrfachen Unterstrichen in Callback-Parametern beseitigt.
- Inaktive Seiten des `IndexedStack` über `HeroMode` deaktiviert, damit identische Bücher in mehreren Tabs keine doppelten Hero-Tags erzeugen.
- Modelltests für normales, unvollständiges und lokal serialisiertes Open-Library-Datenmaterial ergänzt.

## Lokal ausführen

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

Optional:

```bash
flutter build apk --debug
flutter build web
```

Hinweis: Das Flutter SDK steht in der Erstellungsumgebung nicht zur Verfügung. Die finale Verifikation mit `flutter analyze` und `flutter test` muss daher lokal erfolgen.
