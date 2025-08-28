import 'package:get/get.dart';
import 'package:theme_desiree/a/models/product.dart';

class ProductMiniCardController extends GetConnect implements GetxService {
  var product = Rx<Product?>(null);
  var isLoading = false.obs;
  var hasError = false.obs;

//  Future<void> fetchProduct(String productId) async {
//   try {
//     isLoading.value = true;
//     hasError.value = false;

//     final url = "https://app2.apidoxy.com/api/v1/products/details/{productId}";

//     final response = await get(
//       url,
//       headers: {
//          "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? " ",

//         "Content-Type": "application/json",
//       },
//     );

//     if (response.statusCode == 200) {
//       final data = response.body;
//       if (data is Map) {
//         product.value = Product.fromJson(
//           Map<String, dynamic>.from(data),
//         );
//       } else {
//         hasError.value = true;
//       }
//     } else {
//       hasError.value = true;
//     }
//   } catch (e) {
//     hasError.value = true;
//     print("Error fetching product: $e");
//   } finally {
//     isLoading.value = false;
//   }
// }
  Future<void> fetchProduct(String id) async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final response =
          await get("https://api.npoint.io/bd71758417920fd0a243/?id=$id");

      if (response.statusCode == 200) {
        final data = response.body;
        if (data is Map) {
          product.value = Product.fromJson(
            Map<String, dynamic>.from(data),
          );
        } else {
          hasError.value = true;
        }
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }
}
