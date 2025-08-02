import 'package:theme_desiree/a/models/cart.dart';
import 'package:theme_desiree/address/address_model.dart';

class OrdersModel {
  final String id;
  String status;
  final String orderDate;

  final String shippingDate;
  final String paymentMethod;
  final String total;
  final FullAddress? address;
  final List<CartModel> products;

  OrdersModel(
      {required this.id,
      required this.status,
      required this.orderDate,
      required this.shippingDate,
      required this.paymentMethod,
      required this.total,
      required this.products,
      required this.address});

  factory OrdersModel.fromJson(Map<String, dynamic> json) {
    return OrdersModel(
      id: json['id'],
      status: json['Status'],
      orderDate: json['OrderDate'],
      shippingDate: json['ShippingDate'],
      paymentMethod: json['PaymentMethod'],
      total: json['total'],
      products:
          (json['products'] as List).map((e) => CartModel.fromJson(e)).toList(),
      address: FullAddress.fromJson(json['address']),
    );
  }
}

//signup signin(email,phone,password)  then order details

// class OrderProductModel{
//   final String id;
//   final String title;
//   final int quantity;
//   final double price;
//   final String imageUrl;

//   OrderProductModel({
//     required this.id,
//     required this.title,
//     required this.quantity,
//     required this.price,
//     required this.imageUrl,
//   });

//   factory OrderProductModel.fromJson(Map<String, dynamic> json) {
//     return OrderProductModel(
//       id: json['id'],
//       title: json['title'],
//       quantity: json['quantity'],
//       price: json['price'].toDouble(),
//       imageUrl: json['imageUrl'],
//     );
//   }
// }
