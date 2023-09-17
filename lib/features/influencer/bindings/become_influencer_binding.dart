import 'package:get/instance_manager.dart';

import '../controllers/become_influencer_controller.dart';

class BecomeInfluencerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BecomeInfluencerController());
  }
}
