import 'package:theme_desiree/a/models/caregories.dart';

class ProductMiniCardModel {
  final String id;
  final String title;
  final List<String> tag;
  final double price;
  final double compareAtPrice;
  final String featuredImage;
  final CategoryModel? category;
  final String? categoryId;
  final String? categoryName;

  ProductMiniCardModel({
    required this.id,
    required this.title,
    required this.tag,
    required this.price,
    required this.compareAtPrice,
    required this.featuredImage,
    required this.category,
    this.categoryId,
    this.categoryName,
  });

  factory ProductMiniCardModel.fromJson(Map<String, dynamic> json) {
    final priceMap = json['price'] as Map<String, dynamic>? ?? {};
    final category = json['category'] as Map<String, dynamic>?;
    return ProductMiniCardModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      tag: (json['tag'] as List?)?.cast<String>() ?? [],
      price: (priceMap['base'] as num?)?.toDouble() ?? 0.0,
      compareAtPrice: (priceMap['compareAt'] as num?)?.toDouble() ?? 0.0,
      //   price: (json['price'] as num?)?.toDouble() ?? 0.0,
      //  compareAtPrice: (json['compare_at_price'] as num?)?.toDouble() ?? 0.0,
      featuredImage: json['featured_image'] ?? '',
      category: json['category'] != null
          ? CategoryModel(
              id: json['category']['_id'] ?? '',
              title: json['category']['title'] ?? '',
              handle: json['category']['slug'] ?? '',
              description: '',
              imageUrl: json['category']['image'] != null
                  ? CategoryImage.fromJson(json['category']['image'])
                  : null,
              coverUrl: '',
            )
          : null,
      categoryId: category != null ? category['_id'] ?? "" : "",
      categoryName: category != null ? category['title'] ?? "" : "",
    );
  }
}
