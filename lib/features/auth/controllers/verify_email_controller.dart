import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rubu/features/auth/services/auth_service.dart';

import '../../../core/constants/keys.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../injection_handler.dart';
import '../../home/controllers/home_controller.dart';

class VerifyEmailController extends GetxController {
  late AuthService _authService;
  bool _resent = false;
  bool _verifying = false;

  bool get resent => _resent;
  bool get verifying => _verifying;

  @override
  void onInit() {
    _authService = sl.get<AuthService>();
    super.onInit();
  }

  @override
  void onReady() {
    _authService.currentUser!.sendEmailVerification();
    super.onReady();
  }

  void resendEmail() async {
    await _authService.currentUser!.sendEmailVerification();
    _resent = true;
    update();

    Future.delayed(const Duration(seconds: 30), () {
      _resent = false;
      update();
    });
  }

  void verifyEmail() async {
    _verifying = true;
    update();

    await _authService.currentUser!.reload();

    if (_authService.currentUser!.emailVerified) {
      Get.back();
    } else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text(
            'Email not verified',
            style: GoogleFonts.jost(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red.shade600,
        ),
      );
    }
    _verifying = false;
    update();
  }

  void signOut() async {
    sl.get<GetStorage>().write(StorageKeys.isAnonymous, false);
    await _authService.signOut();
    Get.find<AuthController>().toggleLogin(false);
    Get.back();
    Get.delete<HomeController>(force: true);
  }
}
