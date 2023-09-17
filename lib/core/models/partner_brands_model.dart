class PartnerBrandsModel {
  final String website, photoUrl, name, category;

  const PartnerBrandsModel({
    required this.name,
    required this.website,
    required this.category,
    required this.photoUrl,
  });

  factory PartnerBrandsModel.fromJson(Map<String, dynamic> json) {
    return PartnerBrandsModel(
      name: json["brandName"],
      website: json["brandWebsite"],
      category: json["category"],
      photoUrl: json["photo"],
    );
  }
}
