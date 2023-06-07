import 'package:flutter/material.dart';
import 'application_models.dart';
import 'supporting.dart' as supporting;

class LoginPage extends StatefulWidget {
  User user;
  final String domain;
  final String protocol;
  LoginPage({
    super.key,
    required this.user,
    required this.domain,
    required this.protocol
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
      widget.user = User(
        id: 1, name: "Nishaal", department: "Not IT",
        email: 'dawk@dork.com', number: '123', location: 'here'
      );
    });
    Navigator.pushNamed(
      context, "/create_ticket"
    );
  }

  @override
  Widget build(BuildContext context) {
    return supporting.getScaffold(
      Container(
        color: Colors.black87,
        child: Padding(
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
      ), appBar: false
    );
  }
}
