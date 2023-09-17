import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/instance_manager.dart';
import 'package:rubu/features/auth/services/auth_service.dart';
import 'package:rubu/features/home/controllers/home_controller.dart';

import '../../../core/models/user_influencer_model.dart';

class InfluencerFirestoreService {
  final AuthService _authService;

  InfluencerFirestoreService({required AuthService authService}) : _authService = authService;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserInfluencerModel> convertToInfluencer(
    String username,
    String description,
    Map<String, String> mediaURLs,
  ) async {
    List<String> listnumber = Get.find<HomeController>().user.fullname!.split(" ");
    List<String> output = [];
    for (int i = 0; i < listnumber.length; i++) {
      if (i != listnumber.length - 1) {
        output.add(listnumber[i].trim().toLowerCase());
      }
      List<String> temp = [listnumber[i].trim().toLowerCase()];
      for (int j = i + 1; j < listnumber.length; j++) {
        temp.add(listnumber[j].trim().toLowerCase());
        output.add((temp.join(' ')));
      }
    }

    await _firestore.collection('users').doc(_authService.currentUser!.uid).update({
      'is_influencer': false,
      'account_status': 'in_review',
      'profile_description': description,
      'user_name': username,
      'profile_img_url': [
        {'downloadURL': mediaURLs['profile_img_url']}
      ],
      'cover_img_url': [
        {'downloadURL': mediaURLs['cover_img_url']}
      ],
      'search_keys': output,
    });

    final data = await _firestore.collection('users').doc(_authService.currentUser!.uid).get();

    return UserInfluencerModel.fromJson(data.data()!);
  }

  Future<String> createPost(String caption) async {
    final controller = Get.find<HomeController>();

    final user = _firestore.collection('users').doc(_authService.currentUser!.uid);

    List<String> listnumber = caption.replaceAll(RegExp('[^A-Za-z0-9& ]'), '').split(" ");
    List<String> output = [];
    for (int i = 0; i < listnumber.length; i++) {
      if (i != listnumber.length - 1) {
        output.add(listnumber[i].trim().toLowerCase());
      }
      List<String> temp = [listnumber[i].trim().toLowerCase()];
      for (int j = i + 1; j < listnumber.length; j++) {
        temp.add(listnumber[j].trim().toLowerCase());
        output.add((temp.join(' ')));
      }
    }

    final docRef = await _firestore.collection('posts').add(
      {
        'caption': caption,
        'created_at': FieldValue.serverTimestamp(),
        'user_id': user,
        'influencer_id': _authService.currentUser!.uid,
        'influencer_name': controller.user.fullname,
        'influencer_img_url': [
          {'downloadURL': controller.user.profileImageURL}
        ],
        'search_keys': output,
      },
    );

    // await docRef.update({'id': docRef.id});

    return docRef.id;
  }

  Future<Map<String, List<Map<String, dynamic>>>> updatePost(
      String postID, List productData, Map<String, dynamic> mediaURLs) async {
    final controller = Get.find<HomeController>();
    final productRefList = <DocumentReference<Map<String, dynamic>>>[];
    final lonelyProducts = <Map<String, dynamic>>[];
    final productIDsWithImageURLs = <Map<String, dynamic>>[];

    final user = _firestore.collection('users').doc(_authService.currentUser!.uid);

    for (var i = 0; i < productData.length; i++) {
      List<String> listnumber = productData[i]['title'].replaceAll(RegExp('[^A-Za-z0-9& ]'), '').split(" ");
      List<String> output = [];
      for (int i = 0; i < listnumber.length; i++) {
        if (i != listnumber.length - 1) {
          output.add(listnumber[i].trim().toLowerCase());
        }
        List<String> temp = [listnumber[i].trim().toLowerCase()];
        for (int j = i + 1; j < listnumber.length; j++) {
          temp.add(listnumber[j].trim().toLowerCase());
          output.add((temp.join(' ')));
        }
      }

      final ref = await _firestore.collection('products').add(
        {
          'added_at': DateTime.now().millisecondsSinceEpoch,
          'user_id': user,
          'influencer_id': _authService.currentUser!.uid,
          'influencer_name': controller.user.fullname,
          'influencer_img_url': [
            {'downloadURL': controller.user.profileImageURL}
          ],
          'category': productData[i]['category'],
          'title': productData[i]['title'],
          'product_url': productData[i]['url'],
          'rubu_url': productData[i]['rubu_url'],
          'img_url': [
            {
              'downloadURL': mediaURLs['product_img_urls'][i],
            }
          ],
          'price_currency': productData[i]['price']['currency'],
          'price_amount': productData[i]['price']['amount'],
          'search_keys': output,
        },
      );

      productRefList.add(ref);
      productIDsWithImageURLs.add({
        'id': ref.id,
        'img_url': mediaURLs['product_img_urls'][i],
      });

      final List<String> hosts = Get.find<HomeController>()
          .partnerBrands
          .map((e) => Uri.parse(e.website).host.replaceAll(RegExp(r'www.'), ''))
          .toList();

      if (!hosts.any((e) => productData[i]['url'].contains(e))) {
        lonelyProducts.add({
          'product_id': ref.id,
          'influencer_id': _authService.currentUser!.uid,
          'url': productData[i]['url'],
          'notified': false,
        });
      }
    }
    await _firestore.collection('posts').doc(postID).update(
      {
        'id': postID,
        'img_url': [
          {'downloadURL': mediaURLs['post_img_url']}
        ],
        'products': productRefList.map<String>((e) => e.id).toList(),
      },
    );

    for (int i = 0; i < productRefList.length; i++) {
      await _firestore.collection('products').doc(productRefList[i].id).update({
        'id': productRefList[i].id,
      });
    }

    return {
      'product_ids': productIDsWithImageURLs,
      'lonely_products': lonelyProducts,
    };
  }

  Future<Map<String, List<Map<String, dynamic>>>> updateEditedPost(
    String postID,
    String caption,
    List productData,
    Map<String, dynamic> mediaURLs,
  ) async {
    final controller = Get.find<HomeController>();
    final productRefList = <DocumentReference<Map<String, dynamic>>>[];
    final postProductIDs = <String>[];
    final lonelyProducts = <Map<String, dynamic>>[];
    final productIDsWithImageURLs = <Map<String, dynamic>>[];

    final user = _firestore.collection('users').doc(_authService.currentUser!.uid);

    for (var i = 0; i < productData.length; i++) {
      List<String> listnumber = productData[i]['title'].replaceAll(RegExp('[^A-Za-z0-9& ]'), '').split(" ");
      List<String> output = [];
      for (int i = 0; i < listnumber.length; i++) {
        if (i != listnumber.length - 1) {
          output.add(listnumber[i].trim().toLowerCase());
        }
        List<String> temp = [listnumber[i].trim().toLowerCase()];
        for (int j = i + 1; j < listnumber.length; j++) {
          temp.add(listnumber[j].trim().toLowerCase());
          output.add((temp.join(' ')));
        }
      }

      if (!productData[i].containsKey('id')) {
        final ref = await _firestore.collection('products').add(
          {
            'added_at': DateTime.now().millisecondsSinceEpoch,
            'user_id': user,
            'influencer_id': _authService.currentUser!.uid,
            'influencer_name': controller.user.fullname,
            'influencer_img_url': [
              {'downloadURL': controller.user.profileImageURL}
            ],
            'category': productData[i]['category'],
            'title': productData[i]['title'],
            'product_url': productData[i]['url'],
            'rubu_url': productData[i]['rubu_url'],
            'img_url': [
              {
                'downloadURL': mediaURLs['product_img_urls'][i],
              }
            ],
            'price_currency': productData[i]['price']['currency'],
            'price_amount': productData[i]['price']['amount'],
            'search_keys': output,
          },
        );

        await _firestore.collection('products').doc(ref.id).update({
          'id': ref.id,
        });

        postProductIDs.add(ref.id);
        productRefList.add(ref);
        productIDsWithImageURLs.add({
          'id': ref.id,
          'img_url': mediaURLs['product_img_urls'][i],
        });

        final List<String> hosts = Get.find<HomeController>()
            .partnerBrands
            .map((e) => Uri.parse(e.website).host.replaceAll(RegExp(r'www.'), ''))
            .toList();

        if (!hosts.any((e) => productData[i]['url'].contains(e))) {
          lonelyProducts.add({
            'product_id': ref.id,
            'influencer_id': _authService.currentUser!.uid,
            'url': productData[i]['url'],
            'notified': false,
          });
        }
      } else {
        await _firestore.collection('products').doc(productData[i]['id']).update(
          {
            'updated_at': DateTime.now().millisecondsSinceEpoch,
            'category': productData[i]['category'],
            'title': productData[i]['title'],
            'img_url': [
              {
                'downloadURL': mediaURLs['product_img_urls'][i],
              }
            ],
            'price_currency': productData[i]['price']['currency'],
            'price_amount': productData[i]['price']['amount'],
            'search_keys': output,
          },
        );

        postProductIDs.add(productData[i]['id']);
      }
    }

    if (mediaURLs['post_img_url'] != null) {
      await _firestore.collection('posts').doc(postID).update(
        {
          'id': postID,
          'caption': caption,
          'img_url': [
            {'downloadURL': mediaURLs['post_img_url']}
          ],
          'products': postProductIDs,
        },
      );
    } else {
      await _firestore.collection('posts').doc(postID).update(
        {
          'id': postID,
          'caption': caption,
          'products': postProductIDs,
        },
      );
    }

    for (int i = 0; i < productRefList.length; i++) {
      await _firestore.collection('products').doc(productRefList[i].id).update({
        'id': productRefList[i].id,
      });
    }

    return {
      'product_ids': productIDsWithImageURLs,
      'lonely_products': lonelyProducts,
    };
  }

  Future<void> addLonelyProducts(List<Map<String, dynamic>> lonelyPrdocuts) async {
    for (var product in lonelyPrdocuts) {
      await _firestore.collection('lonely_products').doc().set(product);
    }
  }
}
