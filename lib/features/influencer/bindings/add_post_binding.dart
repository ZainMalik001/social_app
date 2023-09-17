import 'package:get/instance_manager.dart';
import 'package:rubu/features/influencer/controllers/add_post_controller.dart';

class AddPostBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddPostController());
  }
}
