import 'package:get/get.dart';
import 'package:rubu/features/influencer/controllers/create_post_controller.dart';

class CreatePostBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CreatePostController());
  }
}
