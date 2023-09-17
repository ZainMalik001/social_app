import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/firebase_auth_exceptions.dart';
import '../services/auth_service.dart';
import '../../../injection_handler.dart';

class LoginController extends GetxController {
  late AuthService _authService;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;

  bool get loading => _loading;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;

  @override
  void onInit() {
    _authService = sl.get<AuthService>();
    super.onInit();
  }

  Future<void> signInWithEmailPassword() async {
    _setLoading(true);
    try {
      await _authService.signInWithEmailPassword(_emailController.text, _passwordController.text);

      Get.back();
      _setLoading(false);
    } on FirebaseAuthException catch (e) {
      if (e.code == FirebaseAuthExceptionCodes.wrongPassword) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text(
              'The password is incorrect',
              style: GoogleFonts.jost(fontSize: 16.0),
            ),
            backgroundColor: Colors.red.shade600,
          ),
        );
      } else if (e.code == FirebaseAuthExceptionCodes.userNotFound) {
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
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text(
              'Error logging in',
              style: GoogleFonts.jost(fontSize: 16.0),
            ),
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
      _setLoading(false);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      await _authService.signInWithProvider(GoogleAuthProvider());
      Get.back();
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  Future<void> signInWithApple() async {
    try {
      await _authService.signInWithProvider(AppleAuthProvider());
      Get.back();
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  void _setLoading(bool state) {
    _loading = state;
    update(['loginButton']);
  }
}
