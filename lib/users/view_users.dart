import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:help_desk_frontend/users/view_user.dart';
import 'package:help_desk_frontend/application_models.dart';
import 'package:help_desk_frontend/supporting.dart' as supporting;
import 'package:http/http.dart' as http;

import 'create_user.dart';

class ViewUsers extends StatefulWidget {
  final User user;
  final String protocol;
  final String domain;
  const ViewUsers({
    super.key, required this.user,
    required this.protocol, required this.domain
  });

  @override
  State<ViewUsers> createState() => _ViewUsersState();
}

class _ViewUsersState extends State<ViewUsers> {
  String selectedDepartment = "";
  bool departmentSelected = false;
  late final List<String> departments;
  bool departmentsInitialised = false;
  TextStyle style = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 18
  );
  final ScrollController controller = ScrollController();
  final ScrollController controller2 = ScrollController();

  List<DataRow> rows = [];

  void getDepartments() async {
    var response = await http.get(
      Uri.parse("${widget.protocol}://${widget.domain}"
          "/departments"), headers: widget.user.getAuth(),
    );

    if(response.statusCode != 200) {
      throw Exception("Unhandled exception on GET /departments route");
    }
    List<dynamic> data = jsonDecode(response.body);

    List<String> rows = ["All",];
    for(var departmentJson in data) {
      rows.add(departmentJson["name"]);
    }
    departments = rows;
    departmentsInitialised = true;
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    getDepartments();
  }

  List<String> properArray() {
    if(departmentsInitialised) {
      return departments;
    } else {
      return [];
    }
  }

  DataColumn getColumn(String text) {
    return DataColumn(
      label: Wrap(
        children: [
          Text(
            text,
            style: style,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          )
        ],
      )
    );
  }

  DataCell getDataCell(String text) {
    return DataCell(
      Wrap(
        children: [
          Text(
            text,
            style: style,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          )
        ]
      )
    );
  }

  void getUsers() async {
    var response = await supporting.getRequest(
      widget.protocol,
      widget.domain,
      "users?d_name=${selectedDepartment.toUpperCase()}",
      headers: widget.user.getAuth(),
      context
    );

    if(response.statusCode != 200) {
      return;
    }

    rows = [];

    List<dynamic> json = jsonDecode(response.body);

    for (var obj in json) {
      User user = User.fromJson(obj);

      rows.add(DataRow(cells: [
        getDataCell('${user.id}'),
        getDataCell(user.name),
        getDataCell(user.status),
        getDataCell(user.number),
        getDataCell(user.department.name),
        getDataCell(user.location),
        DataCell(
          SizedBox(
            width: 200,
            child: ElevatedButton(
                onPressed: () async {
                  var response = await supporting.getRequest(
                    widget.protocol,
                    widget.domain,
                    "user?username=${user.email}",
                    context,
                    headers: widget.user.getAuth()
                  );

                  if(response.statusCode != 200) {
                    return;
                  }

                  var json = jsonDecode(response.body);

                  User userScope = User.fromJson(json);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewUser(
                        protocol: widget.protocol,
                        domain: widget.domain,
                        user: widget.user,
                        userScope: userScope
                      )
                    ),
                  );
                },
                child: const Text(
                  "Inspect/Edit",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.w500
                  ),
                )
            ),
          ),
        )
      ]));
    }

    setState(() {

    });

  }

  @override
  Widget build(BuildContext context) {
    return supporting.getScaffold(
      ListView(
        children: [
          const Center(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                "Users",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 25
                ),
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(10),
            width: 200,
            child: Align(
              alignment: Alignment.topRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateUser(
                        protocol: widget.protocol,
                        domain: widget.domain,
                        user: widget.user
                      )
                    ),
                  );
                },
                child: const Text(
                  "Add User",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.red
                  ),
                ),
              ),
            ),
          ),

          SizedBox(
            width: supporting.getWindowWidth(context),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownButton<String>(
                hint: departmentSelected
                    ? Text(
                  "Selected Department: $selectedDepartment",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                  ),
                )
                    : const Text(
                  'Select a Department',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                  ),
                ),
                elevation: 16,
                focusColor: Colors.transparent,
                dropdownColor: Colors.red[800],
                onChanged: (String? newValue) {
                  if (newValue == null) {
                    return;
                  }

                  selectedDepartment = newValue;
                  departmentSelected = true;

                  setState(() {

                  });

                  getUsers();
                },
                items: (properArray()).map<DropdownMenuItem<String>>
                  ((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          departmentSelected ?
          Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Scrollbar(
                // thumbVisibility: true,
                controller: controller2,
                child: SingleChildScrollView(
                  controller: controller2,
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    constraints: BoxConstraints(
                      minWidth: supporting.getWindowWidth(context) -
                          20, // Set the minimum width here
                    ),
                    child: SizedBox(
                      // width: supporting.getWindowWidth(context),
                      child: DataTable(
                        columns: [
                          getColumn("ID"),
                          getColumn("Name"),
                          getColumn("Status"),
                          getColumn("Contact"),
                          getColumn("Department"),
                          getColumn("Location"),
                          getColumn("")
                        ],
                        rows: rows,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ) :
          Container()
        ],
      ),
      widget.user,
      widget.protocol,
      widget.domain,
    );
  }
}
