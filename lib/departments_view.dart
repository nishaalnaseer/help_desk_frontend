import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:help_desk_frontend/create_department.dart';

import 'application_models.dart';
import 'supporting.dart' as supporting;

class DepartmentsView extends StatefulWidget {
  final User user;
  final String protocol;
  final String domain;
  const DepartmentsView({
    super.key,
    required this.user,
    required this.protocol,
    required this.domain
  });

  @override
  State<DepartmentsView> createState() =>
      _DepartmentsViewState();
}

class _DepartmentsViewState extends State<DepartmentsView> {
  List<DataRow> rows = [];
  bool dataInit = false;

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
        ));
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
      widget.protocol,
      widget.domain,
      "departments",
      context,
      headers: headers
    );

    if (response.statusCode != 200) {
      return;
    }

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
                    onPressed: () {},
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


    dataInit =  true;
    setState(() {

    });
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
                  color: Colors.red),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () async {
                  var response = await supporting.getRequest(
                      widget.protocol,
                      widget.domain,
                      "all_departments_and_modules",
                      context,
                      headers: widget.user.getAuth()
                  );

                  if(response.statusCode != 200) {
                    return;
                  }

                  var data = jsonDecode(response.body);

                  List<dynamic> modulesRaw = data["modules"];
                  List<dynamic> departmentsRaw = data["departments"];
                  List<dynamic> ticketableRaw = data["ticketable"];

                  List<String> modules = [];
                  List<String> departments = ["This Department"];
                  List<String> ticketableList = [];

                  for(dynamic x in modulesRaw) {
                    modules.add(x);
                  }

                  for(dynamic x in departmentsRaw) {
                    departments.add(x);
                  }

                  for(dynamic x in ticketableRaw) {
                    ticketableList.add(x);
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateDepartment(
                        protocol: widget.protocol,
                        domain: widget.domain,
                        user: widget.user,
                        modules: modules,
                        departments: departments,
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
      widget.user
    );
  }
}
