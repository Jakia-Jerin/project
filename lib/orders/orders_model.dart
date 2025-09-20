import 'package:theme_desiree/a/models/cart.dart';
import 'package:theme_desiree/a/models/cart_total.dart';
import 'package:theme_desiree/address/address_model.dart';

class OrdersModel {
  final String id; // _id
  final String orderId; // e.g. ORD-100045
  String status; // orderStatus
  final DateTime placedAt; // order placed date
  final String paymentMethod; // cod / online
  final String paymentStatus; // pending / paid
  final Totals totals; // subtotal, tax, deliveryCharge, grandTotal
  final FullAddress? address; // shipping.address
  final List<CartModel> products; // items list

  OrdersModel({
    required this.id,
    required this.orderId,
    required this.status,
    required this.placedAt,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.totals,
    required this.products,
    required this.address,
  });

  factory OrdersModel.fromJson(Map<String, dynamic> json) {
    return OrdersModel(
      id: json['_id'] ?? '',
      orderId: json['orderId'] ?? '',
      status: json['orderStatus'] ?? '',
      placedAt: json['placedAt'] != null
          ? DateTime.tryParse(json['placedAt']) ?? DateTime.now()
          : DateTime.now(),
      // placedAt: DateTime.tryParse(json['placedAt'] ?? '') ?? DateTime.now(),
      paymentMethod: json['payment']?['method'] ?? '',
      paymentStatus: json['payment']?['status'] ?? '',
      totals: Totals.fromJson(json['totals'] ?? {}),
      products: (json['items'] as List? ?? [])
          .map((e) => CartModel.fromJson(e))
          .toList(),

      address: json['shipping']?['address'] != null
          ? FullAddress.fromJson({
              ...json['shipping']['address'],
              "phone": json['shipping']
                  ['phone'], // phone ta address er sathe merge
            })
          : null,

      // address: json['shipping']?['address'] != null
      //     ? FullAddress.fromJson(json['shipping']['address'])
      //     : null,
    );
  }
}

// class OrdersModel {
//   final String id;
//   String status;
//   final String orderDate;

//   final String shippingDate;
//   final String paymentMethod;
//   final num total;
//   final FullAddress? address;
//   final List<CartModel> products;

//   OrdersModel(
//       {required this.id,
//       required this.status,
//       required this.orderDate,
//       required this.shippingDate,
//       required this.paymentMethod,
//       required this.total,
//       required this.products,
//       required this.address});

//   factory OrdersModel.fromJson(Map<String, dynamic> json) {
//     return OrdersModel(
//       id: json['id'],
//       status: json['Status'],
//       orderDate: json['OrderDate'],
//       shippingDate: json['ShippingDate'],
//       paymentMethod: json['PaymentMethod'],
//       total: json['total'],
//       products:
//           (json['products'] as List).map((e) => CartModel.fromJson(e)).toList(),
//       address: FullAddress.fromJson(json['address']),
//     );
//   }
// }

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
