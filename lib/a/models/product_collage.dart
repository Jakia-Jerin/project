import 'package:theme_desiree/a/models/product_mini_card.dart';

class ProductCollageModel {
  final List<ProductMiniCardModel> products;

  ProductCollageModel({
    required this.products,
  });

  factory ProductCollageModel.fromJson(Map<String, dynamic> json) {
    return ProductCollageModel(
      products: (json['products'] as List)
          .map(
            (item) => ProductMiniCardModel.fromJson(item),
          )
          .toList(),
    );
  }
}
