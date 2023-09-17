import 'user_model.dart';

class UserInfluencerModel extends UserModel {
  String? profilePicture, username, profileImageURL, coverImageURL, profileDescription, accountStatus;

  UserInfluencerModel({
    required super.id,
    required super.email,
    required super.fullname,
    required super.isInfluencer,
    super.country,
    this.profilePicture,
    this.username,
    this.profileDescription,
    this.profileImageURL,
    this.coverImageURL,
    this.accountStatus,
  });

  factory UserInfluencerModel.fromJson(Map<String, dynamic> json) {
    return UserInfluencerModel(
      id: json['id'],
      email: json['email'],
      fullname: json['full_name'],
      isInfluencer: json['is_influencer'] ?? false,
      profilePicture: json.containsKey('image_ref')
          ? json['image_ref'] is List
              ? json['image_ref'].first['downloadURL']
              : json['image_ref']
          : null,
      username: json.containsKey('user_name') ? json['user_name'] : null,
      profileDescription: json.containsKey('profile_description') ? json['profile_description'] : null,
      profileImageURL: json.containsKey('profile_img_url')
          ? json['profile_img_url'] is List
              ? json['profile_img_url'].first['downloadURL']
              : json['profile_img_url']
          : null,
      coverImageURL: json.containsKey('cover_img_url')
          ? json['cover_img_url'] is List
              ? json['cover_img_url'].first['downloadURL']
              : json['cover_img_url']
          : null,
      accountStatus: json['account_status'] ?? 'normal',
      country: json.containsKey('country') ? json['country'] : null,
    );
  }
}
