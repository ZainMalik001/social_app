import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:rubu/core/routes.dart';
// import 'package:rubu/features/auth/services/auth_service.dart';
import 'package:rubu/firebase_options.dart';
import 'package:rubu/injection_handler.dart';
import 'core/services/analytics.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'Rubu',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await InjectionHandler.inject();
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  runApp(const Rubu());
}

class Rubu extends StatelessWidget {
  const Rubu({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rubu',
      getPages: getPages,
      navigatorObservers: [sl.get<Analytics>().observer],
      // home: StreamBuilder(
      //   stream: sl.get<AuthService>().authStateChanges,
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData) return const HomeScreen();
      //     return const WelcomeScreen();
      //   },
      // ),
      home: const SplashScreen(),
    );
  }
}
