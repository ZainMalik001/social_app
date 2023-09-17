import 'package:rubu/core/models/post_model.dart';

class InfluencerProfileModel {
  final String id, fullName, username, description, profileImageURL, coverImageURL;
  // final List<InfluencerCollection> influencerCollection;
  final List<PostModel> recentPosts;

  const InfluencerProfileModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.description,
    // required this.influencerCollection,
    required this.profileImageURL,
    required this.coverImageURL,
    required this.recentPosts,
  });

  factory InfluencerProfileModel.fromJson(String id, Map<String, dynamic> json, List<PostModel> recentPosts) {
    return InfluencerProfileModel(
      id: id,
      fullName: json['full_name'],
      username: json['user_name'],
      description: json['profile_description'],
      profileImageURL:
          json['profile_img_url'] is List ? json['profile_img_url'].first['downloadURL'] : json['profile_img_url'],
      coverImageURL: json['cover_img_url'] is List ? json['cover_img_url'].first['downloadURL'] : json['cover_img_url'],
      // influencerCollection: collection,
      recentPosts: recentPosts,
    );
  }
}

// class InfluencerCollection {
//   final String collectionCategory;
//   final List<String> collectionProducts;

//   const InfluencerCollection({
//     required this.collectionCategory,
//     required this.collectionProducts,
//   });

//   factory InfluencerCollection.fromJson(Map<String, dynamic> json) {
//     return InfluencerCollection(
//       collectionCategory: json['collection_category'],
//       collectionProducts: json['collection_products'].map<String>((e) => e.toString()).toList(),
//     );
//   }
// }
