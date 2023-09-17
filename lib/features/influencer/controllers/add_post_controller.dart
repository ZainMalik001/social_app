import 'package:get/get.dart';
import 'package:instagram_basic_display_api/instagram_basic_display_api.dart';
import 'package:instagram_basic_display_api/modules.dart';

class AddPostController extends GetxController {
  bool _instaPostsLoading = true;
  List<MediaItem>? _instagramPosts;
  MediaItem? _selectedPost;

  bool get instaPostsLoading => _instaPostsLoading;
  List<MediaItem>? get instagramPosts => _instagramPosts;
  MediaItem? get selectedPost => _selectedPost;

  @override
  void onReady() {
    _loadInstaPosts();
    super.onReady();
  }

  void _loadInstaPosts() async {
    _instaPostsLoading = true;
    update();

    _instagramPosts =
        await InstagramBasicDisplayApi.getMedias().timeout(const Duration(milliseconds: 5000), onTimeout: () => null);

    _instaPostsLoading = false;
    update();
  }

  void setSelectedPost(MediaItem post) {
    _selectedPost = post;
    update();
  }

  void toCreatePost() {
    Get.toNamed(
      '/createPost',
      arguments: {'post': _selectedPost},
    );
  }

  void loginToInstagram() async {
    await InstagramBasicDisplayApi.askInstagramToken();
    InstagramBasicDisplayApi.broadcastInstagramUserStream?.listen((instagramUser) => _loadInstaPosts());
  }
}
