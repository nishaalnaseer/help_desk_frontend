import 'package:flutter/material.dart';

import 'package:help_desk_frontend/create_ticket.dart';
import 'package:help_desk_frontend/devices_screen.dart';
import 'package:help_desk_frontend/models_screen.dart';
import 'package:help_desk_frontend/reports.dart';
import 'package:help_desk_frontend/view_tickets.dart';
import 'application_models.dart';
import 'supporting.dart' as supporting;

import 'dummy.dart';

class AppBase extends StatefulWidget {
  final String protocol;
  final String domain;
  final User user;
  AppBase({
    Key? key, required this.protocol, required this.domain, required this.user
  }) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<AppBase> createState() => _AppBaseState();
}

class _AppBaseState extends State<AppBase> {
  late StatefulWidget window;
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

  void createTicket() {
    window = CreateTicket(
      domain: widget.domain,
      protocol: widget.protocol,
      user: widget.user,
    );
    setState(() {
    });
  }

  void devices() {
    setState(() {
      window = DevicesScreen(
          domain: widget.domain,
          protocol:
          widget.protocol
      );
    });
  }

  void viewTickets() {
    window = ViewTickets(
      domain: widget.domain,
      protocol: widget.protocol,
      window: window,
    );
    setState(() {
    });
  }

  void reports() {
    window = ViewReports(
        domain: widget.domain,
        protocol: widget.protocol);
    setState(() {
    });
  }

  void modelsScreen() {
    window = ModelsScreen(
        domain: widget.domain,
        protocol: widget.protocol
    );
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();

    GlobalKey<DummyState> globalKey = GlobalKey<DummyState>();
    window = Dummy(key: globalKey);
    // GlobalKey<CustomContainerState> childKey = GlobalKey<CustomContainerState>();

    switch (department){
      case "IT":
        modules = {
          "Create Ticket": createTicket,
          "View Tickets": viewTickets,
          "Devices": devices,
          "Models": modelsScreen,
          "Reports": reports,
        };
        break;
      default:
        modules = {
          "Create Ticket": createTicket,
        };
        break;
    }

    for(String name in modules.keys) {
      Function? function = modules[name];
      if (function == null) {
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
                fontSize: 17,
              ),
            ),
          ),
          onTap: () {
            widget._scaffoldKey.currentState?.openEndDrawer();
            function();
          },
        ),
      );
      childrenDrawer.add(child);
    }
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isLargeScreen = width > 800;

    return Scaffold(
      key: widget._scaffoldKey,
      appBar: AppBar(
        // automaticallyImplyLeading: false, // remove back button
        backgroundColor: Colors.red[900],
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
          tooltip: 'Menu',
          onPressed: () {
            widget._scaffoldKey.currentState?.openDrawer();
          }
        ),
        elevation: 0,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Ticketing",
                style: TextStyle(
                  color: Colors.white,
                  // fontWeight: FontWeight.bold
                )
              ),
              if (isLargeScreen) Expanded(child: _navBarItems())
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(child: _ProfileIcon(context)),
          )
        ],
      ),
      backgroundColor: supporting.hexToColor("#222222"),
      body: Container(
        child: window,
      ),
      drawer: Drawer(
        // surfaceTintColor: Colors.white,
        // shadowColor: Colors.white,
        backgroundColor: supporting.hexToColor("#222222"),
        child: ListView(
          children: childrenDrawer,
        ),
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
              vertical: 24.0, horizontal: 16),
          child: Text(
            item,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    )
        .toList(),
  );
}

final List<String> _menuItems = <String>[
  'About',
  'Contact',
  'something else'
];

enum Menu { itemOne, itemTwo, itemThree }

class _ProfileIcon extends StatelessWidget {
  final BuildContext previousContext;
  const _ProfileIcon(this.previousContext, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Menu>(
      icon: const Icon(Icons.person),
      offset: const Offset(0, 40),
      onSelected: (Menu item) {},
      surfaceTintColor: Colors.blue,
      // color: Colors.lightBlueAccent,

      itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
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
          onTap: () {
            Navigator.pop(previousContext);
          },
        ),
      ]);
  }
}