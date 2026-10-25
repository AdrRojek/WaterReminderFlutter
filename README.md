# Water Reminder Flutter

Rozbudowana wersja aplikacji [WaterReminder](../WaterReminder) (Swift/iOS) w Flutterze — Android, iOS, macOS.

## Screenshots

<p align="center">
  <img src="docs/screenshots/home.jpg" alt="Home" width="260" />
  &nbsp;
  <img src="docs/screenshots/history.jpg" alt="History" width="260" />
  &nbsp;
  <img src="docs/screenshots/settings.jpg" alt="Settings" width="260" />
</p>

| Home | History | Settings |
|:----:|:-------:|:--------:|
| Progress, catch-up, quick actions | Daily log + creatine tags | Goals, language, adjust, rewards |

## Funkcje

| Funkcja | Opis |
|---------|------|
| Cel dzienny | 4000 ml (konfigurowalne w ustawieniach) |
| Szybkie akcje | +250 ml, +500 ml, bojler, kreatyna |
| Bojler | 2000 ml, śledzenie stanu |
| Streak | Seria dni + auto-amnestia (1×/miesiąc przy ≥50%) |
| Kreatyna | Oznaczenie dzienne (obok bojlera) |
| Historia | Ostatnie 14 dni |
| Powiadomienia | 9:00–21:00 co ~50 min (jak iOS) |
| **Nocne 2:00** | Po kliknięciu przelicza resztę dnia na równe odstępy 250 ml |
| Nagrody | Kosmetyczne odblokowania (osobny ekran w Settings) |

## Powiadomienie nocne

O **2:00** wysyłane jest powiadomienie „Obudziłeś się w nocy?”. Po kliknięciu:

1. Aplikacja się otwiera
2. Obliczana jest pozostała woda do celu (4000 ml − wypite)
3. Czas do **21:00** dzielony jest **równo** na porcje po 250 ml
4. Stary harmonogram jest zastępowany nowym

Przykład: o 2:00 bez wypitej wody → 16 porcji × 250 ml w odstępach ~71 min.

W **Ustawieniach** jest też przycisk testowy „Przelicz harmonogram teraz”.

## Uruchomienie

```bash
flutter pub get
cd ios && pod install && cd ..   # tylko iOS/macOS
flutter run
```

## Architektura

```
lib/
├── core/          # stałe, motyw
├── models/        # WaterDayEntry, BoilerState, ...
├── data/          # StorageService, WaterRepository
├── services/      # NotificationService, ScheduleCalculator
├── providers/     # Riverpod
├── widgets/       # UI components
└── screens/       # Home, Settings
```

## Commity

1. Scaffold Flutter
2. Zależności i motyw
3. Modele + Hive
4. Logika wody + harmonogram
5. Powiadomienia + providery
6. Widgety UI
7. Ekrany
8. Konfiguracja Android/iOS
9. Testy
10. Dokumentacja
