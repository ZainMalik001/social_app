import 'package:get/get.dart';
import 'package:rubu/features/influencer/controllers/account_controller.dart';

class InfluencerAccountFeedBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InfluencerAccountController());
  }
}
