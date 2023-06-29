import 'dart:convert';

import 'package:flutter/material.dart';
import '../application_models.dart';
import '../supporting.dart' as supporting;
import 'package:http/http.dart' as http;

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
                  fontSize: 19
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

                  setState(() {});
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

        ],
      ),
      widget.user
    );
  }
}
