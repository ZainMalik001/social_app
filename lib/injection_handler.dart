// import 'package:dart_airtable/dart_airtable.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:instagram_basic_display_api/instagram_basic_display_api.dart';
import 'package:rubu/core/services/analytics.dart';
import 'package:rubu/core/services/local_notifications.dart';
import 'package:rubu/features/auth/services/auth_service.dart';
import 'package:rubu/core/services/firestore.dart';
import 'package:rubu/features/feed/services/firestore.dart';
import 'package:rubu/features/home/services/firestore.dart';
import 'package:rubu/features/influencer/services/api.dart';
import 'package:rubu/features/influencer/services/firestore.dart';
import 'package:rubu/features/influencer/services/storage.dart';
import 'package:rubu/features/search/services/firestore.dart';
import 'package:rubu/features/settings/services/firestore.dart';
import 'package:rubu/features/settings/services/storage.dart';

import 'features/influencer/services/deeplink.dart';

final sl = GetIt.instance;

class InjectionHandler {
  const InjectionHandler._();

  static Future<void> inject() async {
    sl.registerLazySingleton<Analytics>(() => Analytics());

    sl.registerLazySingleton<AuthService>(() => AuthService());

    sl.registerLazySingleton<CoreFirestoreService>(() => CoreFirestoreService());
    sl.registerLazySingleton<HomeFirestoreService>(() => HomeFirestoreService());
    sl.registerLazySingleton<FeedFirestoreService>(() => FeedFirestoreService());
    sl.registerLazySingleton<SearchFirestoreService>(() => SearchFirestoreService());
    sl.registerLazySingleton<SettingsFirestoreService>(() => SettingsFirestoreService(authService: sl()));
    sl.registerLazySingleton<InfluencerFirestoreService>(() => InfluencerFirestoreService(authService: sl()));

    sl.registerLazySingleton<InfluencerStorageService>(() => InfluencerStorageService(authService: sl()));
    sl.registerLazySingleton<SettingsStorageService>(() => SettingsStorageService(authService: sl()));

    // sl.registerLazySingleton(() => InfluencerDeepLinkService());

    sl.registerLazySingleton(() => InfluencerApiService());

    sl.registerLazySingleton(() => NotificationsInitialization());
    sl.registerLazySingleton(() => ReminderNotification(init: sl()));

    await GetStorage.init();

    sl.registerLazySingleton<GetStorage>(() => GetStorage());

    InstagramBasicDisplayApi.initialize();
  }
}
