import 'package:get/get.dart';
import 'package:rubu/core/models/post_model.dart';
import 'package:rubu/features/feed/models/influencer_profile_model.dart';
import 'package:rubu/features/feed/services/firestore.dart';
import 'package:rubu/features/home/controllers/home_controller.dart';

import '../../../injection_handler.dart';

class InfluencerProfileController extends GetxController {
  final _args = Get.arguments;

  bool _isLoading = true;

  int? get id => _args['id'];
  bool get loading => _isLoading;
  InfluencerProfileModel get profile => _influencerProfileModel;
  List<ProductModel> get influencerLatestUniqueProducts => _influencerLatestProducts;

  late InfluencerProfileModel _influencerProfileModel;
  late List<ProductModel> _influencerLatestProducts;
  late FeedFirestoreService _feedFirestoreService;

  @override
  void onInit() {
    _feedFirestoreService = sl.get<FeedFirestoreService>();
    super.onInit();
  }

  @override
  void onReady() {
    _fetchCompleteInfluencerData();
    super.onReady();
  }

  void _fetchCompleteInfluencerData() async {
    _influencerProfileModel = await _feedFirestoreService.fetchInfluencerProfile(_args['influencerID']);

    _influencerLatestProducts = await _feedFirestoreService.fetchAllInfluencerProducts(_args['influencerID']);

    _isLoading = false;
    update();
  }

  void toCollectionScreen(int? id, String category) {
    Get.toNamed(
      "/collection",
      arguments: {
        'influencerModel': _influencerProfileModel,
        'category': category,
      },
      id: id,
    );
  }

  @override
  void onClose() {
    Get.find<HomeController>().update();
    super.onClose();
  }
}
