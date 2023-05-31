import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:help_desk_frontend/create_ticket.dart';
import 'package:help_desk_frontend/devices_screen.dart';
import 'package:help_desk_frontend/models_screen.dart';

import 'dart:io';
import 'package:http/http.dart' as http;

import 'application_models.dart';
import 'dummy.dart';

class AppBase extends StatefulWidget {
  final String protocol;
  final String domain;
  AppBase({Key? key, required this.protocol, required this.domain}) : super(key: key);
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
    DrawerHeader(
      decoration: BoxDecoration(
        // image: DecorationImage(
        // image: FileImage(File('lib/img/datacenter.jpeg')),
        // fit: BoxFit.cover,
        // ),
        borderRadius: BorderRadius.circular(10),
        color: Colors.deepPurpleAccent,
      ),
      padding: const EdgeInsets.all(10),
      child: const Text("IT"),
    ),
  ];

  void createTicket() {
    window = CreateTicket(domain: widget.domain, protocol: widget.protocol);
    setState(() {
    });
  }

  void devices() {
    window = DevicesScreen(domain: widget.domain, protocol: widget.protocol);
    setState(() {
    });
  }

  void viewTickets() {

  }

  void reports() {

  }

  void modelsScreen() {
    window = ModelsScreen(domain: widget.domain, protocol: widget.protocol);
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
          "View Ticket": viewTickets,
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
          selectedColor: Colors.purple[300],
          tileColor: Colors.purple[100],
          splashColor: Colors.purple[300],
          hoverColor: Colors.purple[200],
          textColor: Colors.black,

          title: Center(child:
            Text(
                name,
                style: const TextStyle(
                  color: Colors.black
                ),
            ),
          ),
          onTap: () {
            widget._scaffoldKey.currentState?.openEndDrawer();
            // window.key?.currentState?.dispose();
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
        backgroundColor: Colors.purple[400],
        leading: IconButton(
          icon: const Icon(Icons.menu),
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
                  fontWeight:
                  FontWeight.bold
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
      backgroundColor: Colors.purple[50],
      body: Container(
        child: window,
      ),
      drawer: Drawer(
        // surfaceTintColor: Colors.black,
        // shadowColor: Colors.black,
        backgroundColor: Colors.purple[50],
        child: ListView(
          children: childrenDrawer,
        )
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