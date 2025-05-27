class ProductMiniCardModel {
  final String id;
  final String title;
  final List<String> tag;
  final double price;
  final double compareAtPrice;
  final String featuredImage;

  ProductMiniCardModel({
    required this.id,
    required this.title,
    required this.tag,
    required this.price,
    required this.compareAtPrice,
    required this.featuredImage,
  });

  factory ProductMiniCardModel.fromJson(Map<String, dynamic> json) {
    return ProductMiniCardModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      tag: (json['tag'] as List?)?.cast<String>() ?? [],
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      compareAtPrice: (json['compare_at_price'] as num?)?.toDouble() ?? 0.0,
      featuredImage: json['featured_image'] ?? '',
    );
  }
}
