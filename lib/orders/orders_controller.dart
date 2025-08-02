import 'package:get/get.dart';
import 'package:theme_desiree/orders/orders_model.dart';

class OrdersController extends GetConnect implements GetxService {
  var orders = <OrdersModel>[].obs;
  var isLoading = true.obs;
  var hasError = false.obs;

  // Method to add a new order
  void addOrder(OrdersModel order) {
    orders.add(order);
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final index = orders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      orders[index].status = newStatus;
      orders.refresh();
    }
  }

  // Optional: Clear all orders
  void clearOrders() {
    orders.clear();
  }

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
}
