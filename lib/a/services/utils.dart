import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class Utils extends GetConnect {
  Future<String?> downloadFile(String? url, String fileName) async {
    try {
      if (url == null) return null;
      final directory = await getApplicationCacheDirectory();
      final filePath = "${directory.path}/$fileName";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200 || response.statusCode == 304) {
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
