import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:theme_desiree/orders/orders_model.dart';

class OrdersController extends GetConnect implements GetxService {
  var orders = <OrdersModel>[].obs;
  var isLoading = true.obs;
  var hasError = false.obs;

  // Fetch orders
  // Future<void> fetchOrders() async {
  //   final url = Uri.parse("https://app2.apidoxy.com//api/v1/order");
  //   final token = GetStorage().read("accessToken");
  //   try {
  //     isLoading.value = true;

  //     final response = await http.get(
  //       url,
  //       headers: {
  //         "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
  //         "Authorization": "Bearer $token",
  //         "Content-Type": "application/json",
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final jsonBody = jsonDecode(response.body);
  //       final data = jsonBody['data'] as List<dynamic>? ?? [];
  //       orders.value = data.map((json) => OrdersModel.fromJson(json)).toList();
  //       print(response.statusCode);
  //       print(data);
  //     } else {
  //       orders.clear();
  //       hasError.value = true;
  //       print(response.statusCode);
  //       print(response.body);
  //     }
  //   } catch (e) {
  //     print('Error fetching orders: $e');

  //     orders.clear();
  //     hasError.value = true;
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // Fetch orders from API
  Future<void> fetchOrders() async {
    final url = Uri.parse("https://app2.apidoxy.com/api/v1/order");
    final token = GetStorage().read("accessToken");
    final vendorId = dotenv.env['SHOP_ID'] ?? "";

    try {
      isLoading.value = true;
      hasError.value = false;

      final response = await http.get(
        url,
        headers: {
          "x-vendor-identifier": vendorId,
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final data = jsonBody['data'] as List<dynamic>? ?? [];
        data.sort((a, b) => b.placedAt.compareTo(a.placedAt));

        orders
            .assignAll(data.map((json) => OrdersModel.fromJson(json)).toList());

        print(
            '**********************************************************************');
        print(data);

        orders.value = data.map((json) => OrdersModel.fromJson(json)).toList();
        print('--------------------------------------------------------------');
        print("Fetched orders: ${orders.length}");
        print('${response.statusCode}');
      } else {
        print(
            '**********************************************************************');

        orders.clear();
        hasError.value = true;

        print(
            '.....................................................................');
        print(
            '.....................................................................');
        print("${response.statusCode}");
        print("Failed to fetch orders: ${response.statusCode}");
        print(response.body);
      }
    } catch (e) {
      orders.clear();
      hasError.value = true;
      print(
          '.....................................................................');
      print(
          '.....................................................................');

      print("Error fetching orders: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchOrders(); // fetch orders when controller is initialized
  }
}

  // Method to add a new order
  // void addOrder(OrdersModel order) {
  //   orders.add(order);
  // }

  // void updateOrderStatus(String orderId, String newStatus) {
  //   final index = orders.indexWhere((order) => order.id == orderId);
  //   if (index != -1) {
  //     orders[index].status = newStatus;
  //     orders.refresh();
  //   }
  // }

  // // Optional: Clear all orders
  // void clearOrders() {
  //   orders.clear();
  // }

  // Future<void> fetchOrders() async {
  //   isLoading.value = true;
  //   hasError.value = false;

  //   try {
  //     final response = await get("https://api.npoint.io/672eb9a6c136eb73678e");
  //     if (response.statusCode == 200) {
  //       final data = response.body;
  //       if (data is Map && data['orders'] is List) {
  //         List<OrdersModel> dataResults = (data['orders'] as List)
  //             .map((item) => OrdersModel.fromJson(item))
  //             .toList();
  //         orders.assignAll(dataResults);
  //       } else {
  //         hasError.value = true;
  //       }
  //     } else {
  //       hasError.value = true;
  //     }
  //   } catch (e) {
  //     hasError.value = true;
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

