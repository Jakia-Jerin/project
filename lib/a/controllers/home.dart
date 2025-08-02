import 'package:get/get.dart';
import 'package:theme_desiree/a/models/section.dart';

class HomeController extends GetConnect implements GetxService {
  var sections = <SectionModel>[].obs;
  var hasError = false.obs;
  var isLoading = false.obs;

  Future<void> fetchSections() async {
    try {
      isLoading.value = true;
      final response = await get("https://api.npoint.io/dd35eaeac9648765649d");
      if (response.statusCode == 200) {
        final data = response.body;
        if (data is Map && data.containsKey('sections')) {
          final List<SectionModel> tempData =
              (data['sections'] as List<dynamic>)
                  .map((item) => SectionModel.fromJson(item))
                  .toList();
          sections.assignAll(tempData);
        } else {
          hasError.value = true;
        }
      } 
      else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () {
      fetchSections();
    });
  }
}
