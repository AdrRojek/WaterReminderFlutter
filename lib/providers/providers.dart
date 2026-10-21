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
  return WaterRepository(storage);
});

final initProvider = FutureProvider<void>((ref) async {
  final repo = ref.read(waterRepositoryProvider);
  try {
    await repo.initialize().timeout(const Duration(seconds: 8));
  } catch (e, st) {
    debugPrint('Init failed, reset storage: $e\n$st');
    try {
      await ref.read(storageServiceProvider).resetAll();
      await repo.initialize().timeout(const Duration(seconds: 5));
    } catch (e2, st2) {
      debugPrint('Init after reset failed: $e2\n$st2');
    }
  }
});

Future<void> setupNotifications(WaterRepository repo) async {
  try {
    NotificationService.instance.onDrinkAction = () async {
      await repo.addWater(repo.settings.portionMl);
    };
    NotificationService.instance.onNightWakeTapped = () async {
      await repo.handleNightWakeUp();
    };
    NotificationService.instance.onDailyReset = () async {
      await repo.ensureDailySchedule(forceDefault: true);
    };

    await NotificationService.instance
        .ensureInitialized()
        .timeout(const Duration(seconds: 8));
    await NotificationService.instance
        .requestPermissions()
        .timeout(const Duration(seconds: 15));

    final launchDetails =
        await NotificationService.instance.getLaunchDetails();
    var handledSpecialLaunch = false;

    if (launchDetails?.didNotificationLaunchApp == true) {
      final payload = launchDetails!.notificationResponse?.payload;
      if (payload == NotificationService.nightPayload) {
        await repo.handleNightWakeUp();
        handledSpecialLaunch = true;
      } else if (payload == NotificationService.resetPayload) {
        await repo.ensureDailySchedule(forceDefault: true);
        handledSpecialLaunch = true;
      } else if (payload?.startsWith('water_') == true ||
          launchDetails.notificationResponse?.actionId == 'DRINK_ACTION') {
        await repo.addWater(repo.settings.portionMl);
      }
    }

    if (!handledSpecialLaunch) {
      // Nowy dzień → 9:00–21:00; ten sam dzień z przeliczeniem → zostaw.
      await repo.ensureDailySchedule();
    }
  } catch (e, st) {
    debugPrint('Powiadomienia: błąd konfiguracji: $e\n$st');
  }
}
