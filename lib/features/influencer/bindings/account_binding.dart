import 'package:get/get.dart';

import '../controllers/account_controller.dart';

class InfluencerAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InfluencerAccountController());
  }
}
