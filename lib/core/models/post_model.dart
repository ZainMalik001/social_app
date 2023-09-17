import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';

class PostModel {
  final String postID, caption, imageURL, influencerID, influencerName, influencerImgUrl;
  final Timestamp createdAt;
  final List<ProductModel> productModel;

  const PostModel({
    required this.postID,
    required this.caption,
    required this.createdAt,
    required this.productModel,
    required this.imageURL,
    required this.influencerID,
    required this.influencerName,
    required this.influencerImgUrl,
  });

  factory PostModel.fromJson(Map<String, dynamic> json, List<ProductModel> productList) {
    return PostModel(
      postID: json['id'],
      caption: json['caption'],
      createdAt: json['created_at'],
      influencerID: json['influencer_id'],
      influencerName: json['influencer_name'],
      influencerImgUrl: json['influencer_img_url'] is List
          ? json['influencer_img_url'].first['downloadURL']
          : json['influencer_img_url'],
      // productModel: json.containsKey('metadata')
      //     ? json['metadata']
      //         .map<ProductModel>((e) => ProductModel.fromJson(e, json['added_by'], json['added_at'], json['id']))
      //         .toList()
      //     : json['product']['metadata']
      //         .map<ProductModel>((e) => ProductModel.fromJson(e, json['created_by'], json['created_at'], json['id']))
      //         .toList(),
      productModel: productList,
      imageURL: json['img_url'] is List ? json['img_url'].first['downloadURL'] : json['img_url'],
    );
  }

  static Future<PostModel> fromJsonFuture(Map<String, dynamic> json, List<ProductModel> productList) async {
    String? influencerName, influencerProfileImgUrl;
    if (json.containsKey('user_id')) {
      final ref = json['user_id'] as DocumentReference;
      final userDoc = (await ref.get()).data() as Map?;
      if (userDoc != null) {
        influencerName = userDoc['full_name'];
        influencerProfileImgUrl = userDoc['profile_img_url'] is List
            ? userDoc['profile_img_url'].first['downloadURL']
            : userDoc['profile_img_url'];
      }
    }

    return PostModel(
      postID: json['id'],
      caption: json['caption'],
      createdAt: json['created_at'],
      influencerID: json['influencer_id'],
      influencerName: influencerName ?? json['influencer_name'],
      influencerImgUrl: influencerProfileImgUrl ??
          (json['influencer_img_url'] is List
              ? json['influencer_img_url'].first['downloadURL']
              : json['influencer_img_url']),
      // productModel: json.containsKey('metadata')
      //     ? json['metadata']
      //         .map<ProductModel>((e) => ProductModel.fromJson(e, json['added_by'], json['added_at'], json['id']))
      //         .toList()
      //     : json['product']['metadata']
      //         .map<ProductModel>((e) => ProductModel.fromJson(e, json['created_by'], json['created_at'], json['id']))
      //         .toList(),
      productModel: productList,
      imageURL: json['img_url'] is List ? json['img_url'].first['downloadURL'] : json['img_url'],
    );
  }
}

class ProductModel {
  final String id, title, storeLink, rubuLink, imageUrl, influencerID, influencerName, influencerImgUrl, category;
  final int addedAt;
  final String? productPrice, priceCurrency;
  final DocumentReference? user;

  const ProductModel({
    required this.id,
    required this.title,
    required this.storeLink,
    required this.rubuLink,
    required this.addedAt,
    required this.imageUrl,
    required this.influencerID,
    required this.influencerName,
    required this.influencerImgUrl,
    required this.category,
    this.productPrice,
    this.priceCurrency,
    this.user,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      storeLink: json['product_url'],
      rubuLink: json['rubu_url'],
      addedAt: json['added_at'],
      category: json['category'] ?? 'Fashion',
      imageUrl: json['img_url'] is List ? json['img_url'].first['downloadURL'] : json['img_url'],
      influencerID: json['influencer_id'],
      influencerName: json['influencer_name'],
      influencerImgUrl: json['influencer_img_url'] is List
          ? json['influencer_img_url'].first['downloadURL']
          : json['influencer_img_url'],
      productPrice: json.containsKey('price_amount') ? json['price_amount'].toString() : null,
      priceCurrency: json.containsKey('price_currency') ? json['price_currency'] : null,
      user: json.containsKey('user_id') ? json['user_id'] : null,
    );
  }

  static Future<ProductModel> fromJsonFuture(Map<String, dynamic> json) async {
    String? influencerName, influencerProfileImgUrl;
    if (json.containsKey('user_id')) {
      final ref = json['user_id'] as DocumentReference;
      final userDoc = (await ref.get()).data() as Map?;
      if (userDoc != null) {
        influencerName = userDoc['full_name'];
        influencerProfileImgUrl = userDoc['profile_img_url'] is List
            ? userDoc['profile_img_url'].first['downloadURL']
            : userDoc['profile_img_url'];
      }
    }

    return ProductModel(
      id: json['id'],
      title: json['title'],
      storeLink: json['product_url'],
      rubuLink: json['rubu_url'],
      addedAt: json['added_at'],
      category: json['category'] ?? 'Fashion',
      imageUrl: json['img_url'] is List ? json['img_url'].first['downloadURL'] : json['img_url'],
      influencerID: json['influencer_id'],
      influencerName: influencerName ?? json['influencer_name'],
      influencerImgUrl: influencerProfileImgUrl ??
          (json['influencer_img_url'] is List
              ? json['influencer_img_url'].first['downloadURL']
              : json['influencer_img_url']),
      productPrice: json.containsKey('price_amount') ? json['price_amount'].toString() : null,
      priceCurrency: json.containsKey('price_currency') ? json['price_currency'] : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': storeLink,
      'affiliate_link': rubuLink,
      'title': title,
      'category': category,
      'image': imageUrl,
      'price': {
        'currency': priceCurrency,
        'symbol': NumberFormat.simpleCurrency().simpleCurrencySymbol(priceCurrency!),
        'amount': productPrice!.split(' ').first.replaceAll(r',', '').isNum
            ? num.parse(productPrice!.split(' ').first.replaceAll(r',', '')).toInt()
            : productPrice!.split(' ').last.replaceAll(r',', '').isNum
                ? num.parse(productPrice!.split(' ').last.replaceAll(r',', '')).toInt()
                : num.parse(productPrice!.replaceAll(r',', '')).toInt(),
      }
    };
  }
}
