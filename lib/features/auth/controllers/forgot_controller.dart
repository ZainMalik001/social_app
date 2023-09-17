import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rubu/features/auth/services/auth_service.dart';

import '../../../injection_handler.dart';

class ForgotPasswordController extends GetxController {
  bool _loading = false;

  final _textEditingController = TextEditingController();

  bool get loading => _loading;
  TextEditingController get textEditingController => _textEditingController;

  late AuthService _authService;
  @override
  void onInit() {
    _authService = sl.get<AuthService>();
    super.onInit();
  }

  void sendResetPassEmail() async {
    if (!_textEditingController.text.trim().isEmail) {
      return;
    }

    _loading = true;
    update();

    try {
      await _authService.resetUserPassword(_textEditingController.text.trim());
      Get.back();
      // Get.snackbar('Email sent', 'Reset password email has been sent successfully',
      //     backgroundColor: const Color(0xFFF7ECDD));
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text(
            'Reset password email has been sent successfully',
            style: GoogleFonts.jost(fontSize: 16.0),
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // Get.snackbar('Error', 'This email is not registered', backgroundColor: const Color(0xFFF7ECDD));
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text(
              'This email is not registered',
              style: GoogleFonts.jost(fontSize: 16.0),
            ),
            backgroundColor: Colors.red.shade600,
          ),
        );
      } else {
        // Get.snackbar('Error', 'Unable to send reset password email', backgroundColor: const Color(0xFFF7ECDD));
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text(
              'Unable to send reset password email',
              style: GoogleFonts.jost(fontSize: 16.0),
            ),
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
    }

    _loading = false;
    update();
  }
}
