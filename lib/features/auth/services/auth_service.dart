import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/instance_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../core/controllers/auth_controller.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? fullName;

  User? get currentUser => _firebaseAuth.currentUser;

  // Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailPassword(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    Get.find<AuthController>().toggleLogin(currentUser != null);
  }

  Future<void> createUserWithEmailPassword({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final user = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

    if (user.user != null) {
      _firestore.collection('users').doc(user.user!.uid).set({
        "email": email,
        "full_name": fullName,
        "is_influencer": false,
        "created_at": DateTime.now().millisecondsSinceEpoch,
        "id": user.user!.uid,
      });
    }
    Get.find<AuthController>().toggleLogin(currentUser != null);
  }

  Future<void> signInWithProvider(authProvider) async {
    late final UserCredential user;
    if (authProvider.runtimeType == AppleAuthProvider) {
      if (!(await SignInWithApple.isAvailable())) {
        return;
      }
      user = await _signInWithApple();
    } else if (authProvider.runtimeType == GoogleAuthProvider) {
      user = await _signInWithGoogle();
    }

    if (user.user != null) {
      final doc = _firestore.collection('users').doc(user.user!.uid);

      final retreivedDoc = await doc.get();

      if (!retreivedDoc.exists) {
        _firestore.collection('users').doc(user.user!.uid).set({
          "email": user.user!.email,
          "is_influencer": false,
          "full_name": fullName ?? user.user!.displayName ?? user.user!.providerData.first.displayName,
          "created_at": DateTime.now().millisecondsSinceEpoch,
          "id": user.user!.uid,
        });
      }
      Get.find<AuthController>().toggleLogin(currentUser != null);
      fullName = null;
    }
  }

  Future<UserCredential> _signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    return FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> _signInWithApple() async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    final credentials = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final oAuthCreds = OAuthProvider("apple.com").credential(
      idToken: credentials.identityToken,
      rawNonce: rawNonce,
    );

    final userCreds = await FirebaseAuth.instance.signInWithCredential(oAuthCreds);

    if (credentials.email != null) {
      fullName = "${credentials.givenName} ${credentials.familyName}";
      await userCreds.user!.updateDisplayName("${credentials.givenName} ${credentials.familyName}");
      await userCreds.user!.updateEmail("${credentials.email}");
    }

    return userCreds;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> resetUserPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
