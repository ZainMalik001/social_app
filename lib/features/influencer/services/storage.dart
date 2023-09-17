import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:rubu/features/auth/services/auth_service.dart';

class InfluencerStorageService {
  final AuthService _authService;

  InfluencerStorageService({required AuthService authService}) : _authService = authService;

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<Map<String, String>> uploadInfluencerImages(File profileImage, File coverImage) async {
    final profileRef = _storage.ref('/influencers/${_authService.currentUser!.uid}/profile');
    final coverRef = _storage.ref('/influencers/${_authService.currentUser!.uid}/cover');

    final uploadProfileImage = await profileRef.putFile(profileImage);
    final uploadCoverImage = await coverRef.putFile(coverImage);

    final profileImageURL = await uploadProfileImage.ref.getDownloadURL();
    final coverImageURL = await uploadCoverImage.ref.getDownloadURL();

    return {
      'profile_img_url': profileImageURL,
      'cover_img_url': coverImageURL,
    };
  }

  Future<Map<String, dynamic>> uploadPostImages(String postID, File postImage, List<File> productImage) async {
    List<String> productImageUrls = [];

    final postRef = _storage.ref('/posts/$postID');

    for (int i = 0; i < productImage.length; i++) {
      final productRef = _storage.ref('/products/$postID/${i + 1}');
      final uploadProductImage = await productRef.putFile(productImage[i]);
      productImageUrls.add(await uploadProductImage.ref.getDownloadURL());
    }

    final uploadPostImage = await postRef.putFile(postImage);

    final postDownloadURL = await uploadPostImage.ref.getDownloadURL();

    return {
      'product_img_urls': productImageUrls,
      'post_img_url': postDownloadURL,
    };
  }

  Future<Map<String, dynamic>> updatePostImages(String postID, File? postImage, List productImage) async {
    List<String> productImageUrls = [];
    String? postDownloadURL;

    final postRef = _storage.ref('/posts/$postID');

    for (int i = 0; i < productImage.length; i++) {
      if (productImage[i] is File) {
        final productRef = _storage.ref('/products/$postID/${i + 1}');
        final uploadProductImage = await productRef.putFile(productImage[i]);
        productImageUrls.add(await uploadProductImage.ref.getDownloadURL());
      } else {
        productImageUrls.add(productImage[i]);
      }
    }

    if (postImage != null) {
      final uploadPostImage = await postRef.putFile(postImage);
      postDownloadURL = await uploadPostImage.ref.getDownloadURL();
    }

    return {
      'product_img_urls': productImageUrls,
      'post_img_url': postDownloadURL,
    };
  }
}
