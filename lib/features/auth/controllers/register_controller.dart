import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rubu/core/constants/firebase_auth_exceptions.dart';

import '../../../injection_handler.dart';
import '../services/auth_service.dart';

class RegisterController extends GetxController {
  late AuthService _authService;

  bool _loading = false, _agreed = false, _obscured = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _phoneController = TextEditingController();

  // String? _gender, _ageGroup;

  bool get loading => _loading;
  bool get agreed => _agreed;
  bool get obscured => _obscured;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get fullNameController => _fullNameController;
  TextEditingController get userNameController => _userNameController;
  TextEditingController get phoneController => _phoneController;

  @override
  void onInit() {
    _authService = sl.get<AuthService>();
    super.onInit();
  }

  void toggleAgreement() {
    _agreed = !_agreed;
    update();
  }

  Future<void> createUserWithEmailPassword() async {
    if (!_emailController.text.trim().isEmail) {
      return;
    }
    if (_passwordController.text.trim().isEmpty) {
      return;
    }
    if (_fullNameController.text.trim().isEmpty) {
      return;
    }

    if (!_agreed) {
      return;
    }

    _loading = true;
    update();

    try {
      await _authService.createUserWithEmailPassword(
        email: _emailController.text,
        password: _passwordController.text,
        fullName: _fullNameController.text,
      );
      Get.back();
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text(
              'This email is already registered',
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

  // void setAgeGroup(String ageGroup) {
  //   _ageGroup = ageGroup;
  // }

  // void setGender(String gender) {
  //   _gender = gender;
  // }
}
