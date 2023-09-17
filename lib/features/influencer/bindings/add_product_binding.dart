import 'package:get/get.dart';
import 'package:rubu/features/influencer/controllers/add_product_controller.dart';

class AddProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddProductController());
  }
}
