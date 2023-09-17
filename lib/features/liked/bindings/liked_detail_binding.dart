import 'package:get/instance_manager.dart';

import '../controllers/liked_detail_controller.dart';

class LikedDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LikedDetailController());
  }
}
