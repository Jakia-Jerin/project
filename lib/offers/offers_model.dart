
class OffersModel {
  final String id;
  final String handle;
  final String shortTitle;
  final String longTitle;

  OffersModel({
    required this.id,
    required this.handle,
    required this.shortTitle,
    required this.longTitle,
  });

  factory OffersModel.fromJson(Map<String, dynamic> json) {
    return OffersModel(
      id: json['id'] ?? "",
      handle: json['handle'] ?? "",
      shortTitle: json['shortTitle'] ?? "",
      longTitle: json['longTitle'] ?? "",
    );
  }
}
