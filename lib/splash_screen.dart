import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rubu/core/constants/keys.dart';
import 'package:rubu/core/services/cloud_notifications.dart';
import 'package:rubu/welcome.dart';

import 'core/controllers/auth_controller.dart';
import 'features/home/screens/home_screen.dart';
import 'injection_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool toWelcome = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await CloudNotifications.requestPermissions();
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        toWelcome = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController(), permanent: true);
    if (toWelcome) {
      return GetBuilder<AuthController>(
        builder: (_) {
          if (_.isLoggedIn || (sl.get<GetStorage>().read(StorageKeys.isAnonymous) ?? false)) return const HomeScreen();
          return const WelcomeScreen();
        },
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Image.asset('assets/images/evershop_logo_splash.jpeg'),
        ),
      ),
    );
  }
}
