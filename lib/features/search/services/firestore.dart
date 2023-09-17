import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:rubu/core/models/post_model.dart';

import '../../../core/models/influencer_model.dart';

class SearchFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ProductModel>> searchProducts(String query) async {
    final filteredProducts =
        await _firestore.collection('products').where('search_keys', arrayContains: query.trim().toLowerCase()).get();

    List<ProductModel> products = [];

    for (var e in filteredProducts.docs) {
      products.add(await ProductModel.fromJsonFuture(e.data()));
    }

    return products;

    // return filteredProducts.docs.map((e) => ProductModel.fromJson(e.data())).toList();
  }

  Future<List<InfluencerModel>> searchInfluencers(String query) async {
    final filteredInfluencers = await _firestore
        .collection('users')
        .where('is_influencer', isEqualTo: true)
        .where('search_keys', arrayContains: query.trim().toLowerCase())
        .get();

    return filteredInfluencers.docs.map((e) => InfluencerModel.fromJson(e.data())).toList();
  }

  Future<List<ProductModel>> searchCategory(String query) async {
    final categoryProducts =
        await _firestore.collection('products').where('category', isEqualTo: query.capitalizeFirst).get();

    List<ProductModel> products = [];

    for (var e in categoryProducts.docs) {
      products.add(await ProductModel.fromJsonFuture(e.data()));
    }

    return products;

    // return categoryProducts.docs.map((e) => ProductModel.fromJson(e.data())).toList();
  }

  Future<List<ProductModel>> fetchDiscoveryProducts(String category) async {
    final data = await _firestore
        .collection('products')
        .where('category', isEqualTo: category)
        .orderBy('added_at', descending: true)
        .get();

    List<ProductModel> products = [];

    for (var product in data.docs) {
      products.add(await ProductModel.fromJsonFuture(product.data()));
    }

    return products;
  }
}
