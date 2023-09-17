import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rubu/core/constants/keys.dart';
import 'package:rubu/core/controllers/auth_controller.dart';
import 'package:rubu/features/auth/services/auth_service.dart';
import 'package:rubu/features/home/controllers/home_controller.dart';
import 'package:rubu/features/settings/services/firestore.dart';
import 'package:rubu/features/settings/services/storage.dart';
import 'package:rubu/injection_handler.dart';

class SettingsController extends FullLifeCycleController with FullLifeCycleMixin {
  late AuthService _authService;

  File? _profileImage;
  final _profilePicker = ImagePicker();
  final _profileCropper = ImageCropper();

  bool _areNotificationsEnabled = false;
  bool _profilePicLoading = false;

  File? get profileImage => _profileImage;
  bool get profilePicLoading => _profilePicLoading;
  bool get areNotificationsEnabled => _areNotificationsEnabled;

  late SettingsStorageService _storageService;
  late SettingsFirestoreService _firestoreService;

  @override
  void onInit() {
    _storageService = sl.get<SettingsStorageService>();
    _firestoreService = sl.get<SettingsFirestoreService>();
    _authService = sl.get<AuthService>();
    _initNotifications();
    super.onInit();
  }

  void toChangeScreen(String property) {
    Get.toNamed(
      '/changeScreen',
      arguments: {
        'property': property,
      },
    );
  }

  void toPartnerBrands() {
    Get.toNamed(
      '/partnerBrands',
      arguments: {
        'brands': Get.find<HomeController>().partnerBrands,
      },
    );
  }

  void signOut() async {
    sl.get<GetStorage>().write(StorageKeys.isAnonymous, false);
    await _authService.signOut();
    Get.find<AuthController>().toggleLogin(false);
    Get.back();
    Get.delete<HomeController>(force: true);
  }

  void _initNotifications() async {
    _areNotificationsEnabled =
        await Permission.notification.isGranted && (await FirebaseMessaging.instance.getToken()) != null;
    update();
  }

  void toggleNotifications([bool? val]) async {
    if (await Permission.notification.status == PermissionStatus.denied) {
      await AppSettings.openAppSettings(type: AppSettingsType.notification);
      return;
    }
    if (val ?? !_areNotificationsEnabled) {
      await FirebaseMessaging.instance.getToken();
    } else {
      await FirebaseMessaging.instance.deleteToken();
    }
    _areNotificationsEnabled = val ?? !_areNotificationsEnabled;
    update();
  }

  Future<void> getProfileFromGallery() async {
    _profilePicLoading = true;
    update();

    final pickedImage = await _profilePicker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickedImage == null) {
      _profilePicLoading = false;
      update();
      return;
    }

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

    if (croppedImage == null) {
      _profilePicLoading = false;
      update();
      return;
    }

    _profileImage = File(croppedImage.path);

    final urls = await _storageService.changeInfluencerImages(_profileImage, null);
    await _firestoreService.updateImageURLs(urls);

    Get.find<HomeController>().updateImageURLs(urls);

    _profileImage = null;
    _profilePicLoading = false;
    update();
  }

  @override
  void onResumed() {
    _initNotifications();
  }

  @override
  void onPaused() {}

  @override
  void onDetached() {}

  @override
  void onInactive() {}
}
