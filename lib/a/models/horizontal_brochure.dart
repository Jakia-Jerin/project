import 'package:theme_desiree/a/models/product_mini_card.dart';

class HorizontalBrochureModel {
  final String title;
  final String subtitle;
  final String? image;
  final String handle;
  final List<ProductMiniCardModel> products;

  HorizontalBrochureModel({
    required this.title,
    required this.subtitle,
    this.image,
    required this.handle,
    required this.products,
  });

  factory HorizontalBrochureModel.fromJson(Map<String, dynamic> json) {
    return HorizontalBrochureModel(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      image: json['image'],
      handle: json['handle'] ?? '/',
      products: (json['products'] as List?)
              ?.map((item) => ProductMiniCardModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}
