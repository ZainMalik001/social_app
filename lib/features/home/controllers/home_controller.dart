import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rubu/core/controllers/auth_controller.dart';
import 'package:rubu/core/models/influencer_model.dart';
import 'package:rubu/core/models/post_model.dart';
import 'package:rubu/features/auth/services/auth_service.dart';
import 'package:rubu/features/feed/screens/utils/delete_dialog.dart';
import 'package:rubu/injection_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/models/partner_brands_model.dart';
import '../../../core/models/user_influencer_model.dart';
import '../../../core/services/deeplinks.dart';
import '../../../core/services/firestore.dart';
import '../../../core/services/local_notifications.dart';

class HomeController extends GetxController {
  int _index = 0;
  bool _isLoading = true,
      _noPosts = false,
      _loadingFavoritePosts = true,
      _loadingInterestProducts = true,
      _loadingMore = false,
      _endOfPosts = false;
  final ScrollController _feedScrollController = ScrollController();

  late QueryDocumentSnapshot _lastPost;
  late QuerySnapshot<Map<String, dynamic>> _postDocs;
  late List<PostModel> _posts, _userInfluencerPosts, _favoritePosts;
  late List<ProductModel> _interestProducts;
  late List<String> _likedPostsIDs, _favoritePostsIDs;
  late UserInfluencerModel _user;
  late List<InfluencerModel> _discoverInfluencers;
  late List<PartnerBrandsModel> _partnerBrands;

  int get index => _index;
  bool get noPosts => _noPosts;
  bool get isLoggedIn => Get.find<AuthController>().isLoggedIn;
  bool get isLoading => _isLoading;
  bool get endOfPosts => _endOfPosts;
  bool get loadingFavoritePosts => _loadingFavoritePosts;
  bool get loadingInterestProducts => _loadingInterestProducts;
  List<String> get likedPostsIDs => _likedPostsIDs;
  List<String> get favoritePostsIDs => _favoritePostsIDs;
  List<PostModel> get posts => _posts;
  // List<PostModel> get likedPosts => _likedPosts;
  List<PostModel> get favoritePosts => _favoritePosts;
  List<PostModel> get userInfluencerPosts => _userInfluencerPosts;
  List<ProductModel> get interestProducts => _interestProducts;
  UserInfluencerModel get user => _user;
  List<InfluencerModel> get discoverInfluencers => _discoverInfluencers;
  ScrollController get feedScrollController => _feedScrollController;
  List<PartnerBrandsModel> get partnerBrands => _partnerBrands;

  late AuthService _authService;
  late CoreFirestoreService _firestoreService;
  late NotificationsInitialization _notificationsInitialization;
  late ReminderNotification _reminderNotification;
  late GetStorage _storage;

  // void setReachedBottom(int index, bool val) {
  //   _reachedBottom[index] = val;
  //   update();
  // }

  @override
  void onInit() {
    _authService = sl.get<AuthService>();
    _firestoreService = sl.get<CoreFirestoreService>();
    _notificationsInitialization = sl.get<NotificationsInitialization>();
    _reminderNotification = sl.get<ReminderNotification>();
    _storage = sl.get<GetStorage>();
    // _feedScrollController = ItemScrollController();
    // _feedScrollListener = ScrollOffsetListener.create();
    super.onInit();
  }

  @override
  void onReady() {
    fetchData();
    _initializeNotifications();
    _feedScrollController.addListener(() async {
      if (_feedScrollController.hasClients) {
        if (!_loadingMore && !_endOfPosts) {
          if (_feedScrollController.position.pixels >=
              _feedScrollController.position.maxScrollExtent - (3 * Get.height)) {
            _loadingMore = true;
            _postDocs = await _firestoreService.fetchPostDocs(_lastPost);

            if (_postDocs.docs.length < 30) {
              _endOfPosts = true;
            } else if (_postDocs.docs.isEmpty) {
              _endOfPosts = true;
              update();
              return;
            }

            _lastPost = _postDocs.docs.last;

            _posts.addAll(await _firestoreService.processPosts(_postDocs));
            update();

            _loadingMore = false;
          }
        }
      }
    });
    _getPartnerBrands();
    _checkEmailVerification();
    super.onReady();
  }

  void _checkEmailVerification() async {
    if (isLoggedIn) {
      if (!_authService.currentUser!.emailVerified) {
        Get.toNamed('/verifyEmail');
      }
    }
  }

  void _initializeNotifications() async {
    await _notificationsInitialization.initialize();
    await _reminderNotification.schedule();
  }

  void onTap(int i) async {
    if (_index == i && i != 4) {
      late int key;
      if (!user.isInfluencer && i > 1) {
        key = i + 2;
      } else {
        key = i + 1;
      }
      if (!(Get.nestedKey(key)?.currentState?.canPop() ?? false)) return;
      while (true) {
        if (Get.nestedKey(key)!.currentState!.canPop()) {
          Get.back(id: key);
        } else {
          break;
        }
      }
      update();
    }

    if (i == _index && i != 4) return;

    if (isLoggedIn && _user.isInfluencer) {
      if (i == 2) {
        Get.toNamed("/addPost");
        return;
      }
    }
    if (_index == 4 && i == 4) {
      Get.toNamed('/settings');
      return;
    }
    _index = i;

    update();
  }

  void _getPartnerBrands() async {
    _partnerBrands = await _firestoreService.getPartnerBrands();
    update();
  }

  Future<void> fetchData([bool reload = true]) async {
    if (reload) {
      _isLoading = _loadingFavoritePosts = true;
      update();
    }

    if (isLoggedIn) {
      _user = await _firestoreService.fetchUser(_authService.currentUser!.uid);
    }
    _postDocs = await _firestoreService.fetchPostDocs();
    if (_postDocs.docs.isNotEmpty) {
      _lastPost = _postDocs.docs.last;
    }

    _posts = await _firestoreService.processPosts(_postDocs);
    // _postsScrollController = List.generate(_posts.length, (index) => ScrollController());
    // _reachedBottom = List.generate(_posts.length, (index) => false);
    if (isLoggedIn) {
      _likedPostsIDs = await _firestoreService.fetchLikedPostIDs(_authService.currentUser!.uid);
      _favoritePostsIDs = await _firestoreService.fetchFavoritePostIDs(_authService.currentUser!.uid);

      _interestProducts = await _firestoreService.fetchInterestProducts();
    } else {
      _likedPostsIDs = [];
      _favoritePostsIDs = [];
      _interestProducts = [];
    }

    if (reload) {
      _loadingInterestProducts = false;
      update();
    }

    _discoverInfluencers = await _firestoreService.fetchInfluencers();

    if (isLoggedIn) {
      if (_storage.read('prev_status-\${_user.id}') == 'in_review') {
        if (_user.accountStatus == 'influencer') {
          Get.toNamed('/congratsScreen');
        }
        // if (_user.accountStatus == 'normal') {
        //   Get.toNamed('/sadScreen');
        // }
      }

      _storage.write('prev_status-\${_user.id}', _user.accountStatus);
    }

    // _testFunc(_posts);
    await DeepLinkService.handleDynamicLinks();

    if (isLoggedIn && _user.isInfluencer) {
      _userInfluencerPosts = await _firestoreService.fetchUserInfluencerPosts(_authService.currentUser!.uid);
    } else {
      _userInfluencerPosts = [];
    }

    if (_posts.isEmpty) {
      _noPosts = true;
      update();
      return;
    }

    if (reload) {
      _isLoading = false;
      update();
    }

    if (isLoggedIn && _favoritePostsIDs.isNotEmpty) {
      _favoritePosts = await _firestoreService.fetchFavoritePosts(_favoritePostsIDs);
    } else {
      _favoritePosts = [];
    }

    if (reload) {
      _loadingFavoritePosts = false;
      update();
    }
  }

  Future<void> pullToRefresh() async {
    await fetchData(false);
  }

  void toInfluencerProfile(int? id, String influencerID) {
    Get.toNamed(
      "/influencerProfile",
      arguments: {
        'id': id,
        'influencerID': influencerID,
      },
      id: id,
    );
    update();
  }

  void toLikedDetailScreen() {
    Get.toNamed(
      '/likedDetail',
      arguments: {
        'favoritePosts': _favoritePosts,
        'likedPostsIDs': _likedPostsIDs,
      },
      id: 4,
    );
    update();
  }

  void toAccountFeedScreen() {
    Get.toNamed(
      '/influencerAccountFeed',
      arguments: {
        'influencerName': _user.fullname,
        'posts': _userInfluencerPosts,
        'likedPosts': _likedPostsIDs,
      },
      id: 5,
    );
    update();
  }

  Future<void> togglePostLike(String postID, bool isLiked) async {
    if (isLoggedIn) {
      try {
        if (isLiked) {
          _likedPostsIDs.remove(postID);
        } else {
          _likedPostsIDs.add(postID);
        }
        update();

        await _firestoreService.updateLikedPosts(postID, _authService.currentUser!.uid, isLiked);

        update();
      } catch (e) {
        if (_likedPostsIDs.contains(postID)) {
          _likedPostsIDs.remove(postID);
        } else {
          _likedPostsIDs.add(postID);
        }
        update();
      }
    } else {
      Get.toNamed('/loginDialog', arguments: {'isDialog': true});
    }
  }

  Future<void> togglePostFavorite(String postID, bool isFavorite) async {
    if (isLoggedIn) {
      try {
        _loadingFavoritePosts = true;
        update();
        if (isFavorite) {
          _favoritePostsIDs.remove(postID);
        } else {
          _favoritePostsIDs.add(postID);
        }
        update();

        await _firestoreService.updateFavoritePosts(postID, _authService.currentUser!.uid, isFavorite);

        if (isFavorite) {
          _favoritePosts.removeWhere((e) => e.postID == postID);
        } else {
          final favoritePost = await _firestoreService.fetchPost(postID);

          _favoritePosts = [favoritePost, ..._favoritePosts];
        }

        _loadingFavoritePosts = false;
        update();
      } catch (e) {
        if (_favoritePostsIDs.contains(postID)) {
          _favoritePostsIDs.remove(postID);
        } else {
          _favoritePostsIDs.add(postID);
        }

        _loadingFavoritePosts = false;
        update();
      }
    } else {
      Get.toNamed('/loginDialog', arguments: {'isDialog': true});
    }
  }

  void convertUserToInfluencer(UserInfluencerModel model) {
    _user = model;
    update();
  }

  void sharePost(String postID) async {
    final link = await FirebaseDynamicLinks.instance.buildShortLink(
      DynamicLinkParameters(
        link: Uri.parse('https://link.naaz.io/p/$postID'),
        uriPrefix: 'https://link.naaz.io/p',
        androidParameters: const AndroidParameters(packageName: 'io.naaz.app'),
        iosParameters: const IOSParameters(bundleId: 'io.naaz.app', appStoreId: '6451436345'),
      ),
    );

    Share.share("Check out this post: ${link.shortUrl}", subject: "Check out this post: ${link.shortUrl}");
  }

  void shareInfluencer(String influencerID) async {
    final link = await FirebaseDynamicLinks.instance.buildShortLink(
      DynamicLinkParameters(
        link: Uri.parse('https://link.naaz.io/u/$influencerID'),
        uriPrefix: 'https://link.naaz.io/u',
        androidParameters: const AndroidParameters(packageName: 'io.naaz.app'),
        iosParameters: const IOSParameters(bundleId: 'io.naaz.app', appStoreId: '6451436345'),
      ),
    );

    Share.share("Check out my profile: ${link.shortUrl}", subject: "Check out my profile: ${link.shortUrl}");
  }

  // void _testFunc(List<PostModel> posts) async {
  //   for (var post in posts) {
  //     final link = await FirebaseDynamicLinks.instance.buildShortLink(
  //       DynamicLinkParameters(
  //         link: Uri.parse('https://app.naaz.io/u/\${post.influencerID}'),
  //         uriPrefix: 'https://app.naaz.io/u',
  //         androidParameters: const AndroidParameters(packageName: 'app.rubu'),
  //         iosParameters: const IOSParameters(bundleId: 'app.rubu', appStoreId: '6448866030'),
  //       ),
  //     );

  //     print(link.shortUrl.toString());
  //   }
  // }

  void addNewPost(PostModel post) {
    _posts.insert(0, post);
    update();
  }

  void updateName(String val) {
    _user.fullname = val;
    update();
  }

  void updateEmail(String val) {
    _user.email = val;
    update();
  }

  void updateImageURLs(Map<String, String?> val) {
    if (val['profile_img_url'] != null) {
      _user.profileImageURL = val['profile_img_url'];
    }
    if (val['cover_img_url'] != null) {
      _user.coverImageURL = val['cover_img_url'];
    }
    update();
  }

  void updateDescription(String description) {
    _user.profileDescription = description;
    update();
  }

  void updateCountry(String country) {
    _user.country = country;
    update();
  }

  void deletePost(String postID) async {
    Get.back();
    await Future.delayed(const Duration(milliseconds: 300));
    DeletingDialog.show();

    final deleted = await _firestoreService.deletePost(postID);
    if (deleted) {
      _posts.removeWhere((e) => e.postID == postID);
    }

    update();
    Get.back();
  }
}
