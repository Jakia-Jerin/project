import 'package:get/get.dart';
import 'package:theme_desiree/a/models/caregories.dart';
import 'package:theme_desiree/constants.dart';

class CategoriesController extends GetConnect implements GetxService {
  var categories = <CategoryModel>[].obs;
  var subCategories = <String?>[].obs;
  var selectedCategoryItems = <CategoryModel>[].obs;
  var isLoading = false.obs;
  var hasError = false.obs;
  var isGrid = false.obs;
  var screenWidth = Get.width.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () {
      fetchCategories(null);
    });
  }

  Future<void> fetchCategories(String? handle) async {
    isLoading.value = true;
    try {
      final response = await get("${Constants.host}db4b90596a406d6a2c2f");
      if (response.statusCode == 200) {
        final data = response.body;
        if (data is Map && data['collections'] is List) {
          final List<CategoryModel> respCategories =
              (data['collections'] as List)
                  .map((item) => CategoryModel.fromJson(item))
                  .toList();
          categories.assignAll(respCategories);
        } else {
          hasError.value = true;
        }
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
    } finally {
      selectCategoryItems(handle);
      isLoading.value = false;
    }
  }

  bool selectCategoryItems(String? handle) {
    if (handle == null) {
      selectedCategoryItems
          .assignAll(categories.where((item) => item.parent == null).toList());
      if (selectedCategoryItems.isEmpty) {
        return false;
      } else {
        return true;
      }
    } else {
      final selectedItems =
          categories.where((item) => item.handle == handle).toList();
      if (selectedItems.isNotEmpty) {
        final CategoryModel result = selectedItems.first;
        final tempList =
            categories.where((item) => item.parent == result.id).toList();
        if (tempList.isNotEmpty) {
          selectedCategoryItems.assignAll(tempList);
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    }
  }

  void changeOrientation() {
    isGrid.value = isGrid.value ? false : true;
  }
}
