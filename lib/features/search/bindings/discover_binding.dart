import 'package:get/get.dart';
import 'package:rubu/features/search/controllers/discover_controller.dart';

class DiscoverBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DiscoverController());
  }
}
