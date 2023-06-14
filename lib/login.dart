import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'application_models.dart';

import 'supporting.dart' as supporting;

class LoginPage extends StatefulWidget {
  final String domain;
  final String protocol;
  const LoginPage({
    super.key,
    required this.domain,
    required this.protocol,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String username = "";
  String password = "";

  Future<void> login() async {
    nameController.text = "nishawl.naseer@outlook.com";
    passwordController.text = "\$2b\$12\$E6WQteQYd.kIY01.kfPa3u1Kg3r5s0VrpxmGG2mjnFo7z84fwy.Q2";

    String email = nameController.text;
    String password = passwordController.text;

    passwordController.clear();  // clear
    nameController.clear();  // clear
    var headers = {
      'Accept': 'application/json, text/plain, */*',
      "Access-Control-Allow-Origin": "*",
      'Accept-Language': 'en-US,en',
      'Authorization': 'Basic Og==',
      'Connection': 'keep-alive',
      'Origin': 'http://127.0.0.1:8000',
      'Referer': 'http://127.0.0.1:8000/docs',
      'Sec-Fetch-Dest': 'empty',
      'Sec-Fetch-Mode': 'cors',
      'Sec-Fetch-Site': 'same-origin',
      'Sec-GPC': '1',
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36',
      'X-Requested-With': 'XMLHttpRequest',
      'sec-ch-ua': '"Not.A/Brand";v="8", "Chromium";v="114", "Brave";v="114"',
      'sec-ch-ua-mobile': '?0',
      'sec-ch-ua-platform': '"Windows"',
    };

    var data = {
      'grant_type': 'password',
      'username': email,
      'password': password,
    };

    late http.Response response;

    try {
      response = await supporting.postRequest2(
          data,
          widget.protocol,
          widget.domain,
          "token",
          headers: headers,
          context,
          showPrompt: false
      );
    } on Exception catch (e) {
      return;
    }

    if (response.statusCode != 200) {
      return;
    }
    var token = jsonDecode(response.body);

    headers.update("Authorization", (value) =>
      "${token["token_type"]} ${token["access_token"]}");
    headers.putIfAbsent('Content-Type', () => 'application/json');

    String jsonRaw = await supporting.getApiData(
        "users/me/",
        widget.domain,
        widget.protocol,
        context,
        headers: headers,
        delay: 500
    );
    var json = jsonDecode(jsonRaw);
    User user = User.fromJson(json);
    user.setAuth(headers);

    String? defaultView = supporting.map[user.defaultView];

    if(defaultView == null) {
      Navigator.pushNamed(context, "/logged_in", arguments: user);
      return;
    }

    Navigator.pushNamed(context, defaultView, arguments: user);
  }

  @override
  Widget build(BuildContext context) {
    return supporting.getScaffold(
      Padding(
        padding: const EdgeInsets.all(75),
        child: Center(
          child: SizedBox(
            width: 400,
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(10, 100, 10, 10),
                    child: const Text(
                      'Ticketing System',
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w500,
                          fontSize: 30
                      ),
                    )
                ),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20
                      ),
                    )
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                  child: TextField(
                    cursorColor: Colors.red,
                    controller: nameController,
                    onChanged: (value) => username = value,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18
                    ),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red), // Change the color here
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red), // Change the color here
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red), // Change the color here
                      ),
                      label: Text(
                        "Email",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    cursorColor: Colors.red,
                    controller: passwordController,
                    obscureText: true,
                    style: const TextStyle(
                        color: Colors.white
                    ),
                    onChanged: (value) => password = value,
                    decoration: const InputDecoration(
                      label: Text(
                        "Password",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17
                        ),
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red), // Change the color here
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red), // Change the color here
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red), // Change the color here
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      login();
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    //forgot password screen
                  },
                  child: const Text(
                    'Forgot Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      User(
        id: -1,
        name: "name",
        department: "department",
        email: "email",
        number: "number",
        location: "location",
        accessibleReports: [],
        accessibleTickets: [],
        modules: [],
        defaultView: "",
        ticketableDepartments: [], ticketsFrom: []
      ),
      appBar: false
    );
  }
}
