class UserModel {
  String? id, fullname, email, country;
  bool isInfluencer;

  UserModel({
    required this.id,
    required this.fullname,
    required this.email,
    required this.isInfluencer,
    this.country,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullname: json['full_name'],
      email: json['email'],
      isInfluencer: json['is_influencer'],
      country: json.containsKey('country') ? json['country'] : null,
    );
  }

  // set newName(String? val) {
  //   fullname = val;
  // }

  // set newEmail(String? val) {
  //   email = val;
  // }
}
