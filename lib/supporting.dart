import 'dart:async';
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

Future<String> getApiData(String path, String domain, String protocol, dynamic context) async {
  ProgressDialog pd = ProgressDialog(context: context);
  pd.show(
      msg: 'Loading',
      progressType: ProgressType.valuable,
      backgroundColor: supporting.hexToColor("#222222"),
      progressValueColor: supporting.hexToColor("#222222"),
      progressBgColor: Colors.red,
      msgColor: Colors.white,
      valueColor: Colors.white
  );
  var uri = Uri.parse('$protocol://$domain/$path');
  var response = await http.get(uri);

  pd.close(delay: 1000);
  await Future.delayed(const Duration(seconds: 1));
  int code = response.statusCode;
  if(code != 200) {
    String details = "Details:\n";

    String body = response.body;
    var json = jsonDecode(body)["detail"];
    if (json == null) {
      showPopUp(context, "Error $code!", "Contact admin");
    } else {
      for(var x in json) {
        String type = x["type"];
        String msg = x["msg"];

        details += "Type: $type, $msg\n";
      }
    }

    showPopUp(context, "Error $code!", details);
  }

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

void showPopUp(BuildContext context, String title, String message) {
  showDialog(
      context: context,
      builder:  (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18
            ),
          ),
          content: Text(
            message,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18
            ),
          ),
          backgroundColor: supporting.hexToColor("#222222"),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 17
                ),
              ),
            ),
          ],
        );
      }
  );
}

class CustomRequest {
  final http.Client client = http.Client();
  late final http.Request request;

  CustomRequest(String method, String url, var json, var headers) {
    request = http.Request(method, Uri.parse(url));
    String jsonBody = jsonEncode(json);
    request.headers.addAll(headers);
    request.body = jsonBody;
  }

  Future<http.StreamedResponse> send(BuildContext context) async {
    final response = await client.send(request);
    return response;
  }
}

Future<void> postRequest(
    var data, String protocol, String domain, String path, dynamic context,
    {var headers = const {'Content-Type': 'application/json'}}
    ) async {

  ProgressDialog pd = ProgressDialog(context: context);
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

  CustomRequest req = CustomRequest("POST", url, data, headers);

  late final http.StreamedResponse response;
  try {
    response = await req.send(context);
  } on Exception catch (e) {
    pd.close(delay: 1000);
    await Future.delayed(const Duration(seconds: 1));
    showPopUp(context, "Error", "Something went wrong: $e");
    return;
  }

  pd.close(delay: 1000);

  await Future.delayed(const Duration(seconds: 1));

  int code = response.statusCode;
  if(code == 200) {
    showPopUp(context, "Nice!", "Ticket Submitted");
  } else {
    String details = "Details:\n";

    String body = await response.stream.transform(utf8.decoder).join();
    var json = jsonDecode(body)["detail"];
    if (json == null) {
      showPopUp(context, "Error $code!", "Contact admin");
    } else {
      for(var x in json) {
        String type = x["type"];
        String msg = x["msg"];

        details += "Type: $type, $msg\n";
      }
    }

    showPopUp(context, "Error $code!", details);
  }
}