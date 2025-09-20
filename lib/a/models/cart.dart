import 'package:get/get.dart';
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
  final num stock;
  final num price;

  final num subtotal;
  final bool? isAvailable;

  final String? shop;
//  final List<String> options;
  String options;

  RxBool isSelected;

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
    bool selected = false,
  }) : isSelected = selected.obs;

  ///  helper for order post for API request

  List<Map<String, dynamic>> Variantsbody() {
    return variant.map((v) {
      final option = (v.options.isNotEmpty && v.options.first.isNotEmpty)
          ? v.options.first
          : '';
      final name = v.title?.isNotEmpty == true ? v.title! : '';

      return {
        "variantId": v.id.isNotEmpty ? v.id : '',
        "name": name,
        "option": option,
      };
    }).toList();
  }

  /// Updated fromJson to handle Get User Cart API
  factory CartModel.fromJson(Map<String, dynamic> json) {
    // num parsePrice(dynamic value) {
    //   if (value is num) return value;
    //   if (value is Map<String, dynamic>) return value['final'] ?? 0;
    //   return 0;
    // }
    num parsePrice(dynamic value) {
      if (value is num) return value;
      if (value is Map<String, dynamic>) {
        return value['basePrice'] ??
            value['final'] ??
            0; // 👈 basePrice handle koro
      }
      return 0;
    }

    final variantsList = (json['variants'] as List<dynamic>?)
            ?.map((v) => VariantModel(
                  id: v['variantId']?.toString() ?? '',
                  options: v['option'] != null ? [v['option'].toString()] : [],
                  title: v['name'],
                  price: {},
                  // compareAtPrice: 0,
                  available: true,
                ))
            .toList() ??
        [];

    return CartModel(
        cartItemId: json['cartItemId'] ?? json['id'] ?? '',
        productId: json['productId'] ?? json['_id'] ?? '',
        variantId: (json['variantIds'] as List<dynamic>?)
                ?.map((v) => v.toString())
                .toList() ??
            [],
        //    variantId: json['variantId']?.toString() ?? '',
        title: json['title'] ?? json['productTitle'] ?? '',
        variant: variantsList,
        image: json['image'] ?? '', // null হলে empty string
        quantity: json['quantity'] ?? 1,
        stock: json['stock'] is num
            ? json['stock']
            : int.tryParse(json['stock']?.toString() ?? '12') ?? 12,
        //   json['stock'] != null ? int.tryParse(json['stock'].toString()) : 0,
        price: parsePrice(json['price']),
        //  price: json['price'] ?? {},
        subtotal: json['subtotal'] ?? 0,
        isAvailable: json['isAvailable'] ?? true,
        selected: json['isSelected'] ?? false,
        options: (() {
          if (variantsList.isEmpty) return '';
          return variantsList.expand((v) => v.options).join(', ');
        })(),

        // options: (() {
        //   final rawOptions = json['variants'] ?? json['variants'];

        //   if (rawOptions == null) return '';
        //   if (rawOptions is List) {
        //     return rawOptions.map((e) => e.toString()).join(', ');
        //   }
        //   return rawOptions.toString();
        // })(),
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
      selected: isSelected.value,
      shop: shop,
      options: options,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "cartItemId": cartItemId,
      "productId": productId,
      "variantIds": variantId,
      "title": title,
      "variants": variant.map((v) => v.toJson()).toList(),
      "image": image,
      "quantity": quantity,
      "stock": stock,
      "price": price,
      "subtotal": subtotal,
      "isAvailable": isAvailable,
      "isSelected": isSelected.value,
      "options": options,
      "shop": shop,
    };
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
