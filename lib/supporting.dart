import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

import 'package:help_desk_frontend/supporting.dart' as supporting;


import 'package:flutter/material.dart';

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

double getWindowHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double getWindowWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

Color hexToColor(String hexString) {
  final hexCode = hexString.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

Future<int> postRequest(
    var data, String protocol, String domain, String path, dynamic context,
    {var headers = const {'Content-Type': 'application/json'}}
    ) async {

  ProgressDialog pd = ProgressDialog(context: context);

  String jsonBody = jsonEncode(data);
  String url = '$protocol://$domain/$path';

  pd.show(
      msg: 'Loading',
      progressType: ProgressType.valuable,
      backgroundColor: supporting.hexToColor("#222222"),
      progressValueColor: supporting.hexToColor("#222222"),
      progressBgColor: Colors.red,
      msgColor: Colors.white,
      valueColor: Colors.white
  );
  http.Response response = await http.post(
      Uri.parse(url), headers: headers, body: jsonBody
  );
  pd.close(delay: 1000);

  return response.statusCode;
}