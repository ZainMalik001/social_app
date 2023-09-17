import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rubu/core/models/post_model.dart';
import 'package:rubu/features/home/controllers/home_controller.dart';

class LikedDetailController extends GetxController {
  final _args = Get.arguments;

  List<PostModel> get posts => _posts;
  List<String> get likedPostsIDs => _likedPostsIDs;

  late List<PostModel> _posts;
  late List<String> _likedPostsIDs;

  @override
  void onInit() {
    _posts = [..._args['favoritePosts']];
    _likedPostsIDs = [..._args['likedPostsIDs']];
    super.onInit();
  }

  void toggleLike(String postID, bool isLiked) async {
    await Get.find<HomeController>().togglePostLike(postID, isLiked);

    _posts.removeWhere((e) => e.postID == postID);

    update();
  }

  void toggleFavorite(String postID, bool isFavorite) async {
    await Get.find<HomeController>().togglePostFavorite(postID, isFavorite);

    _posts.removeWhere((e) => e.postID == postID);

    update();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.addPostFrameCallback((_) => Get.find<HomeController>().update());
    super.onClose();
  }
}
