import 'package:flutter/material.dart';

import 'login.dart';
import 'create_ticket.dart';
import 'view_tickets.dart';
import 'view_ticket.dart';
import 'application_models.dart';
import 'supporting.dart' as supporting;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';
import 'dart:io';

late String protocol;
late String domain;
List<String> modules = [];
late User user;

void main() async {

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
    String contents = await file.readAsString();
    var coded = jsonDecode(contents);
    domain = coded["domain"];
    protocol = coded["protocol"];
  }

  runApp(const DrawerNavigationApp());
}

Text? assignUserData(dynamic args,) {
  // dynamic arguments = ModalRoute.of(context)?.settings.arguments;
  Map<String, dynamic> argumentsMap = Map<String, dynamic>.from(args);
  if(argumentsMap["modules"] == null) {
    return const Text("Error no module");
  } else {
    modules = argumentsMap["modules"];
  }
  if(argumentsMap["user"] == null) {
    return const Text("Error no user");
  } else {
    user = argumentsMap["user"];
  }
  return null;
}

class DrawerNavigationApp extends StatelessWidget {
  const DrawerNavigationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drawer Navigation App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true,
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: MaterialStateProperty.all<Color>(Colors.red),
          trackColor: MaterialStateProperty.all<Color>(Colors.red.withOpacity(0.3)),
          crossAxisMargin: 8,
          mainAxisMargin: 8,
          minThumbLength: 48,
        ),
      ),
      home: LoginPage(
          domain: domain,
          protocol: protocol,
      ),
      routes: {
        '/settings': (context) => SettingsPage(
            args: {
              "user": user,
              "modules": modules
            }),

        '/profile': (context) => ProfilePage(
            args: {
              "user": user,
              "modules": modules
            }),

        '/login': (context) => LoginPage(
            domain: domain,
            protocol: protocol,
        ),

        '/logged_in': (context) {
          Text? error = assignUserData(
              ModalRoute.of(context)?.settings.arguments
          );
          if(error != null) {
            return error;
          }

          return CreateTicket(
              user: user,
              modules: modules,
              domain: domain,
              protocol: protocol
          );
        },

        '/create_ticket': (context) {
          Text? error = assignUserData(
              ModalRoute.of(context)?.settings.arguments
          );
          if(error != null) {
            return error;
          }

          return CreateTicket(
              user: user,
              modules: modules,
              domain: domain,
              protocol: protocol
          );
        },

        '/view_tickets': (context) {

          return ViewTickets(
              args: {
                "modules": modules,
                "user": user
              },
              domain: domain,
              protocol: protocol
          );
        },

        '/view_ticket': (context) {
          dynamic args = ModalRoute.of(context)?.settings.arguments;
          int tID = args["tID"];
          return ViewTicket(
              args: {
                "modules": modules,
                "user": user
              },
              ticketId: tID,
              domain: domain,
              protocol: protocol
          );
        },
      },
    );
  }
}

class MainPage extends StatelessWidget {
  final Map<String, dynamic> args;
  const MainPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: supporting.DrawerNavigation(args: args,),
      body: const Center(
        child: Text(
          'Home Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  final Map<String, dynamic> args;
  const SettingsPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      drawer: supporting.DrawerNavigation(args: args),
      body: const Center(
        child: Text(
          'Settings Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final Map<String, dynamic> args;
  const ProfilePage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      drawer: supporting.DrawerNavigation(args: args),
      body: const Center(
        child: Text(
          'Profile Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}