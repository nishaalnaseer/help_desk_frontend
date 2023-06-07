import 'dart:convert';

import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';

import 'package:flutter/material.dart';
import 'package:help_desk_frontend/view_ticket.dart';
import 'application_models.dart';
import 'supporting.dart' as supporting;

// todo implement the loading popup when going to the view tickets
//  since some data is retried from api
// todo view_ticket page

class ViewTickets extends StatefulWidget {
  final String domain;
  final String protocol;
  StatefulWidget window;
  ViewTickets({
    Key? key,
    required this.domain,
    required this.protocol,
    required this.window
  }) : super(key: key);

  @override
  State<ViewTickets> createState() => _ViewTicketsState();
}

class _ViewTicketsState extends State<ViewTickets> {
  String selectedDepartment = "";
  bool departmentSelected = false;
  List<String> departments = ["IT"];
  TextStyle style = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 18
  );

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
      context
    );

    rows = [];
    List<dynamic> coded = jsonDecode(contents);
    for(var x in coded) {
      Ticket ticket = Ticket.fromJson(x);

      rows.add(
        DataRow(
          cells: [
            getDataCell('${ticket.tId}'),
            getDataCell('${ticket.submittedBy}'),
            getDataCell(ticket.nameTicket),
            getDataCell(ticket.emailTicket),
            getDataCell(ticket.numberTicket),
            getDataCell(ticket.deptTicket),
            getDataCell(ticket.location),
            getDataCell(ticket.subject),
            DataCell(
              SizedBox(
                width: 200,
                child: ElevatedButton(onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => ViewTicket(
                          protocol: widget.protocol,
                          domain: widget.domain,
                          ticketId: ticket.tId
                      ),
                    ),
                  );
                  widget.window = ViewTicket(
                    protocol: widget.protocol,
                    domain: widget.domain,
                    ticketId: ticket.tId
                  );
                },
                  child: const Text(
                    "Check Details",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.w500
                    ),
                  )
                ),
              ),
            )
          ]
        )
      );
    }
    setState(() {

    });
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

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Center(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "View Tickets",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: DropdownButton<String>(
            focusColor: Colors.transparent,
            dropdownColor: Colors.red[800],
            hint: departmentSelected ? Text(
              selectedDepartment,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500
              ),
            ) : const Text(
              'Select a Department',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500
              ),
            ),
            elevation: 16,
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
        Padding(
          padding: const EdgeInsets.all(10),
          child: DropdownButton<String>(
            focusColor: Colors.transparent,
            dropdownColor: Colors.red[800],
            hint: statusSelected ? Text(
              selectedStatus,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500
              ),
            ) : const Text(
              'Select a Status',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500
              ),
            ),
            elevation: 16,
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
        allSelected ?  Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Scrollbar(
              thumbVisibility: true,
              controller: controller2,
              child: SingleChildScrollView(
                controller: controller2,
                scrollDirection: Axis.horizontal,
                child: Container(
                  constraints: BoxConstraints(
                    minWidth: supporting.getWindowWidth(context) - 20, // Set the minimum width here
                  ),
                  child: SizedBox(
                    // width: supporting.getWindowWidth(context),
                    child: DataTable(
                      columns: [
                        getColumn("ID"),
                        getColumn("Raised By"),
                        getColumn("Name"),
                        getColumn("Email"),
                        getColumn("Contact"),
                        getColumn("Department"),
                        getColumn("Location"),
                        getColumn("Subject"),
                        getColumn("")
                      ],
                      rows: rows,
                    ),
                  ),
                ),
                // child: SizedBox(
                //   // width: supporting.getWindowWidth(context),
                //   child: DataTable(
                //     dataRowMaxHeight: 100,
                //     columns: [
                //       getColumn("ID"),
                //       getColumn("Raised By"),
                //       getColumn("Name"),
                //       getColumn("Email"),
                //       getColumn("Contact"),
                //       getColumn("Department"),
                //       getColumn("Location"),
                //       getColumn("Subject"),
                //       getColumn("")
                //     ],
                //     rows: rows,
                //   ),
                // ),
              ),
            ),
          ),
        ) :
        Container(),
      ],
      );
  }
}
