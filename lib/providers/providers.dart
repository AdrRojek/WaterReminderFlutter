import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/storage_service.dart';
import '../data/water_repository.dart';
import '../services/notification_service.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService.instance;
});

final waterRepositoryProvider = ChangeNotifierProvider<WaterRepository>((ref) {
  final storage = ref.watch(storageServiceProvider);
  final repo = WaterRepository(storage);

  NotificationService.instance.onDrinkAction = () {
    repo.addWater(repo.settings.portionMl);
  };

  NotificationService.instance.onNightWakeTapped = () async {
    await repo.handleNightWakeUp();
  };

  ref.onDispose(() {
    NotificationService.instance.onDrinkAction = null;
    NotificationService.instance.onNightWakeTapped = null;
  });

  return repo;
});

/// Szybka inicjalizacja — tylko Hive i dane. Używa ref.read, żeby uniknąć
/// nieskończonej pętli przy notifyListeners() z repozytorium.
final initProvider = FutureProvider<void>((ref) async {
  final repo = ref.read(waterRepositoryProvider);
  await repo.initialize();
});

Future<void> setupNotifications(WaterRepository repo) async {
  try {
    await NotificationService.instance.requestPermissions();

    final launchDetails =
        await NotificationService.instance.getLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp == true) {
      final payload = launchDetails!.notificationResponse?.payload;
      if (payload == NotificationService.nightPayload) {
        await repo.handleNightWakeUp();
      } else if (payload?.startsWith('water_') == true ||
          launchDetails.notificationResponse?.actionId == 'DRINK_ACTION') {
        await repo.addWater(repo.settings.portionMl);
      }
    }

    await repo.scheduleDefaultNotifications();
  } catch (e, st) {
    debugPrint('Powiadomienia: błąd konfiguracji: $e\n$st');
  }
}
