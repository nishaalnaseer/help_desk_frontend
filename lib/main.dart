import 'package:flutter/material.dart';

import 'departments/view_departments.dart';
import 'users/login.dart';
import 'tickets/create_ticket.dart';
import 'tickets/view_tickets.dart';
import 'tickets/view_ticket.dart';
import 'application_models.dart';
import 'users/view_users.dart';
import 'supporting.dart' as supporting;

import 'package:flutter/foundation.dart' show kIsWeb;

// TODO give hints to mandatory text fields with *

late String protocol;
late String domain;
List<String> modules = [];
late User user;

void main() async {
  if (kIsWeb) {
    domain = "nishawl.ddns.net";
    protocol = "https";
    // domain = "localhost:8000";
    // protocol = "http";
  } else {
    // domain = "nishawl.ddns.net";
    // protocol = "https";
    domain = "localhost:8000";
    protocol = "http";
  }

  runApp(const DrawerNavigationApp());
}

Text? assignUserData(
  dynamic args,
) {
  // dynamic arguments = ModalRoute.of(context)?.settings.arguments;
  Map<String, dynamic> argumentsMap = Map<String, dynamic>.from(args);
  if (argumentsMap["modules"] == null) {
    return const Text("Error no module");
  } else {
    modules = argumentsMap["modules"];
  }
  if (argumentsMap["user"] == null) {
    return const Text("Error no user");
  } else {
    user = argumentsMap["user"];
  }
  return null;
}

Text? assignUserData2(
  dynamic args,
) {
  // dynamic arguments = ModalRoute.of(context)?.settings.arguments;
  try {
    user = args;
  } on Exception catch (e) {
    return Text(
      e.toString(),
    );
  }
  return null;
}

class DrawerNavigationApp extends StatelessWidget {
  const DrawerNavigationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ticketing',
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true,
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: MaterialStateProperty.all<Color>(Colors.red),
          trackColor:
              MaterialStateProperty.all<Color>(Colors.red.withOpacity(0.3)),
          crossAxisMargin: 8,
          mainAxisMargin: 8,
          minThumbLength: 48,
        ),
      ),
      home: LoginPage(
        domain: domain,
        protocol: protocol,
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/logged_in':
            Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
            // Extract the necessary data from settings.arguments
            User user = arguments['user'];
            List<String> modules = arguments['modules'];
            String domain = arguments['domain'];
            String protocol = arguments['protocol'];

            return MaterialPageRoute(
              builder: (context) => CreateTicket(
                user: user,
                modules: modules,
                domain: domain,
                protocol: protocol,
              ),
            );

          case "/login":
            Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => LoginPage(
                domain: domain,
                protocol: protocol,
              ),
            );

          case "/settings":
            Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
            User user = arguments['user'];
            String domain = arguments['domain'];
            String protocol = arguments['protocol'];
            return MaterialPageRoute(
              builder: (context) => SettingsPage(
                  args: {
                    "user": user, "modules": modules
                  }),
            );

          case "/profile":
            Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
            User user = arguments['user'];
            String domain = arguments['domain'];
            String protocol = arguments['protocol'];
            return MaterialPageRoute(
              builder: (context) => ProfilePage(
                  args: {
                    "user": user, "modules": modules
                  }),
            );

          case "/create_ticket":
            Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
            User user = arguments['user'];
            String domain = arguments['domain'];
            String protocol = arguments['protocol'];

            return MaterialPageRoute(
              builder: (context) => CreateTicket(
                  user: user,
                  modules: modules,
                  domain: domain,
                  protocol: protocol
              ),
            );

          case "/view_tickets":
            Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
            User user = arguments['user'];
            String domain = arguments['domain'];
            String protocol = arguments['protocol'];

            return MaterialPageRoute(
              builder: (context) => ViewTickets(
                user: user,
                domain: domain,
                protocol: protocol,
              ),
            );

          case "/view_ticket":
            Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
            User user = arguments['user'];
            String domain = arguments['domain'];
            String protocol = arguments['protocol'];
            Ticket ticket = arguments["ticket"];

            return MaterialPageRoute(
              builder: (context) => ViewTicket(
                user: user,
                ticket: ticket,
                domain: domain,
                protocol: protocol,
              ),
            );

          case "/users":
            Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
            User user = arguments['user'];
            String domain = arguments['domain'];
            String protocol = arguments['protocol'];

            return MaterialPageRoute(
              builder: (context) => ViewUsers(
                user: user,
                domain: domain,
                protocol: protocol,
              ),
            );

          case "/departments":
            Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
            User user = arguments['user'];
            String domain = arguments['domain'];
            String protocol = arguments['protocol'];

            return MaterialPageRoute(
              builder: (context) => DepartmentsView(
                user: user,
                domain: domain,
                protocol: protocol,
              ),
            );
        }

        // Handle other routes if needed

        return null;
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
      drawer: supporting.DrawerNavigation(
        domain: domain,
        protocol: protocol,
        user: user,
      ),
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
      drawer: supporting.DrawerNavigation(
        domain: domain,
        protocol: protocol,
        user: user,
      ),
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
      drawer: supporting.DrawerNavigation(
          domain: domain,
          protocol: protocol,
          user: user
      ),
      body: const Center(
        child: Text(
          'Profile Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
