import 'package:get/get.dart';
import 'package:theme_desiree/a/models/product_mini_card.dart';

class ProductCollageController extends GetConnect implements GetxService {
  var products = <ProductMiniCardModel>[].obs;
  var isLoading = false.obs;
  var hasError = false.obs;

  Future<void> fromJson(Map<String, dynamic> json) async {
    try {
      isLoading.value = true;
      if (json['error'] == false && (json['data'] is List)) {
        final tempProducts = (json['data'] as List)
            .map(
              (item) => ProductMiniCardModel.fromJson(item),
            )
            .toList();
        products.assignAll(tempProducts);
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
