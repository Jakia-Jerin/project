import 'package:get/get.dart';
import 'package:theme_desiree/a/models/cart.dart';

class CartController extends GetConnect implements GetxService {
  var products = <CartModel>[].obs;
  var isLoading = false.obs;
  var hasError = false.obs;

  double vat = 50.0;
  double deliveryCharge = 120.0;

  void addProduct({
    productId,
    variantId,
    title,
    variant,
    image,
    quantity = 1,
    stock,
    price,
    isAvailable,
  }) {
    products.add(CartModel(
      productId: productId,
      variantId: variantId,
      title: title,
      variant: variant,
      image: image,
      quantity: quantity,
      stock: stock,
      price: price,
      isAvailable: isAvailable,
    ));
  }

  // Future<void> fetchCartAvailability() async {
  //   isLoading.value = false;
  //   hasError.value = false;

  //   try {
  //     final response = await get("https://api.npoint.io/2bafabe8fcfc20b31aee");
  //     if (response.statusCode == 200) {
  //       final data = response.body;
  //       if (data is Map && data['products'] is List) {
  //         List<CartModel> dataResults = (data['products'] as List)
  //             .map((item) => CartModel.fromJson(item))
  //             .toList();
  //         products.assignAll(dataResults);
  //       } 
  //       else {
  //         hasError.value = true;
  //       }
  //     } 
  //        
  //       else {
  //       hasError.value = true;
  //     }
  //   } 
  //
  //
  //    catch (e) {
  //     hasError.value = true;
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  double calculateTotal() {
    double total =
        products.fold(0, (sum, item) => sum + (item.price! * item.quantity));
    return total + vat + deliveryCharge;
  }

  //Recipt

  double subtotal() {
    double productotal =
        products.fold(0, (sum, item) => sum + (item.price! * item.quantity));
    return productotal;
  }

  double recipttotal() {
    double productotal =
        products.fold(0, (sum, item) => sum + (item.price! * item.quantity));
    return productotal + vat + deliveryCharge;
  }

  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchCartAvailability();
  // }
}
