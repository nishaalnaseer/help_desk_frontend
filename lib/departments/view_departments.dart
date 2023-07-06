import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:help_desk_frontend/departments/create_department.dart';
import 'package:help_desk_frontend/departments/view_department.dart';
import 'package:http/http.dart' as http;

import '../application_models.dart';
import '../supporting.dart' as supporting;
import 'view_department.dart';

class DepartmentsView extends StatefulWidget {
  final User user;
  final String server;
  const DepartmentsView({
    super.key,
    required this.user,
    required this.server,
  });

  @override
  State<DepartmentsView> createState() =>
      _DepartmentsViewState();
}

class _DepartmentsViewState extends State<DepartmentsView> {
  List<DataRow> rows = [];
  bool dataInit = false;
  List<String> modules = [];
  List<String> departments = ["This Department"];
  List<String> ticketableList = [];

  DataColumn getColumn(String text) {
    return DataColumn(
      label: Wrap(
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18
            ),
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          )
        ],
      )
    );
  }

  DataCell getDataCell(String text) {
    return DataCell(Wrap(children: [
      Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 18
        ),
        softWrap: true,
        overflow: TextOverflow.ellipsis,
      )
    ]));
  }

  void getData() async {
    var headers = widget.user.getAuth();
    headers.remove('Content-Type');

    var response = await supporting.getRequest(
      widget.server,
      "/departments",
      context,
      headers: headers
    );

    if (response.statusCode != 200) {
      return;
    }

    List<DataRow> rows = [];

    var data = jsonDecode(response.body);
    for(var row in data) {
      Department department = Department.fromJson(row);

      rows.add(
        DataRow(
          cells: [
            getDataCell("${department.dId}"),
            getDataCell(department.name),
            getDataCell(department.defaultView),
            getDataCell("${department.ticketable}"),
            DataCell(
              Wrap(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      var response = await supporting.getApiData(
                        "/department?d_name=${department.name}",
                        widget.server,
                        context,
                        headers: widget.user.getAuth()
                      );
                      Department uDepartment;
                      try {
                        var json = jsonDecode(response);
                        uDepartment = Department.fromJson(json);
                      } on Exception catch (e) {
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewDepartment(
                              server: widget.server,
                              user: widget.user,
                              department: uDepartment,
                              modules: modules,
                              departments: departments,
                              ticketableList: ticketableList,
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
                  )
                ]
              )
            )
          ]
        )
      );
    }
    this.rows = rows;

    dataInit =  true;
    setState(() {

    });
  }

  Future<void> listsInit() async {
    var uri = Uri.parse(
        "${widget.server}"
            "/all_departments_and_modules"
    );
    var response = await http.get(
        uri,
        headers: widget.user.getAuth()
    );

    if (response.statusCode != 200) {
      return;
    }

    var data = jsonDecode(response.body);

    List<dynamic> modulesRaw = data["modules"];
    List<dynamic> departmentsRaw = data["departments"];
    List<dynamic> ticketableRaw = data["ticketable"];

    modules = [];
    departments = [];
    ticketableList = [];

    for(dynamic x in modulesRaw) {
      modules.add(x);
    }

    for(dynamic x in departmentsRaw) {
      departments.add(x);
    }

    for(dynamic x in ticketableRaw) {
      ticketableList.add(x);
    }
  }

  @override
  void initState(){
    listsInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return supporting.getScaffold(
      ListView(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                10,
                supporting.getWindowHeight(context) * 0.05,
                10,
                20
              ),
              child: const Text(
                "Departments!",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: Colors.red
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () async {
                  List<String> modifiedDeps = departments;
                  modifiedDeps.add("This Department");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateDepartment(
                        server: widget.server,
                        user: widget.user,
                        modules: modules,
                        departments: modifiedDeps,
                        ticketableList: ticketableList,
                      )
                    ),
                  );
                },
                child: const Text(
                  "Add",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  getData();
                },
                child: const Text(
                  "Get Data",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                    fontSize: 18
                  ),
                ),
              ),
            ),
          ),
          dataInit ? Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: supporting.getWindowWidth(context),
                child: DataTable(
                  columns: [
                    getColumn("ID"),
                    getColumn("Name"),
                    getColumn("Default View"),
                    getColumn("Ticketable"),
                    const DataColumn(
                      label: Text("")
                    )
                  ],
                  rows: rows,
                ),
              ),
            ),
          ) :
          Container()
        ],
      ),
      widget.user,
      widget.server,
    );
  }
}
