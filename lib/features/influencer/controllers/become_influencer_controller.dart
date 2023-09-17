import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_basic_display_api/instagram_basic_display_api.dart';
import 'package:rubu/features/home/controllers/home_controller.dart';
import 'package:rubu/features/influencer/screens/utils/fill_all.dart';
import 'package:rubu/features/influencer/screens/utils/loader.dart';
import 'package:rubu/features/influencer/services/firestore.dart';

import '../../../injection_handler.dart';
import '../services/storage.dart';

class BecomeInfluencerController extends GetxController {
  File? _profileImage, _coverImage;
  // CroppedFile? _croppedProfileImage, _croppedCoverImage;

  final _profilePicker = ImagePicker();
  final _coverPicker = ImagePicker();
  final _profileCropper = ImageCropper();
  final _coverCropper = ImageCropper();
  final _usernameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _instagramController = TextEditingController();
  final _tiktokController = TextEditingController();
  final _snapchatController = TextEditingController();

  File? get profileImage => _profileImage;
  File? get coverImage => _coverImage;
  TextEditingController get usernameController => _usernameController;
  TextEditingController get descriptionController => _descriptionController;
  TextEditingController get instagramController => _instagramController;
  TextEditingController get tiktokController => _tiktokController;
  TextEditingController get snapchatController => _snapchatController;

  late InfluencerStorageService _storageService;
  late InfluencerFirestoreService _firestoreService;

  @override
  void onInit() {
    _storageService = sl.get<InfluencerStorageService>();
    _firestoreService = sl.get<InfluencerFirestoreService>();
    super.onInit();
  }

  Future<void> getProfileFromGallery() async {
    final pickedImage = await _profilePicker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickedImage == null) return;

    final croppedImage = await _profileCropper.cropImage(
      sourcePath: pickedImage.path,
      cropStyle: CropStyle.rectangle,
      compressQuality: 80,
      maxWidth: 180,
      maxHeight: 180,
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

    _profileImage = File(croppedImage.path);

    update();
  }

  Future<void> getCoverFromGallery() async {
    final pickedImage = await _coverPicker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickedImage == null) return;

    final croppedImage = await _coverCropper.cropImage(
      sourcePath: pickedImage.path,
      cropStyle: CropStyle.rectangle,
      maxWidth: 720,
      maxHeight: 288,
      aspectRatio: const CropAspectRatio(ratioX: 5.0, ratioY: 2.0),
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

    _coverImage = File(croppedImage.path);

    update();
  }

  void submitInfluencerRequest() async {
    if (!RegExp(r'^[a-zA-Z0-9][a-zA-Z0-9_.]+[a-zA-Z0-9]$').hasMatch(_usernameController.text.trim())) {
      FillAllDialog.show();
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      FillAllDialog.show();
      return;
    }

    if (_coverImage == null || _profileImage == null) {
      FillAllDialog.show();
      return;
    }

    Get.toNamed('/addSocials');
  }

  Future<void> createProfile() async {
    LoaderDialog.show('Submitting creator request...');

    final mediaURLs = await _storageService.uploadInfluencerImages(_profileImage!, _coverImage!);

    final influencer = await _firestoreService.convertToInfluencer(
      _usernameController.text.trim().toLowerCase(),
      _descriptionController.text.trim(),
      mediaURLs,
    );

    Get.find<HomeController>().convertUserToInfluencer(influencer);

    Get.back();
    await Future.delayed(const Duration(milliseconds: 500));
    Get
      ..back()
      ..offNamed('/successScreen');
  }

  Future<void> continueWithInsta() async {
    await InstagramBasicDisplayApi.askInstagramToken();

    InstagramBasicDisplayApi.broadcastInstagramUserStream?.listen((instagramUser) async {
      final influencer = await _firestoreService.convertToInfluencer(
        instagramUser.name,
        _descriptionController.text.trim(),
        {
          'profile_img_url':
              "https://firebasestorage.googleapis.com/v0/b/naaz-app.appspot.com/o/influencers%2Fempty%2Fdp.jpg?alt=media&token=f4da7169-cde2-4a58-ad55-fde7f03181b6",
          'cover_img_url':
              "https://firebasestorage.googleapis.com/v0/b/naaz-app.appspot.com/o/influencers%2Fempty%2Fcover.jpg?alt=media&token=362ec890-f940-41f8-920f-d0da85e199e5",
        },
      );

      Get.find<HomeController>().convertUserToInfluencer(influencer);

      // Get.back();
      // await Future.delayed(const Duration(milliseconds: 500));
      Get.offNamed('/successScreen');
    });
  }
}
