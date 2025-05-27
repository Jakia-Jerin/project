import 'package:get/get.dart';
import 'package:theme_desiree/a/models/faq.dart';

class FaqController extends GetConnect implements GetxService {
  var faqs = <Faq>[].obs;
  var isLoading = false.obs;
  var hasError = false.obs;

  Future<void> fromJson(Map<String, dynamic> json) async {
    isLoading.value = true;
    try {
      if (json['data'] is List) {
        final List<Faq> tempFaqs = (json['data'] as List)
            .map((item) => Faq.fromJson(item as Map<String, dynamic>))
            .toList();
        faqs.assignAll(tempFaqs);
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
