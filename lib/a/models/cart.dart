import 'package:theme_desiree/showcase/product_model.dart';

class CartModel {
  final String cartItemId;
  final String productId;
  final List<String> variantId;
  final String? title;
  final List<VariantModel> variant;
  //final List<VariantModel> variant;
  // final String? variant;
  final String? image;
  late int quantity;
  final int? stock;
  final num price;

  final num subtotal;
  final bool? isAvailable;
  final String? shop;
//  final List<String> options;
  final String options;

  CartModel({
    required this.cartItemId,
    required this.productId,
    required this.variantId,
    required this.title,
    required this.variant,
    required this.image,
    required this.quantity,
    required this.stock,
    required this.price,
    required this.subtotal,
    required this.isAvailable,
    required this.options,
    this.shop,
  });

  /// Updated fromJson to handle Get User Cart API
  factory CartModel.fromJson(Map<String, dynamic> json) {
    num parsePrice(dynamic value) {
      if (value is num) return value;
      if (value is Map<String, dynamic>) return value['final'] ?? 0;
      return 0;
    }

    return CartModel(
        cartItemId: json['cartItemId'] ?? json['id'] ?? '',
        productId: json['productId'] ?? json['_id'] ?? '',
        variantId: (json['variantIds'] as List<dynamic>?)
                ?.map((v) => v.toString())
                .toList() ??
            [],
        //    variantId: json['variantId']?.toString() ?? '',
        title: json['title'] ?? json['productTitle'] ?? '',
        variant: (json['variants'] as List<dynamic>?)?.map((v) {
              if (v is Map<String, dynamic>) {
                return VariantModel(
                  id: v['variantId'] ?? v['id'] ?? '',
                  title: v['name'] ?? v['title']?.toString(),
                  options: (v['options'] as List?)
                          ?.map((e) => e.toString())
                          .toList() ??
                      [],
                  price: {},
                  compareAtPrice: 0,
                  available: true,
                );
              }
              return VariantModel(
                id: v.toString(),
                options: [],
                price: {},
                compareAtPrice: 0,
                available: true,
              );
            }).toList() ??
            [],
        image: json['image'] ?? '', // null হলে empty string
        quantity: json['quantity'] ?? 1,
        stock:
            json['stock'] != null ? int.tryParse(json['stock'].toString()) : 0,
        price: parsePrice(json['price']),
        //  price: json['price'] ?? {},
        subtotal: json['subtotal'] ?? 0,
        isAvailable: json['isAvailable'] ?? true,
        options: (() {
          final rawOptions = json['variants'] ?? json['variants'];

          if (rawOptions == null) return '';
          if (rawOptions is List) {
            return rawOptions.map((e) => e.toString()).join(', ');
          }
          return rawOptions.toString();
        })(),
        // options:
        //     (json['options'] as List?)?.map((e) => e.toString()).toList() ?? [],
        shop: json['shop'] ?? '');
  }

  CartModel copy() {
    return CartModel(
      cartItemId: cartItemId,
      productId: productId,
      variantId: variantId,
      title: title,
      variant: List<VariantModel>.from(variant),
      image: image,
      quantity: quantity,
      stock: stock,
      price: price,
      subtotal: subtotal,
      isAvailable: isAvailable,
      shop: shop,
      options: options,
    );
  }
}

// class CartModel {
//   final String productId;
//   final String? variantId;
//   final String? title;
//   final String? variant;
//   final String? image;
//   late int quantity;
//   final int? stock;
//   final num? price;
//   final bool? isAvailable;

//   CartModel({
//     required this.productId,
//     required this.variantId,
//     required this.title,
//     required this.variant,
//     required this.image,
//     required this.quantity,
//     required this.stock,
//     required this.price,
//     required this.isAvailable,
//   });

//   factory CartModel.fromJson(Map<String, dynamic> json) {
//     return CartModel(
//       productId: json['productId'],
//       variantId: json['variantId'],
//       title: json['title'],
//       variant: json['variant'],
//       image: json['image'],
//       quantity: json['quantity'],
//       stock: json['stock'],
//       price: json['price'],
//       isAvailable: json['isAvailable'],
//     );
//   }

//   CartModel copy() {
//     return CartModel(
//       productId: productId,
//       variantId: variantId,
//       title: title,
//       variant: variant,
//       image: image,
//       quantity: quantity,
//       stock: stock,
//       price: price,
//       isAvailable: isAvailable,
//     );
//   }
// }
