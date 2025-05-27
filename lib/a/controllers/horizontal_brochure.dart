import 'package:get/get.dart';
import 'package:theme_desiree/a/models/horizontal_brochure.dart';

class HorizontalBrochureController extends GetxController {
  var isLoading = false.obs;
  var hasError = false.obs;
  var brochure = Rx<HorizontalBrochureModel?>(null);

  Future<void> fromJson(Map<String, dynamic> json) async {
    try {
      isLoading.value = true;
      hasError.value = false;

      if (json['error'] == false && json['data'] != null) {
        brochure.value = HorizontalBrochureModel.fromJson(json['data']);
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
