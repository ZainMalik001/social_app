class InfluencerModel {
  final String influencerID, influencerProfileURL, influencerName;

  const InfluencerModel({
    required this.influencerID,
    required this.influencerProfileURL,
    required this.influencerName,
  });

  factory InfluencerModel.fromJson(Map<String, dynamic> json) {
    final nameSplit = json["full_name"].split(' ');
    final name = nameSplit[0] + ' ' + nameSplit[1][0] + '.';
    return InfluencerModel(
      influencerID: json['id'],
      influencerName: name,
      influencerProfileURL:
          json['profile_img_url'] is List ? json['profile_img_url'].first['downloadURL'] : json['profile_img_url'],
    );
  }
}
