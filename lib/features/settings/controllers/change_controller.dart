import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rubu/features/home/controllers/home_controller.dart';
import 'package:rubu/features/influencer/services/storage.dart';
import 'package:rubu/features/settings/services/storage.dart';

import '../../../injection_handler.dart';
import '../services/firestore.dart';

class ChangeController extends GetxController {
  File? _profileImage, _coverImage;

  bool _loading = false;

  final _profilePicker = ImagePicker();
  final _coverPicker = ImagePicker();
  final _profileCropper = ImageCropper();
  final _coverCropper = ImageCropper();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  // final _oldPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _descriptionController = TextEditingController();

  String userCountry = Get.find<HomeController>().user.country ?? '';
  String selectedCountry = '';

  bool get loading => _loading;
  bool get obscured => _obscured;
  File? get profileImage => _profileImage;
  File? get coverImage => _coverImage;
  TextEditingController get nameController => _nameController;
  TextEditingController get emailController => _emailController;
  // TextEditingController get oldPassController => _oldPassController;
  TextEditingController get newPassController => _newPassController;
  TextEditingController get confirmPassController => _confirmPassController;
  TextEditingController get descriptionController => _descriptionController;

  late bool _obscured;
  late SettingsFirestoreService _firestoreService;
  late SettingsStorageService _storageService;

  @override
  void onInit() {
    _firestoreService = sl.get<SettingsFirestoreService>();
    _storageService = sl.get<SettingsStorageService>();
    super.onInit();
  }

  void updateData() async {
    if (_nameController.text.trim().isEmpty &&
        _emailController.text.trim().isEmpty &&
        _newPassController.text.trim().isEmpty &&
        _confirmPassController.text.trim().isEmpty &&
        _descriptionController.text.trim().isEmpty &&
        selectedCountry.isEmpty &&
        _profileImage == null &&
        _coverImage == null) return;

    _loading = true;
    update();

    if (_nameController.text.trim().isNotEmpty && RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(_nameController.text.trim())) {
      final result = await _firestoreService.updateName(_nameController.text.trim());
      if (result) {
        Get.find<HomeController>().updateName(_nameController.text.trim());
      }
    }

    if (_emailController.text.trim().isNotEmpty && _emailController.text.trim().isEmail) {
      final result = await _firestoreService.updateEmail(_emailController.text.trim());
      if (result) {
        Get.find<HomeController>().updateEmail(_emailController.text.trim());
      }
    }

    if (_newPassController.text.isNotEmpty && _newPassController.text == _confirmPassController.text) {
      await _firestoreService.updatePassword(_newPassController.text);
    }

    if (_descriptionController.text.trim().isNotEmpty) {
      await _firestoreService.updateDescription(_descriptionController.text.trim());
      Get.find<HomeController>().updateDescription(_descriptionController.text.trim());
    }

    if (selectedCountry.isNotEmpty && selectedCountry != userCountry) {
      await _firestoreService.updateCountry(selectedCountry);
      Get.find<HomeController>().updateCountry(selectedCountry);
    }

    if (_profileImage != null || _coverImage != null) {
      final imgURLs = await _storageService.changeInfluencerImages(_profileImage, _coverImage);

      await _firestoreService.updateImageURLs(imgURLs);

      Get.find<HomeController>().updateImageURLs(imgURLs);
    }

    _nameController.clear();
    _emailController.clear();
    _newPassController.clear();
    _confirmPassController.clear();

    Get.focusScope?.unfocus();

    _loading = false;
    update();
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

  void toggleObscure() {
    _obscured = !_obscured;
    update();
  }
}
