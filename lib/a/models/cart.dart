class CartModel {
  final String productId;
  final String? variantId;
  final String? title;
  final String? variant;
  final String? image;
  late int quantity;
  final int? stock;
  final num? price;
  final bool? isAvailable;

  CartModel({
    required this.productId,
    required this.variantId,
    required this.title,
    required this.variant,
    required this.image,
    required this.quantity,
    required this.stock,
    required this.price,
    required this.isAvailable,
  });

  /// Updated fromJson to handle Get User Cart API
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      productId:
          json['productId'] ?? json['_id'] ?? '', // যদি productId না থাকে
      variantId: json['variantId']?.toString(),
      title: json['title'] ?? json['productTitle'] ?? '',
      variant: json['variant'] != null && json['variant'] is Map
          ? json['variant'].toString()
          : '',
      image: json['image'] ?? '', // null হলে empty string
      quantity: json['quantity'] ?? 1,
      stock: json['stock'] != null ? int.tryParse(json['stock'].toString()) : 0,
      price: json['price'] ?? 0,
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  CartModel copy() {
    return CartModel(
      productId: productId,
      variantId: variantId,
      title: title,
      variant: variant,
      image: image,
      quantity: quantity,
      stock: stock,
      price: price,
      isAvailable: isAvailable,
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
