import 'package:get/instance_manager.dart';
import 'package:rubu/features/auth/controllers/forgot_controller.dart';

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ForgotPasswordController());
  }
}
