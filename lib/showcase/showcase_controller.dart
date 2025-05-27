import 'package:get/get.dart';
import 'package:theme_desiree/showcase/product_model.dart';

class ShowcaseController extends GetConnect implements GetxService {
  var product = Rxn<ProductModel>();
  var isLoading = false.obs;
  var hasError = false.obs;
  var selectedVariant = Rxn<VariantModel>();

  Future<void> fetchProduct(String? id) async {
    isLoading.value = true;
    hasError.value = false;

    try {
      final response = await get("https://api.npoint.io/bd71758417920fd0a243");

      if (response.statusCode == 200) {
        final data = response.body;

        if (data is Map<String, dynamic>) {
          product.value = ProductModel.fromJson(data);
          if (product.value != null && product.value!.variants.isNotEmpty) {
            selectedVariant.value = product.value!.variants.first;
          }
        } else {
          hasError.value = true;
        }
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
      print("Error fetching product: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
