import 'package:flutter/material.dart';
import 'package:help_desk_frontend/login.dart';
import 'package:help_desk_frontend/create_ticket.dart';
import 'supporting.dart' as supporting;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';
import 'dart:io';

import 'application_models.dart';

late String protocol;
late String domain;

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
          user: User(
            id: 0,
            name: '',
            department: '',
            email: '',
            number: '',
            location: '',
          ),
          domain: domain,
          protocol: protocol
      ),
      routes: {
        '/settings': (context) => const SettingsPage(),
        '/profile': (context) => const ProfilePage(),
        '/login': (context) => LoginPage(
            user: User(
              id: 0,
              name: '',
              department: '',
              email: '',
              number: '',
              location: '',
            ),
            domain: domain,
            protocol: protocol
        ),
        '/create_ticket': (context) => CreateTicket(
            user: User(
              id: 0,
              name: '',
              department: '',
              email: '',
              number: '',
              location: '',
            ),
            domain: domain,
            protocol: protocol
        )
      },
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: supporting.DrawerNavigation(),
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
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      drawer: supporting.DrawerNavigation(),
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
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      drawer: supporting.DrawerNavigation(),
      body: const Center(
        child: Text(
          'Profile Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}