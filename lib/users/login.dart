import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../application_models.dart';
import '../input_validations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../supporting.dart' as supporting;

class LoginPage extends StatefulWidget {
  final String server;
  const LoginPage({
    super.key,
    required this.server,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _usernameHolder = "";
  InputField password = InputField(
      display: "Password",
      obscureText: true
  );
  bool saveUserDetails = false;
  late final List<InputField> inputs = [password];
  late final List<String> _suggestedUsernames;
  final TextEditingController _usernameController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void _showUsernameSuggestions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: supporting.hexToColor("#222222"),
          title: const Text(
              'Select an Email',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white
            ),
          ),
          content: SizedBox(
            width: 300,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _suggestedUsernames.length,
              itemBuilder: (context, index) {
                final username = _suggestedUsernames[index];
                return InkWell(
                  onTap: () {
                    if (_usernameController.text == "cancel") {
                      return;
                    }
                    _usernameController.text = username;
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                        username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> login() async {

    bool validated = inputValidation(inputs, context);
    if (!validated) {
      return;
    }

    if(_usernameController.text == "") {
      supporting.showPopUp(
          context,
          "Validation Error!",
          "Email not entered"
      );
      return;
    }

    String pass = password.text();
    var headers = {
      'Accept': 'application/json, text/plain, */*',
      "Access-Control-Allow-Origin": "*",
      'Accept-Language': 'en-US,en',
      'Authorization': 'Basic Og=='
    };

    var data = {
      'grant_type': 'password',
      'username': _usernameController.text,
      'password': pass,
    };

    late http.Response response;

    try {
      response = await supporting.postRequest2(
        data,
        widget.server,
        "/token",
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

    headers.update("Authorization",
        (value) => "${token["token_type"]} ${token["access_token"]}");
    headers.putIfAbsent('Content-Type', () => 'application/json');

    String jsonRaw = await supporting.getApiData(
        "/users/me/", widget.server, context,
        headers: headers, delay: 500);
    var json = jsonDecode(jsonRaw);
    User user = User.fromJson(json);
    user.setAuth(headers);

    addUsername(_usernameController.text);

    String? defaultView = supporting.map[user.defaultView];

    Navigator.pushNamed(
        context,
        defaultView ?? "/logged_in",
        arguments: {
          "user": user,
          "server": widget.server,
        }
    );
  }

  void initialiseUsername() async {
    _suggestedUsernames = await _prefs.then((SharedPreferences prefs) {
      return prefs.getStringList('emails') ?? [];
    });
  }

  void addUsername(String value) async {

    if(!_suggestedUsernames.contains(value)) {
      _suggestedUsernames.add(value);
    }

    final SharedPreferences prefs = await _prefs;
    await prefs.setStringList('emails', _suggestedUsernames);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialiseUsername();
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
                        fontSize: 30),
                    )
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                    child: TextField(
                      controller: _usernameController,
                      cursorColor: Colors.red,
                      onChanged: (value) => _usernameHolder = value,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                      onTap: () {

                        if (_suggestedUsernames.isEmpty) {
                          return;
                        }
                        _showUsernameSuggestions(context);
                      },
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
                        labelText: "Email*",
                        labelStyle: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    // child: username.inputField,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: password.inputField,
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
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: 50,
                    child: CheckboxListTile(
                      title: const Text(
                        "Remember me?",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                      // activeColor: Colors.white,
                      selectedTileColor: Colors.red,
                      checkColor: Colors.white,
                      value: saveUserDetails,
                      fillColor: MaterialStateProperty.all<Color>(Colors.red),
                      hoverColor: Colors.red[100],
                      onChanged: (bool? value) {
                        setState(() {
                          saveUserDetails = value ?? false;
                        });
                      },
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
          status: "DISABLED",
          department: Department(
            dId: 0,
            name: "name",
            defaultView: "defaultView",
            ticketable: false,
            submittedBy: "submittedBy",
            modules: [],
            accessibleTickets: [],
            ticketsRaisedFrom: [],
            nonTicketableReports: [],
            ticketableReports: [],
            ticketCategories: {}
          ),
          email: "email",
          number: "number",
          location: "location",
          defaultView: "",
          socialMedia: ""
        ),
        widget.server,
        appBar: false
    );
  }
}
