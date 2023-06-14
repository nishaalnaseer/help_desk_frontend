import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

// import 'package:help_desk_frontend/supporting.dart' as supporting;

import 'package:flutter/material.dart';

import 'application_models.dart';

const Map<String, String> map = {
  "Create Ticket": '/create_ticket',
  "View Tickets": '/view_tickets',
  // "Devices": devices,
  // "Models": modelsScreen,
  // "Reports": reports,
};

Map<String, dynamic> convertDynamicToMap(dynamic object) {
  if (object is Map<String, dynamic>) {
    return object;
  }

  if (object is String) {
    return jsonDecode(object);
  }

  throw Exception('Failed to convert dynamic to Map<String, dynamic>.');
}

Future<String> getApiData(String path, String domain,
    String protocol, dynamic context, {
      var headers = const {'Content-Type': 'application/json'},
      int delay = 0
  }) async {
  ProgressDialog pd = ProgressDialog(context: context);
  pd.show(
      msg: 'Loading',
      progressType: ProgressType.valuable,
      backgroundColor: hexToColor("#222222"),
      progressValueColor: hexToColor("#222222"),
      progressBgColor: Colors.red,
      msgColor: Colors.white,
      valueColor: Colors.white
  );
  var uri = Uri.parse('$protocol://$domain/$path');
  var response = await http.get(uri, headers: headers);

  pd.close(delay: delay);
  await Future.delayed(const Duration(seconds: 1));
  int code = response.statusCode;
  if(code != 200) {
    String details = "Details:\n";

    String body = response.body;
    var json = jsonDecode(body)["detail"];
    if (json == null) {
      showPopUp(context, "Error $code!", "Contact admin");
    } else {

      try {
        for(var x in json) {
          String type = x["type"];
          String msg = x["msg"];

          details += "Type: $type, $msg\n";
        }
      } on TypeError catch (e) {
        details = json;
        showPopUp(context, "Error $code!", details);
        throw HttpException("Code $code");
      } catch (e) {
        // Catch other types of exceptions
        details = 'An unexpected exception occurred: $e';
        showPopUp(context, "Error $code!", details);
        return jsonEncode({[]});
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
          backgroundColor: hexToColor("#222222"),
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

Future<http.StreamedResponse> postRequest(
    var data, String protocol, String domain, String path,
    dynamic context,
    {var headers = const {'Content-Type': 'application/json'}}
    ) async {

  ProgressDialog pd = ProgressDialog(context: context);
  String url = '$protocol://$domain/$path';

  pd.show(
      msg: 'Loading',
      progressType: ProgressType.valuable,
      backgroundColor: hexToColor("#222222"),
      progressValueColor: hexToColor("#222222"),
      progressBgColor: Colors.red,
      msgColor: Colors.white,
      valueColor: Colors.white
  );

  CustomRequest req = CustomRequest("POST", url, data, headers);

  late final http.StreamedResponse response;
  try {
    response = await req.send(context);
  } on Exception catch (e) {
    pd.close(delay: 0);
    await Future.delayed(const Duration(seconds: 1));
    showPopUp(context, "Error", "Something went wrong: $e");
    return response;
  }

  pd.close(delay: 0);

  await Future.delayed(const Duration(seconds: 1));

  int code = response.statusCode;
  if(code == 200) {
    showPopUp(context, "Nice!", "Ticket Submitted");
    return response;
  } else {
    String details = "Details:\n";

    String body = await response.stream.transform(utf8.decoder).
    join();
    var json = jsonDecode(body)["detail"];
    if (json == null) {
      showPopUp(context, "Error $code!", "Contact admin");
    } else {

      try {
        for(var x in json) {
          String type = x["type"];
          String msg = x["msg"];

          details += "Type: $type, $msg\n";
        }
      } on TypeError catch (e) {
        details = json;
      } catch (e) {
        // Catch other types of exceptions
        details = 'An unexpected exception occurred: $e';
      }
    }

    showPopUp(context, "Error $code!", details);
    return response;
  }
}

Future<http.Response> postRequest2(
    var data, String protocol, String domain, String path,
    dynamic context,
    {
      var headers = const {'Content-Type': 'application/json'},
      bool showPrompt = false, String promptTitle = "",
      String promptMessage = ""
    }
    ) async {

  ProgressDialog pd = ProgressDialog(context: context);
  Uri url = Uri.parse('$protocol://$domain/$path');

  pd.show(
      msg: 'Loading',
      progressType: ProgressType.valuable,
      backgroundColor: hexToColor("#222222"),
      progressValueColor: hexToColor("#222222"),
      progressBgColor: Colors.red,
      msgColor: Colors.white,
      valueColor: Colors.white
  );

  late http.Response response;

  try {
    response = await http.post(
        url, headers: headers, body: data
    );
  } on Exception catch (e) {
    pd.close(delay: 0);
    await Future.delayed(const Duration(seconds: 1));
    showPopUp(context, "Error", "Something went wrong: $e");
    throw Exception("Something went wrong: $e");
  }

  pd.close(delay: 0);

  await Future.delayed(const Duration(seconds: 1));

  int code = response.statusCode;
  if(code == 200) {
    if(showPrompt) {
      showPopUp(context, promptTitle, promptMessage);
    }
    return response;
  } else if (code > 499) {
    showPopUp(context, "Error", "Details: code $code");
    return response;
  } else {
    String details = "Details:\n";

    String body = response.body;
    var json = jsonDecode(body)["detail"];
    if (json == null) {
      showPopUp(context, "Error $code!", "Contact admin");
    } else {
      try {
        for(var x in json) {
          String field = x["loc"][1];
          String type = x["type"];
          String msg = x["msg"];

          details += "Type: $type, $msg: $field\n";
        }
      } on TypeError catch (e) {
        details = json;
      } catch (e) {
        // Catch other types of exceptions
        details = 'An unexpected exception occurred: $e';
      }
    }

    showPopUp(context, "Error $code!", details);
    return response;
  }
}

List<Widget> getDrawerKids(User user, BuildContext context) {
  List<Widget> children = [];
  for(String name in user.modules) {
    String? route = map[name];
    if (route == null) {
      continue;
    }

    Widget child = Padding(
      padding: const EdgeInsets.all(3),
      child: ListTile(
        // tileColor: Colors.red[100], // Change the background color here
        title: Center(
          child: Text(
            name,
            style: const TextStyle(
              color: Colors.white, // Change the text color here
              fontSize: 21,
              fontWeight: FontWeight.w500
            ),
          ),
        ),
        onTap: () {
          Navigator.pushNamed(
              context, route, arguments: user
          );
        },
      ),
    );
    children.add(child);
  }

  return children;
}

class DrawerNavigation extends StatelessWidget {
  final User user;
  const DrawerNavigation({super.key, required this.user});
  final TextStyle style = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontSize: 18
  );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: hexToColor("#222222"),
      child: Column(
        children: [
          Expanded(
            flex: 80,
            child: ListView(
              children: getDrawerKids(user, context),
            ),
          ),
          Expanded(
            flex: 20,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.settings,
                        color: Colors.red,
                      ),
                      title: Text(
                        'Settings',
                        style: style,
                      ),
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, '/settings'
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.person,
                        color: Colors.red,
                      ),
                      title: Text(
                        'Profile',
                        style: style,
                      ),
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/profile');
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                      title: Text(
                        'Log Out',
                        style: style,
                      ),
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, '/login'
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Scaffold getScaffold(
    Widget thingy, User user, {bool appBar = true})
  {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  return Scaffold(
    appBar: appBar ? AppBar(
      key: scaffoldKey,
      backgroundColor: Colors.red[900],
      // leading: IconButton(
      //   icon: const Icon(
      //     Icons.menu,
      //     color: Colors.white,
      //   ),
      //   tooltip: 'Menu',
      //   onPressed: () {
      //     Scaffold.of(context).openDrawer();
      //   },
      // ),
      elevation: 0,
      titleSpacing: 0,
      title: const Text(
          "Ticketing",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500
          )
      ),
    ) : null,

    drawer: DrawerNavigation(user: user),
    backgroundColor: hexToColor("#222222"),
    body: thingy,
  );

}