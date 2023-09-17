import 'package:get/get.dart';
import 'package:rubu/core/models/post_model.dart';
import 'package:rubu/features/home/controllers/home_controller.dart';
import 'package:rubu/features/home/services/firestore.dart';
import 'package:rubu/injection_handler.dart';

class ViewPostController extends GetxController {
  final _args = Get.arguments;

  bool _loading = true;

  int? get id => _args['id'];
  bool get loading => _loading;
  bool get isLiked => Get.find<HomeController>().likedPostsIDs.contains(postID);
  bool get isFavorite => Get.find<HomeController>().favoritePostsIDs.contains(postID);
  String get postID => _args['postID'];
  PostModel get post => _post;

  late PostModel _post;
  late HomeFirestoreService _firestoreService;

  @override
  void onInit() {
    _firestoreService = sl.get<HomeFirestoreService>();
    super.onInit();
  }

  @override
  void onReady() {
    _fetchPost();
    super.onReady();
  }

  void _fetchPost() async {
    _post = await _firestoreService.fetchPost(postID);

    _loading = false;
    update();
  }

  // void togglePostFavorite() async {
  //   await Get.find<HomeController>().togglePostFavorite(post.postID, isFavorite);
  //   update();
  // }

  // void togglePostLike() async {
  //   await Get.find<HomeController>().togglePostLike(post.postID, isLiked);
  //   update();
  // }
}
