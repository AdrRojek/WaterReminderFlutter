import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/locale_resolver.dart';
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
    NotificationService.instance.onBoilerAction = () async {
      await repo.useBoiler(repo.settings.portionMl);
    };
    NotificationService.instance.onSnoozeAction = () async {
      await repo.snoozeNextSlot();
    };
    NotificationService.instance.onNightWakeTapped = () async {
      await repo.handleNightWakeUp();
    };
    NotificationService.instance.onDailyReset = () async {
      await repo.ensureDailySchedule(forceDefault: true);
    };

    NotificationService.instance
        .useLocalizations(l10nForSettings(repo.settings));
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
      final response = launchDetails!.notificationResponse;
      final payload = response?.payload;
      final action = response?.actionId;

      if (payload == NotificationService.nightPayload) {
        await repo.handleNightWakeUp();
        handledSpecialLaunch = true;
      } else if (payload == NotificationService.resetPayload) {
        await repo.ensureDailySchedule(forceDefault: true);
        handledSpecialLaunch = true;
      } else if (action == NotificationService.boilerActionId) {
        await repo.useBoiler(repo.settings.portionMl);
      } else if (action == NotificationService.snoozeActionId) {
        await repo.snoozeNextSlot();
        handledSpecialLaunch = true;
      } else if (payload?.startsWith('water_') == true ||
          action == NotificationService.drinkActionId) {
        await repo.addWater(repo.settings.portionMl);
      }
    }

    if (!handledSpecialLaunch) {
      await repo.ensureDailySchedule();
    }
  } catch (e, st) {
    debugPrint('Notifications setup error: $e\n$st');
  }
}
