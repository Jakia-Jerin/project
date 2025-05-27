import 'package:get/get.dart';
import 'package:theme_desiree/a/models/product_mini_card.dart';

class SearchResultController extends GetConnect implements GetxService {
  var results = <ProductMiniCardModel>[].obs;
  var isLoading = false.obs;
  var hasError = false.obs;

  Future<void> fetchResult(String query) async {
    isLoading.value = true;
    hasError.value = false;

    try {
      final response = await get("https://api.npoint.io/d7ab967e02751b8db364");

      if (response.statusCode == 200) {
        final data = response.body;
        if (data is Map && data['results'] is List) {
          List<ProductMiniCardModel> dataResults = (data['results'] as List)
              .map((item) => ProductMiniCardModel.fromJson(item))
              .toList();
          results.assignAll(dataResults);
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
