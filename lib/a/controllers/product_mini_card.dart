import 'package:get/get.dart';
import 'package:theme_desiree/a/models/product.dart';

class ProductMiniCardController extends GetConnect implements GetxService {
  var product = Rx<Product?>(null);
  var isLoading = false.obs;
  var hasError = false.obs;

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
