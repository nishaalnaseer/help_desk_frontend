import 'dart:convert';
import 'dart:io';


// import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';

import 'app_base.dart';
import 'application_models.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Ticketing';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      // primaryColour:
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        primarySwatch: Colors.red,
        useMaterial3: true,
      ),// Set the navigatorKey

      home: Scaffold (
        appBar: AppBar(
          title: const Text(
            _title,
            style: TextStyle(
              color: Colors.white
            ),
          ),
          backgroundColor: Colors.red[900],
        ),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String warning = '';

  late String username = "";
  late String password = "";

  late String domain;
  late String protocol;

  Future<void> login() async {
    setState(() {
      passwordController.clear();  // clear
      nameController.clear();  // clear
      warning = "";  // clear
      User user = User(id: 1, name: "Nishaal", department: "Not IT", email: 'dawk@dork.com', number: '123', location: 'here');
      Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context){
          return AppBase(
            protocol: protocol,
            domain: domain,
            user: user,
          );
        }),
      );
    });
  }

  Future<void> readConfig() async {
    late Future<String> contents;

    if (kIsWeb) {
      // html.HttpRequest.getString('assets/data.json').then((String jsonString) {
      //   final coded = jsonDecode(jsonString);
      //   domain = coded["domain"];
      //   protocol = coded["protocol"];
      // }).catchError((error) {
      //    print("erroe");
      // });

    } else {
      File file = File("assets/config.json");
      contents = file.readAsString();
      var coded = jsonDecode( await contents);
      domain = coded["domain"];
      protocol = coded["protocol"];
    }
  }

  @override
  void initState() {
    super.initState();
    readConfig();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Padding(
        padding: const EdgeInsets.all(10),
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
                    onPressed: () { login(); },
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
    );
  }
}