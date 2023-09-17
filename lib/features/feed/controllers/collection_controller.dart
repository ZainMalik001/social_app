import 'package:get/get.dart';
import 'package:rubu/features/feed/models/influencer_profile_model.dart';

import '../../../core/models/post_model.dart';
import '../../../injection_handler.dart';
import '../services/firestore.dart';

class CollectionController extends GetxController {
  final _args = Get.arguments;

  bool _loading = true;

  InfluencerProfileModel get influencerData => _args['influencerModel'];
  String get category => _args['category'];
  bool get loading => _loading;
  List<ProductModel> get productList => _productList;

  late List<ProductModel> _productList;
  late FeedFirestoreService _feedFirestoreService;

  @override
  void onInit() {
    _feedFirestoreService = sl.get<FeedFirestoreService>();
    super.onInit();
  }

  @override
  void onReady() {
    _fetchCollectionProducts();
    super.onReady();
  }

  void _fetchCollectionProducts() async {
    _productList = await _feedFirestoreService.fetchCollectionProducts(influencerData.id, category);

    _fetchProductPrimaryImages();
  }

  void _fetchProductPrimaryImages() async {
    _loading = false;
    update();
  }
}
