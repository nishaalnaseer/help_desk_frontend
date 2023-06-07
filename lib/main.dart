import 'package:flutter/material.dart';
import 'package:help_desk_frontend/create_ticket.dart';
import 'package:help_desk_frontend/login.dart';

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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return TicketingSystem();
  }
}

class TicketingSystem extends StatefulWidget {
  TicketingSystem({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<TicketingSystem> createState() => _TicketingSystemState();
}

class _TicketingSystemState extends State<TicketingSystem> {
  static const String _title = 'Ticketing';
  Map<String, dynamic> options = {};
  String department = "IT";
  late Map<String, Function> modules;
  List<Widget> childrenDrawer = [
    // DrawerHeader(
    //   decoration: BoxDecoration(
    //     // image: DecorationImage(
    //     // image: FileImage(File('lib/img/datacenter.jpeg')),
    //     // fit: BoxFit.cover,
    //     // ),
    //     borderRadius: BorderRadius.circular(10),
    //     color: Colors.white,
    //   ),
    //   padding: const EdgeInsets.all(10),
    //   child: const Text("IT"),
    // ),
  ];
  bool loggedIn = false;
  User user = User(
    id: 0,
    name: "",
    department: "",
    email: "",
    number: "",
    location: ""
  );

  void signOut() {
    user = User(
        id: 0,
        name: "",
        department: "",
        email: "",
        number: "",
        location: ""
    );
    loggedIn = false;
    // Navigator.pop(context);
    Navigator.pop(context);
  }

  Route<dynamic>? generateRoute(RouteSettings settings) {
    String? name = settings.name;
    print(name);

    if (name == "/") {
      loggedIn = false;
      user = User(
        id: 0,
        name: "",
        department: "",
        email: "",
        number: "",
        location: "",
      );
      return MaterialPageRoute(
        builder: (context) => LoginPage(
          protocol: protocol,
          domain: domain,
          user: user,
        ),
      );
    } else if (name == "/create_ticket") {
      loggedIn = true;
      setState(() {});
      return MaterialPageRoute(
        builder: (context) => CreateTicket(
          protocol: protocol,
          domain: domain,
          user: user,
        ),
      );
    } else if (name == "/sign_out") {
      loggedIn = false;
      user = User(
        id: 0,
        name: "",
        department: "",
        email: "",
        number: "",
        location: "",
      );
      setState(() {});
      return MaterialPageRoute(
        builder: (context) => LoginPage(
          protocol: protocol,
          domain: domain,
          user: user,
        ),
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isLargeScreen = width > 800;

    return MaterialApp(
      title: _title,
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
      initialRoute: "/",
      onGenerateRoute: generateRoute,
      home: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.red[900],
              leading: loggedIn ? IconButton(
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  tooltip: 'Menu',
                  onPressed: () {
                    widget._scaffoldKey.currentState?.openDrawer();
                  }
              ) : null,
              elevation: 0,
              titleSpacing: 0,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                        _title,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500
                        )
                    ),
                    if (isLargeScreen && loggedIn) Expanded(child: _navBarItems())
                  ],
                ),
              ),
              actions: [
                loggedIn ? Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: CircleAvatar(
                      child: PopupMenuButton<Menu>(
                          icon: const Icon(Icons.person),
                          offset: const Offset(0, 40),
                          onSelected: (Menu item) {},
                          surfaceTintColor: Colors.blue,
                          // color: Colors.lightBlueAccent,

                          itemBuilder: (BuildContext context2) => <PopupMenuEntry<Menu>>[
                            const PopupMenuItem<Menu>(
                              value: Menu.itemOne,
                              child: Text('Account'),

                            ),
                            const PopupMenuItem<Menu>(
                              value: Menu.itemTwo,
                              child: Text('Settings'),
                            ),
                            PopupMenuItem<Menu>(
                              value: Menu.itemThree,
                              child: const Text('Sign Out'),
                              onTap: () async {
                                Navigator.pushReplacementNamed(context, "/");
                                // signOut();
                              },
                            ),
                          ]
                      )
                  ),
                )
                    : Container()
              ],
            ),
            body: Navigator(
                onGenerateRoute: generateRoute
            ),
          );
        },
      ),
    );
  }

  Widget _navBarItems() => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: _menuItems
        .map(
          (item) => InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 24.0,
            horizontal: 16
          ),
          child: Text(
            item,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white
            ),
          ),
        ),
      ),
    ).toList(),
  );
}

// body: Navigator(
//   onGenerateRoute: (settings) {
//     if (settings.name == '/') {
//       return MaterialPageRoute(builder: (context) => Text("First"));
//     } else if (settings.name == '/second') {
//       return MaterialPageRoute(builder: (context) => Text("First2"));
//     }
//     return null;
//   },
// ),

final List<String> _menuItems = <String>[
  'About',
  'Contact',
  'something else'
];

enum Menu { itemOne, itemTwo, itemThree }