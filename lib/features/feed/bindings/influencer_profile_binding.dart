import 'package:get/instance_manager.dart';
import 'package:rubu/features/feed/controllers/influencer_profile_controller.dart';

class InfluencerProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InfluencerProfileController());
  }
}
