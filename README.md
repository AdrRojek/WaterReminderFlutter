# Water Reminder Flutter

Rozbudowana wersja aplikacji [WaterReminder](../WaterReminder) (Swift/iOS) w Flutterze.

## Funkcje

- Śledzenie dziennego spożycia wody (cel: 4000 ml)
- Szybkie dodawanie porcji (250 ml, 500 ml, bojler)
- Historia z ostatnich dni i streak
- Powiadomienia co ~50 min (9:00–21:00)
- **Powiadomienie nocne (2:00)** — po kliknięciu aplikacja przelicza pozostałą wodę na równe odstępy 250 ml do końca dnia
- Bojler (2000 ml) i kreatyna
- Nowoczesny, ciemny interfejs z animacjami

## Uruchomienie

```bash
flutter pub get
flutter run
```

## Plan commitów

1. Scaffold projektu Flutter
2. Zależności, struktura katalogów, motyw
3. Modele danych i persystencja (Hive)
4. Logika śledzenia wody i repozytorium
5. Główny ekran (UI)
6. Serwis powiadomień — harmonogram dzienny
7. Powiadomienie nocne + dynamiczne przeliczanie
8. Bojler, historia, kreatyna
9. Ustawienia i streak
10. Szlif UI i README
