import 'package:theme_desiree/offers/offers_model.dart';

class AppbarModel {
  final bool isCompact;
  final bool isCard;
  final bool searchArea;
  final List<OffersModel> offers;

  AppbarModel({
    required this.isCompact,
    required this.isCard,
    required this.searchArea,
    required this.offers,
  });

  factory AppbarModel.fromJson(Map<String, dynamic> json) {
    return AppbarModel(
      isCompact: json['isCompact'],
      isCard: json['isCard'],
      searchArea: json['searchArea'],
      offers: (json['offers'] as List<dynamic>)
          .map((item) => OffersModel.fromJson(item))
          .toList() ?? [],
    );
  }
}
