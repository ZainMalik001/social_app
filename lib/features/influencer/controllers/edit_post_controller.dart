import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rubu/core/models/post_model.dart';
import 'package:rubu/features/influencer/services/api.dart';
import 'package:rubu/features/influencer/services/firestore.dart';
import 'package:rubu/features/influencer/services/storage.dart';

import '../../../injection_handler.dart';
import '../../home/controllers/home_controller.dart';
import '../screens/utils/loader.dart';

class EditPostController extends GetxController {
  final _args = Get.arguments as PostModel;

  File? _postImage;
  final _postPicker = ImagePicker();
  final _postCropper = ImageCropper();
  List _productData = <dynamic>[];

  late TextEditingController _descriptionController;
  late InfluencerFirestoreService _firestoreService;
  late InfluencerStorageService _storageService;
  late InfluencerApiService _apiService;

  String get postImageURL => _args.imageURL;
  File? get postImage => _postImage;
  TextEditingController get descriptionController => _descriptionController;
  List get productData => _productData;
  bool get isComplete =>
      _postImage != null ||
      (_descriptionController.text.isNotEmpty && _args.caption != _descriptionController.text.trim()) ||
      (_productData.isNotEmpty &&
          _productData.every((e) =>
              e.runtimeType != TextEditingController &&
              !const DeepCollectionEquality().equals(_productData, _args.productModel.map((e) => e.toMap()).toList())));

  @override
  void onInit() {
    _descriptionController = TextEditingController(text: _args.caption);
    _productData = _args.productModel.map((e) => e.toMap()).toList();
    _firestoreService = sl.get<InfluencerFirestoreService>();
    _storageService = sl.get<InfluencerStorageService>();
    _apiService = sl.get<InfluencerApiService>();
    super.onInit();
  }

  void tagAnotherProduct() {
    if (_productData.last is Map) {
      // _productData.add(TextEditingController());
      _productData = [..._productData, TextEditingController()];
      update();
    }
  }

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

  void addProduct(int index, String url) {
    if (!GetUtils.isURL(url)) return;
    Get.toNamed('/addProduct', arguments: {'url': url, 'index': index});
  }

  void removeController(int index) {
    _productData.removeAt(index);
    update();
  }

  void updatePost() async {
    if (_descriptionController.text.trim().isEmpty) return;

    LoaderDialog.show('Updating your post...');

    final List<String> hosts = Get.find<HomeController>()
        .partnerBrands
        .map((e) => Uri.parse(e.website).host.replaceAll(RegExp(r'www.'), ''))
        .toList();

    for (int i = 0; i < _productData.length; i++) {
      if (!_productData[i].containsKey('affiliate_link')) {
        if (hosts.any((e) => productData[i]['url'].contains(e))) {
          final rubuUrl = await _apiService.createRubuUrl(_productData[i]['url']);
          _productData[i]['rubu_url'] = rubuUrl;
        } else {
          _productData[i]['rubu_url'] = _productData[i]['url'];
        }
      }
    }

    final mediaURLs =
        await _storageService.updatePostImages(_args.postID, _postImage, _productData.map((e) => e['image']).toList());

    final data = await _firestoreService.updateEditedPost(
        _args.postID, _descriptionController.text.trim(), _productData, mediaURLs);

    await _firestoreService.addLonelyProducts(data['lonely_products']!);

    Get.back();
    await Future.delayed(const Duration(milliseconds: 500));

    Get
      ..back()
      ..back();
  }
}
