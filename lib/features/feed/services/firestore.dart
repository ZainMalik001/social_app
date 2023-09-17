import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rubu/core/models/post_model.dart';

import '../models/influencer_profile_model.dart';

class FeedFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<InfluencerProfileModel> fetchInfluencerProfile(String id) async {
    // late List<InfluencerCollection> influencerCollection;
    late List<PostModel> influencerPosts;
    // final collectionByDoc = await _firestore.collection('collections').where('created_by', isEqualTo: id).get();
    final postsByInfluencer = await _firestore
        .collection('posts')
        .where('influencer_id', isEqualTo: id)
        .limit(30)
        .orderBy('created_at', descending: true)
        .get();

    // if (collectionByDoc.docs.isNotEmpty) {
    //   influencerCollection =
    //       collectionByDoc.docs.map<InfluencerCollection>((e) => InfluencerCollection.fromJson(e.data())).toList();
    // } else {
    //   influencerCollection = [];
    // }

    if (postsByInfluencer.docs.isNotEmpty) {
      final productIDs = postsByInfluencer.docs.map((e) => e['products']).expand((e) => e).toList();

      List partitions = [];

      if (productIDs.length > 10) {
        for (int i = 0; i < productIDs.length; i += 10) {
          if (productIDs.sublist(i).length >= 10) {
            partitions.add(productIDs.sublist(i, i + 10));
          } else {
            partitions.add(productIDs.sublist(i, productIDs.length));
          }
        }
      }

      List<ProductModel> productModelList = [];

      for (var partition in partitions) {
        final products = await _firestore.collection("products").where("id", whereIn: partition).get();
        productModelList = [...productModelList, ...products.docs.map((e) => ProductModel.fromJson(e.data())).toList()];
      }
      influencerPosts = postsByInfluencer.docs
          .map((e) =>
              PostModel.fromJson(e.data(), productModelList.where((el) => e['products'].contains(el.id)).toList()))
          .toList();
    } else {
      influencerPosts = [];
    }

    final influencerDoc = await _firestore.collection('users').doc(id).get();

    return InfluencerProfileModel.fromJson(id, influencerDoc.data()!, influencerPosts);
  }

  Future<List<ProductModel>> fetchCollectionProducts(String influencerID, String category) async {
    final collectionProducts = await _firestore
        .collection('products')
        .where('influencer_id', isEqualTo: influencerID)
        .where('category', isEqualTo: category)
        .orderBy('added_at', descending: true)
        .get();

    late List<ProductModel> products = [];

    for (var collectionProduct in collectionProducts.docs) {
      products.add(ProductModel.fromJson(collectionProduct.data()));
    }

    return products;
  }

  Future<List<ProductModel>> fetchAllInfluencerProducts(String influencerID) async {
    final allInfluencerProducts = await _firestore
        .collection('products')
        .where('influencer_id', isEqualTo: influencerID)
        .orderBy('added_at', descending: true)
        .get();

    final tempCategoryList = <String>[];
    final tempProductList = <ProductModel>[];

    for (var e in allInfluencerProducts.docs) {
      if (!tempCategoryList.contains(e.data()['category'])) {
        tempCategoryList.add(e.data()['category']);
        tempProductList.add(ProductModel.fromJson(e.data()));
      }
    }

    return tempProductList;
  }
}
