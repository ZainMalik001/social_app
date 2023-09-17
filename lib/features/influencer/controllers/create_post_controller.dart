import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_basic_display_api/modules.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rubu/core/models/post_model.dart';
import 'package:rubu/features/influencer/screens/utils/loader.dart';
import 'package:rubu/features/influencer/services/api.dart';
// import 'package:rubu/features/influencer/services/deeplink.dart';
import 'package:rubu/features/influencer/services/firestore.dart';
import 'package:rubu/features/influencer/services/storage.dart';

import '../../../injection_handler.dart';
import '../../home/controllers/home_controller.dart';

class CreatePostController extends GetxController {
  final _args = Get.arguments;

  File? _postImage;
  bool _loading = false;

  final _postPicker = ImagePicker();
  final _postCropper = ImageCropper();
  final _descriptionController = TextEditingController();

  // final _listOfProductUrls = <TextEditingController>[];
  final _productData = [];

  File? get postImage => _postImage;
  bool get isComplete =>
      _postImage != null &&
      _descriptionController.text.isNotEmpty &&
      _productData.isNotEmpty &&
      _productData.every((e) => e.runtimeType != TextEditingController);
  bool get isIncomplete => !isComplete;
  bool get loading => _loading;
  // File get productImage => _args['product_img'];
  // String get productTitle => _args['product_title'];
  // String get productURL => _args['product_url'];
  // String get productCategory => _args['product_category'];
  TextEditingController get descriptionController => _descriptionController;
  // List<TextEditingController> get listOfProductUrls => _listOfProductUrls;
  List get productData => _productData;
  MediaItem? get post => _args?['post'];

  late InfluencerFirestoreService _firestoreService;
  late InfluencerStorageService _storageService;
  late InfluencerApiService _apiService;
  // late InfluencerDeepLinkService _deepLinkService;

  @override
  void onInit() {
    if (_args != null && (_args as Map).containsKey('post')) {
      _loading = true;
    }
    _firestoreService = sl.get<InfluencerFirestoreService>();
    _storageService = sl.get<InfluencerStorageService>();
    _apiService = sl.get<InfluencerApiService>();
    // _deepLinkService = sl.get<InfluencerDeepLinkService>();
    super.onInit();
  }

  @override
  void onReady() {
    _cacheImageLocally();
    super.onReady();
  }

  void tagAnotherProduct() {
    _productData.add(TextEditingController());
    update();
  }

  void addProduct(int index, String url) {
    if (!GetUtils.isURL(url)) return;
    Get.toNamed('/addProduct', arguments: {'url': url, 'index': index});
  }

  Future<void> _cacheImageLocally() async {
    // if (post != null) {
    //   final imageDownload = await ImageDownloader.downloadImage(post!.mediaUrl);

    //   if (imageDownload == null) return;

    //   final imagePath = await ImageDownloader.findPath(imageDownload);

    //   if (imagePath == null) return;

    //   _postImage = File(imagePath);
    //   _descriptionController.text = post!.caption;

    //   _loading = false;
    //   update();
    // }
    if (post != null) {
      final response = await get(Uri.parse(post!.mediaUrl));

      // Get temporary directory
      final dir = await getTemporaryDirectory();

      // Create an image name
      var filename =
          '${dir.path}/${DateTime.now().millisecondsSinceEpoch}${post!.mediaUrl.contains(".png") ? ".png" : post!.mediaUrl.contains(".webp") ? ".webp" : ".jpg"}';

      // Save to filesystem
      _postImage = File(filename);
      await _postImage!.writeAsBytes(response.bodyBytes);

      _descriptionController.text = post!.caption;

      _loading = false;
      update();
    }
  }

  void removeController(int index) {
    _productData.removeAt(index);
    update();
  }

  // void loginInsta() async {
  //   await InstagramBasicDisplayApi.askInstagramToken();

  //   _loadInstaPosts();
  // }

  void addPostImage() async {
    final pickedImage = await _postPicker.pickImage(source: ImageSource.gallery);

    if (pickedImage == null) return;

    final croppedImage = await _postCropper.cropImage(
      sourcePath: pickedImage.path,
      cropStyle: CropStyle.rectangle,
      compressQuality: 80,
      maxWidth: 720,
      maxHeight: 720,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      uiSettings: [
        IOSUiSettings(
          aspectRatioLockEnabled: true,
          aspectRatioPickerButtonHidden: true,
        ),
        AndroidUiSettings(
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
      ],
    );

    if (croppedImage == null) return;

    _postImage = File(croppedImage.path);

    update();
  }

  void submitPost() async {
    if (_descriptionController.text.trim().isEmpty) return;
    if (_postImage == null) return;

    LoaderDialog.show('Creating your post...');

    final List<String> hosts = Get.find<HomeController>()
        .partnerBrands
        .map((e) => Uri.parse(e.website).host.replaceAll(RegExp(r'www.'), ''))
        .toList();

    for (int i = 0; i < _productData.length; i++) {
      if (hosts.any((e) => productData[i]['url'].contains(e))) {
        final rubuUrl = await _apiService.createRubuUrl(_productData[i]['url']);
        debugPrint(rubuUrl);
        _productData[i]['rubu_url'] = rubuUrl;
      } else {
        _productData[i]['rubu_url'] = _productData[i]['url'];
      }
    }

    final createdPostID = await _firestoreService.createPost(_descriptionController.text.trim());

    final mediaURLs = await _storageService.uploadPostImages(
        createdPostID, _postImage!, _productData.map<File>((e) => e['image']).toList());

    final data = await _firestoreService.updatePost(createdPostID, _productData, mediaURLs);

    await _firestoreService.addLonelyProducts(data['lonely_products']!);

    List<ProductModel> products = [];
    final controller = Get.find<HomeController>();

    for (int i = 0; i < _productData.length; i++) {
      products.add(
        ProductModel(
          id: data['product_ids']!.where((e) => e['img_url'] == mediaURLs['product_img_urls'][i]).first['id'],
          title: _productData[i]['title'],
          storeLink: _productData[i]['url'],
          rubuLink: _productData[i]['rubu_url'],
          addedAt: DateTime.now().millisecondsSinceEpoch,
          imageUrl: mediaURLs['product_img_urls'][i],
          influencerID: controller.user.id!,
          influencerName: controller.user.fullname!,
          influencerImgUrl: controller.user.profileImageURL!,
          category: _productData[i]['category'],
        ),
      );
    }

    final newPost = PostModel(
      postID: createdPostID,
      caption: _descriptionController.text.trim(),
      createdAt: Timestamp.now(),
      productModel: products,
      imageURL: mediaURLs['post_img_url'],
      influencerID: controller.user.id!,
      influencerName: controller.user.fullname!,
      influencerImgUrl: controller.user.profileImageURL!,
    );

    controller.addNewPost(newPost);

    Get.back();
    await Future.delayed(const Duration(milliseconds: 500));

    Get
      ..back()
      ..back();
  }
}
