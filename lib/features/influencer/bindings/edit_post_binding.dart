import 'package:get/instance_manager.dart';

import '../controllers/edit_post_controller.dart';

class EditPostBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(EditPostController());
  }
}
