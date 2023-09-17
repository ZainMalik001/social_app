import 'package:get/get.dart';
import 'package:rubu/features/feed/controllers/collection_controller.dart';

class CollectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CollectionController());
  }
}
