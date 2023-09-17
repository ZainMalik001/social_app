import 'package:get/get.dart';
import 'package:rubu/core/models/post_model.dart';
import 'package:rubu/features/home/controllers/home_controller.dart';

class InfluencerAccountFeedController extends GetxController {
  final _args = Get.arguments;

  late List<String> _likedPosts;
  late List<PostModel> _posts;

  String get influencerName => _args['influencerName'];
  List<PostModel> get posts => _posts;
  List<String> get likedPosts => _likedPosts;

  @override
  void onInit() {
    _posts = _args['posts'];
    _likedPosts = _args['likedPosts'];
    super.onInit();
  }

  void togglePostLike(String postID, bool isLiked) async {
    if (isLiked) {
      _likedPosts.remove(postID);
    } else {
      _likedPosts.add(postID);
    }
    update();

    await Get.find<HomeController>().togglePostLike(postID, isLiked);
    update();
  }
}
