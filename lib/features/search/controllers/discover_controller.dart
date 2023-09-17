import 'package:get/get.dart';
import 'package:rubu/core/models/post_model.dart';
import 'package:rubu/features/search/services/firestore.dart';

import '../../../injection_handler.dart';
import '../../home/controllers/home_controller.dart';

class DiscoverController extends GetxController {
  final _args = Get.arguments;

  bool _loading = true;

  bool get loading => _loading;
  Map<String, String> get args => _args;
  List<ProductModel> get productList => _productList;

  late List<ProductModel> _productList;
  late SearchFirestoreService _firestoreService;

  @override
  void onInit() {
    _firestoreService = sl.get<SearchFirestoreService>();
    super.onInit();
  }

  @override
  void onReady() {
    _fetchDiscoveryProducts(_args['category']);
    super.onReady();
  }

  void _fetchDiscoveryProducts(String category) async {
    _productList = await _firestoreService.fetchDiscoveryProducts(category);

    _loading = false;
    update();
  }

  @override
  void onClose() {
    Get.find<HomeController>().update();
    super.onClose();
  }
}
