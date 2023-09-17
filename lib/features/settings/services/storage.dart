import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../../auth/services/auth_service.dart';

class SettingsStorageService {
  final AuthService _authService;

  SettingsStorageService({required AuthService authService}) : _authService = authService;

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<Map<String, String?>> changeInfluencerImages(File? profileImage, File? coverImage) async {
    String? profileImageURL, coverImageURL;

    if (profileImage != null) {
      final profileRef = _storage.ref('/influencers/${_authService.currentUser!.uid}/profile');
      final uploadProfileImage = await profileRef.putFile(profileImage);
      profileImageURL = await uploadProfileImage.ref.getDownloadURL();
    }

    if (coverImage != null) {
      final coverRef = _storage.ref('/influencers/${_authService.currentUser!.uid}/cover');
      final uploadCoverImage = await coverRef.putFile(coverImage);
      coverImageURL = await uploadCoverImage.ref.getDownloadURL();
    }

    return {
      'profile_img_url': profileImageURL,
      'cover_img_url': coverImageURL,
    };
  }
}
