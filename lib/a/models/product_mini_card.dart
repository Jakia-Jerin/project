import 'package:theme_desiree/a/models/caregories.dart';
import 'package:theme_desiree/showcase/product_model.dart';

class ProductMiniCardModel {
  final String id;
  final String title;
  final List<String> tag;
  final double price;
  final double compareAtPrice;
  final List<String> gallery;
  final String featuredImage;
  final CategoryModel? category;
  final String? categoryId;
  final String? categoryName;
  final List<VariantModel> variants;

  ProductMiniCardModel({
    required this.id,
    required this.title,
    required this.tag,
    required this.price,
    required this.compareAtPrice,
    required this.gallery,
    required this.featuredImage,
    required this.category,
    this.categoryId,
    this.categoryName,
    required this.variants,
  });

  factory ProductMiniCardModel.fromJson(Map<String, dynamic> json) {
    final priceMap = json['price'] as Map<String, dynamic>? ?? {};
    final category = json['category'] as Map<String, dynamic>?;
    // Convert gallery JSON array to List<String>
    final galleryList = (json['gallery'] as List?)
            ?.map((e) => e['fileName'] as String? ?? '')
            .toList() ??
        [];
    return ProductMiniCardModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      tag: (json['tag'] as List?)?.cast<String>() ?? [],
      price: (priceMap['base'] as num?)?.toDouble() ?? 0.0,
      compareAtPrice: (priceMap['compareAt'] as num?)?.toDouble() ?? 0.0,
      //   price: (json['price'] as num?)?.toDouble() ?? 0.0,
      //  compareAtPrice: (json['compare_at_price'] as num?)?.toDouble() ?? 0.0,
      gallery: galleryList,
      featuredImage: galleryList.isNotEmpty ? galleryList[0] : '',
      //   featuredImage: json['featured_image'] ?? '',
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
              children: json['children'] != null
                  ? List<String>.from(json['children'])
                  : [],
            )
          : null,
      categoryId: category != null ? category['_id'] ?? "" : "",
      categoryName: category != null ? category['title'] ?? "" : "",
      variants: json['variants'] != null
          ? (json['variants'] as List)
              .map((v) => VariantModel.fromJson(v))
              .toList()
          : [],
    );
  }
}
