import 'dart:convert';
import 'package:http/http.dart' as http;

Map<String, dynamic> convertDynamicToMap(dynamic object) {
  if (object is Map<String, dynamic>) {
    return object;
  }

  if (object is String) {
    return jsonDecode(object);
  }

  throw Exception('Failed to convert dynamic to Map<String, dynamic>.');
}

Future<String> getApiData(String path, String domain, String protocol) async {
  var uri = Uri.parse('$protocol://$domain/$path');
  var response = await http.get(uri);
  return response.body;
}