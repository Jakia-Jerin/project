import 'package:theme_desiree/a/models/product_mini_card.dart';

class HorizontalBrochureModel {
  final String title;
  final String subtitle;
//  final CategoryImage? image;
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
    final productList = (json['products'] as List?)
            ?.map((item) => ProductMiniCardModel.fromJson(item))
            .toList() ??
        [];

    // Featured image = first product's featured image
    String? featuredImg =
        productList.isNotEmpty ? productList[0].featuredImage : null;

    return HorizontalBrochureModel(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      image: featuredImg,
      handle: json['handle'] ?? '/',
      products: (json['products'] as List?)
              ?.map((item) => ProductMiniCardModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}
