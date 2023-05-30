
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'app_base.dart';

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
        primarySwatch: Colors.purple,
        useMaterial3: true,
      ),

      home: Scaffold (
        appBar: AppBar(
          title: const Text(_title),
          backgroundColor: Colors.purple[400],
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
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context){
            return AppBase(
              protocol: protocol,
              domain: domain
            );
          }),
      );
    });
  }

  Future<void> readConfig() async {
    File file = File("assets/config.json");

    Future<String> contents = file.readAsString();
    var coded = jsonDecode( await contents);
    domain = coded["domain"];
    protocol = coded["protocol"];
  }

  @override
  void initState() {
    super.initState();

    readConfig();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple[50],
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
                          color: Colors.blue,
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
                      style: TextStyle(fontSize: 20),
                    )
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                  child: TextField(
                    controller: nameController,
                    onChanged: (value) => username = value,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'User Name',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    onChanged: (value) => password = value,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () { login(); },
                    child: const Text(
                      "Login",
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    //forgot password screen
                  },
                  child: const Text('Forgot Password',),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}