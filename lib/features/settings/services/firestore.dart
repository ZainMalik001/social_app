import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rubu/features/auth/services/auth_service.dart';

class SettingsFirestoreService {
  final AuthService _authService;

  SettingsFirestoreService({required AuthService authService}) : _authService = authService;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> updateName(String name) async {
    try {
      await _authService.currentUser!.updateDisplayName(name);
      await _firestore.collection('users').doc(_authService.currentUser!.uid).update({'full_name': name});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateEmail(String email) async {
    try {
      await _authService.currentUser!.updateEmail(email);
      await _firestore.collection('users').doc(_authService.currentUser!.uid).update({'email': email});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateCountry(String countryCode) async {
    try {
      await _firestore.collection('users').doc(_authService.currentUser!.uid).update({
        'country': countryCode,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateDescription(String description) async {
    try {
      await _firestore.collection('users').doc(_authService.currentUser!.uid).update({
        'profile_description': description,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateImageURLs(Map<String, String?> imgURLs) async {
    try {
      if (imgURLs['profile_img_url'] != null && imgURLs['cover_img_url'] != null) {
        await _firestore.collection('users').doc(_authService.currentUser!.uid).update({
          'profile_img_url': [
            {'downloadURL': imgURLs['profile_img_url']},
          ],
          'cover_img_url': [
            {'downloadURL': imgURLs['cover_img_url']},
          ],
        });
      } else if (imgURLs['profile_img_url'] != null && imgURLs['cover_img_url'] == null) {
        await _firestore.collection('users').doc(_authService.currentUser!.uid).update({
          'profile_img_url': [
            {'downloadURL': imgURLs['profile_img_url']},
          ],
        });
      } else {
        await _firestore.collection('users').doc(_authService.currentUser!.uid).update({
          'cover_img_url': [
            {'downloadURL': imgURLs['cover_img_url']},
          ],
        });
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updatePassword(String password) async {
    try {
      await _authService.currentUser!.updatePassword(password);
      return true;
    } catch (e) {
      return false;
    }
  }
}
