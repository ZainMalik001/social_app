import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rubu/core/models/partner_brands_model.dart';

import '../models/influencer_model.dart';
import '../models/post_model.dart';
import '../models/user_influencer_model.dart';

class CoreFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> fetchPostDocs([DocumentSnapshot? lastDoc]) async {
    return lastDoc == null
        ? await _firestore.collection('posts').orderBy('created_at', descending: true).limit(30).get()
        : await _firestore
            .collection('posts')
            .orderBy('created_at', descending: true)
            .startAfterDocument(lastDoc)
            .limit(3)
            .get();
  }

  Future<List<PostModel>> processPosts(QuerySnapshot<Map<String, dynamic>> postDocs) async {
    final posts = postDocs;

    final productIDs = posts.docs.map((e) => e['products']).expand((e) => e).toList();

    final allProducts = await _firestore.collection("products").get();

    // allProducts.docs.forEach((element) async {
    //   List<String> listnumber = element.data()['title'].replaceAll(RegExp('[^A-Za-z0-9& ]'), '').split(" ");
    //   List<String> output = [];
    //   for (int i = 0; i < listnumber.length; i++) {
    //     if (i != listnumber.length - 1) {
    //       output.add(listnumber[i].toLowerCase()); //
    //     }
    //     List<String> temp = [listnumber[i].toLowerCase()];
    //     for (int j = i + 1; j < listnumber.length; j++) {
    //       temp.add(listnumber[j].toLowerCase()); //
    //       output.add((temp.join(' ')));
    //     }
    //   }
    //   await element.reference.update({
    //     'search_keys': output,
    //   });
    // });

    final products = allProducts.docs.where((e) => productIDs.contains(e.id)).toList();

    final productModelList = products.map((e) => ProductModel.fromJson(e.data()));

    // final productOrder = await _firestore.collection("posts_products").orderBy("order").get();

    // Map<String, List<String>> productOrdering = {};

    // for (var product in productOrder.docs) {
    //   final value = productOrdering[product["post_id"].id];
    //   if (value != null) {
    //     productOrdering[product["post_id"].id]!.add(product["product_id"].id);
    //   } else {
    //     productOrdering[product["post_id"].id] = [product["product_id"].id];
    //   }
    // }

    List<PostModel> postModels = [];

    for (var e in posts.docs) {
      postModels.add(await PostModel.fromJsonFuture(
          e.data(), productModelList.where((el) => e['products'].contains(el.id)).toList()));
    }

    // return posts.docs
    //     .map(
    //         (e) => PostModel.fromJson(e.data(), productModelList.where((el) => e['products'].contains(el.id)).toList()))
    //     .toList();

    return postModels;
  }

  Future<List<ProductModel>> fetchInterestProducts() async {
    final collection = await _firestore.collection('products').get();

    late List<int> randomIndex = [], distIndices;
    List<ProductModel> products = [];

    for (int i = 0;;) {
      randomIndex.add(Random().nextInt(collection.size));
      distIndices = randomIndex.toSet().toList();

      if (distIndices.length < 2) {
        continue;
      } else {
        // products = List.generate(distIndices.length, (index) => ProductModel.fromJson(collection.docs[index].data()));
        // break;
        for (var e in distIndices) {
          products.add(await ProductModel.fromJsonFuture(collection.docs[e].data()));
        }
        break;
      }
    }

    return products;
  }

  Future<List<PostModel>> fetchUserInfluencerPosts(String userID) async {
    final posts = await _firestore
        .collection('posts')
        .where('influencer_id', isEqualTo: userID)
        .orderBy('created_at', descending: true)
        .get();

    final productIDs = posts.docs.map((e) => e['products']).expand((e) => e).toList();

    final allProducts = await _firestore.collection("products").get();

    final products = allProducts.docs.where((e) => productIDs.contains(e.id)).toList();

    final productModelList = products.map((e) => ProductModel.fromJson(e.data()));

    return posts.docs
        .map(
            (e) => PostModel.fromJson(e.data(), productModelList.where((el) => e['products'].contains(el.id)).toList()))
        .toList();
  }

  Future<UserInfluencerModel> fetchUser(String userID) async {
    final data = await _firestore.collection('users').doc(userID).get();

    return UserInfluencerModel.fromJson(data.data()!);
  }

  Future<List<String>> fetchLikedPostIDs(String userID) async {
    final data = await _firestore.collection('liked_posts').doc(userID).get();

    if (data.exists) {
      return data.data()!['posts'].map<String>((e) => e.toString()).toList();
    }

    return [];
  }

  Future<List<String>> fetchFavoritePostIDs(String userID) async {
    final data = await _firestore.collection('favorite_posts').doc(userID).get();

    if (data.exists) {
      return data.data()!['posts'].map<String>((e) => e.toString()).toList();
    }

    return [];
  }

  Future<List<PostModel>> fetchLikedPosts(List<String> postIDs) async {
    if (postIDs.isEmpty) {
      return [];
    }
    final data = await _firestore.collection('posts').where('id', whereIn: postIDs).get();

    final productIDs = data.docs.map((e) => e.data()['products']).expand((e) => e).toList();

    final allProducts = await _firestore.collection("products").get();

    final products = allProducts.docs.where((e) => productIDs.contains(e.id)).toList();

    final productModelList = products.map((e) => ProductModel.fromJson(e.data()));

    return data.docs
        .map(
            (e) => PostModel.fromJson(e.data(), productModelList.where((el) => e['products'].contains(el.id)).toList()))
        .toList();
  }

  Future<List<PostModel>> fetchFavoritePosts(List<String> postIDs) async {
    if (postIDs.isEmpty) {
      return [];
    }
    final data = await _firestore.collection('posts').where('id', whereIn: postIDs).get();

    final productIDs = data.docs.map((e) => e.data()['products']).expand((e) => e).toList();

    final allProducts = await _firestore.collection("products").get();

    final products = allProducts.docs.where((e) => productIDs.contains(e.id)).toList();

    final productModelList = products.map((e) => ProductModel.fromJson(e.data()));

    return data.docs
        .map(
            (e) => PostModel.fromJson(e.data(), productModelList.where((el) => e['products'].contains(el.id)).toList()))
        .toList();
  }

  Future<void> updateLikedPosts(String postID, String userID, bool isLiked) async {
    if (isLiked) {
      await _firestore.collection('liked_posts').doc(userID).update({
        'posts': FieldValue.arrayRemove([postID]),
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      });
      return;
    }

    final doc = await _firestore.collection('liked_posts').doc(userID).get();

    if (doc.exists) {
      await _firestore.collection('liked_posts').doc(userID).update({
        'posts': FieldValue.arrayUnion([postID]),
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      });
    } else {
      _firestore.collection('liked_posts').doc(userID).set({
        'posts': [postID],
        'updated_at': DateTime.now().millisecondsSinceEpoch,
        'user': userID,
      });
    }
    return;
  }

  Future<void> updateFavoritePosts(String postID, String userID, bool isFavorite) async {
    if (isFavorite) {
      await _firestore.collection('favorite_posts').doc(userID).update({
        'posts': FieldValue.arrayRemove([postID]),
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      });
      return;
    }

    final doc = await _firestore.collection('favorite_posts').doc(userID).get();

    if (doc.exists) {
      await _firestore.collection('favorite_posts').doc(userID).update({
        'posts': FieldValue.arrayUnion([postID]),
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      });
    } else {
      _firestore.collection('favorite_posts').doc(userID).set({
        'posts': [postID],
        'updated_at': DateTime.now().millisecondsSinceEpoch,
        'user': userID,
      });
    }
    return;
  }

  Future<PostModel> fetchPost(String postID) async {
    final post = await _firestore.collection('posts').doc(postID).get();

    final productIDs = post['products'];

    final allProducts = await _firestore.collection("products").get();

    final products = allProducts.docs.where((e) => productIDs.contains(e.id)).toList();

    final productModelList = products.map((e) => ProductModel.fromJson(e.data())).toList();

    return PostModel.fromJson(post.data()!, productModelList);
  }

  Future<List<InfluencerModel>> fetchInfluencers() async {
    final influencers = await _firestore
        .collection("users")
        .where('is_influencer', isEqualTo: true)
        .orderBy('created_at', descending: true)
        // .limit(20)
        .get();

    // influencers.docs.forEach((element) async {
    //   List<String> listnumber = element.data()['full_name'].split(" ");
    //   List<String> output = []; // int -> String
    //   for (int i = 0; i < listnumber.length; i++) {
    //     if (i != listnumber.length - 1) {
    //       output.add(listnumber[i].toLowerCase()); //
    //     }
    //     List<String> temp = [listnumber[i].toLowerCase()];
    //     for (int j = i + 1; j < listnumber.length; j++) {
    //       temp.add(listnumber[j].toLowerCase()); //
    //       output.add((temp.join(' ')));
    //     }
    //   }
    //   await element.reference.update({
    //     'search_keys': output,
    //   });
    // });

    return influencers.docs.map((e) => InfluencerModel.fromJson(e.data())).toList();
  }

  Future<List<PartnerBrandsModel>> getPartnerBrands() async {
    final res = await _firestore.collection('partner_brands').get();

    return res.docs.map((e) => PartnerBrandsModel.fromJson(e.data())).toList();
  }

  Future<bool> deletePost(String postID) async {
    try {
      await _firestore.collection('posts').doc(postID).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
