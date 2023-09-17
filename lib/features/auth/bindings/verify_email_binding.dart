import 'package:get/instance_manager.dart';
import 'package:rubu/features/auth/controllers/verify_email_controller.dart';

class VerifyEmailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(VerifyEmailController());
  }
}
