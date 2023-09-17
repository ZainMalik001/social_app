// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:rubu/features/auth/services/auth_service.dart';
import 'package:rubu/features/home/controllers/home_controller.dart';

import '../../injection_handler.dart';

class AuthController extends GetxController {
  bool get isLoggedIn => _isLoggedIn;

  late AuthService _authService;
  late bool _isLoggedIn;

  @override
  void onInit() {
    _authService = sl.get<AuthService>();
    _isLoggedIn = _authService.currentUser != null;
    super.onInit();
  }

  @override
  void onReady() {
    _listenToAuthChanges();
    super.onReady();
  }

  void _listenToAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _isLoggedIn = user != null;
      if (user != null && Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().fetchData();
      }
      update();
    });
  }

  void toggleLogin(bool state) {
    _isLoggedIn = state;
    update();
  }
}
