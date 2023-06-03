import 'dart:convert';

import 'package:flutter/material.dart';
import 'application_models.dart';
import 'supporting.dart' as supporting;

class ViewTickets extends StatefulWidget {
  final String domain;
  final String protocol;
  const ViewTickets({Key? key, required this.domain, required this.protocol}) : super(key: key);

  @override
  State<ViewTickets> createState() => _ViewTicketsState();
}

class _ViewTicketsState extends State<ViewTickets> {
  String selectedDepartment = "";
  bool departmentSelected = false;
  List<String> departments = ["IT"];

  String selectedStatus = "";
  bool statusSelected = false;
  List<String> statuses = [
    "Raised", "Ongoing", "On hold", "Completed", "Rejected", "All"
  ];

  bool allSelected = false;
  final ScrollController controller = ScrollController();
  final ScrollController controller2 = ScrollController();
  List<DataRow> rows = [];

  Future<void> getTickets() async {
    String contents = await supporting.getApiData(
      "tickets?department=$selectedDepartment&status=$selectedStatus",
      widget.domain,
      widget.protocol,
    );

    rows = [];
    List<dynamic> coded = jsonDecode(contents);
    for(var x in coded) {
      Ticket ticket = Ticket.fromJson(x);

      rows.add(
          DataRow(
              cells: [
              ]
          )
      );
    }
    setState(() {

    });

  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Center(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "View Tickets",
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: DropdownButton<String>(
            hint: departmentSelected ? Text(selectedDepartment) : const Text('Select a Department'),
            elevation: 16,
            dropdownColor: Colors.purple[100],
            onChanged: (String? newValue) {
              if(newValue == null) {
                return;
              }

              selectedDepartment = newValue;
              departmentSelected = true;
              allSelected = statusSelected && departmentSelected;
              if (allSelected) {
                getTickets();
              }

              setState(() {
              });
            },
            items: departments.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: DropdownButton<String>(
            hint: statusSelected ? Text(selectedStatus) : const Text('Select a Status'),
            elevation: 16,
            dropdownColor: Colors.purple[100],
            onChanged: (String? newValue) {
              if(newValue == null) {
                return;
              }

              selectedStatus = newValue;
              statusSelected = true;

              allSelected = statusSelected && departmentSelected;
              if (allSelected) {
                getTickets();
              }
              getTickets();

              setState(() {
              });
            },
            items: statuses.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        allSelected ? Center(
          child: Scrollbar(
            controller: controller2,
            child: SingleChildScrollView(
              controller: controller2,
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Brand'),),
                  DataColumn(label: Text('Description'),),
                  DataColumn(label: Text('Location'),),
                  DataColumn(label: Text('Year'),),
                  DataColumn(label: Text('Serial Number'),),
                  DataColumn(label: Text('Static IP?'),),
                  DataColumn(label: Text('Last Known IP'),),
                  DataColumn(label: Text('MAC'),),
                  DataColumn(label: Text('Remarks'),),
                  DataColumn(label: Text('Supplies'),),
                  DataColumn(label: Text('Obtained'),),
                  DataColumn(label: Text('Obtained From'),),
                  DataColumn(label: Text('Last Serviced'),),
                  DataColumn(label: Text('Total Serviced'),),
                ],
                rows: rows,
              ),
            ),
          ),
        ) :
        Container(),
      ],
    );
  }
}
