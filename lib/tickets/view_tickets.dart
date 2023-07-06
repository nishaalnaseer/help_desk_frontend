import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:help_desk_frontend/tickets/view_ticket.dart';
import '../application_models.dart';
import '../supporting.dart' as supporting;

class ViewTickets extends StatefulWidget {
  final String server;
  final User user;
  const ViewTickets({
    Key? key,
    required this.user, required this.server,
  }) : super(key: key);

  @override
  State<ViewTickets> createState() => _ViewTicketsState();
}

class _ViewTicketsState extends State<ViewTickets> {
  String selectedDepartment = "";
  bool departmentSelected = false;
  bool init = false;

  String selectedDepartmentFrom = "";
  bool departmentSelectedFrom = false;
  List<String> departmentsFrom = ["Your Tickets"];
  TextStyle style = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 18
  );

  String selectedStatus = "";
  bool statusSelected = false;
  List<String> statuses = [
    "Raised",
    "Ongoing",
    "On hold",
    "Completed",
    "Rejected",
    "All"
  ];

  bool allSelected = false;
  final ScrollController controller = ScrollController();
  final ScrollController controller2 = ScrollController();
  TextEditingController searchController = TextEditingController();
  List<DataRow> rows = [];

  @override
  void initState() {
    for (String dep in widget.user.department.accessibleTickets) {
      departmentsFrom.add(dep);
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ViewTickets oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  void pushTicket(int tId) async {
    String json;
    try {
      json = await supporting.getApiData(
          "/ticket?ticket_id=$tId",
          widget.server,
          context,
          headers: widget.user.getAuth());
    } catch (e) {
      return;
    }

    Map<String, dynamic> map = jsonDecode(json);

    Ticket bigTicket = Ticket.fromJson(map);

    var args = {
      "user": widget.user,
      "ticket": bigTicket,
      "server": widget.server,
    };

    Navigator.pushNamed
      (
        context,
        "/view_ticket",
        arguments: args
    );
  }

  Future<List<DataRow>> getAsyncTickets() async {
    if(selectedStatus == "On hold") {
      selectedStatus = "On_hold";
    }
    String contents = await supporting.getApiData(
        "tickets?tickets_from=$selectedDepartmentFrom&"
        "department=$selectedDepartment&ticket_status=${selectedStatus.toUpperCase()}",
        widget.server,
        context,
        headers: widget.user.getAuth());

    List<DataRow> rows = [];
    late List<dynamic> coded;
    try {
      coded = jsonDecode(contents);
    } on TypeError catch (e) {
      return [];
    }

    for (var x in coded) {
      Ticket ticket = Ticket.fromJson(x);

      rows.add(DataRow(cells: [
        getDataCell('${ticket.tId}'),
        getDataCell(ticket.nameTicket),
        getDataCell(ticket.status),
        getDataCell(ticket.numberTicket),
        getDataCell(ticket.deptTicket),
        getDataCell(ticket.location),
        getDataCell(ticket.subject),
        DataCell(
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: ()  {
                pushTicket(ticket.tId);
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
    return rows;
  }

  void getTickets() async {
    List<DataRow> stuff = await getAsyncTickets();
    rows = stuff;
  }

  Future<void> getTicketsUpdate() async {
    rows = await getAsyncTickets();
    setState(() {});
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
    ));
  }

  DataCell getDataCell(String text) {
    return DataCell(Wrap(children: [
      Text(
        text,
        style: style,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
      )
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return supporting.getScaffold(
      ListView(
        children: [
          const Center(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "View Tickets",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Center(
            child: Row(
              children: [
                SizedBox(
                  width: 200,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SearchBar(
                      onTap: () {
                        searchController.clear();
                      },
                      controller: searchController,
                      hintText: "Search By ID",
                      hintStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () async {
                        int ticketId;
                        try {
                          ticketId = int.parse(searchController.text);
                        } catch (e) {
                          return;
                        }

                        pushTicket(ticketId);
                      },
                      child: const Text(
                        "Search",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                )
              ]
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: DropdownButton<String>(
              focusColor: Colors.transparent,
              dropdownColor: Colors.red[800],
              hint: departmentSelectedFrom
                  ? Text(
                      'From: $selectedDepartmentFrom',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    )
                  : const Text(
                      'From: ',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
              elevation: 16,
              onChanged: (String? newValue) {
                if (newValue == null) {
                  return;
                }

                selectedDepartmentFrom = newValue;
                departmentSelectedFrom = true;
                allSelected = statusSelected &&
                    departmentSelected &&
                    departmentSelectedFrom;
                if (allSelected) {
                  getTicketsUpdate();
                }

                setState(() {});
              },
              items: widget.user.department.ticketsRaisedFrom
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
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
              hint: departmentSelected
                  ? Text(
                      'To: $selectedDepartment',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    )
                  : const Text(
                      'To: ',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
              elevation: 16,
              onChanged: (String? newValue) {
                if (newValue == null) {
                  return;
                }

                selectedDepartment = newValue;
                departmentSelected = true;
                allSelected = statusSelected &&
                    departmentSelected &&
                    departmentSelectedFrom;
                if (allSelected) {
                  getTicketsUpdate();
                }

                setState(() {});
              },
              items: widget.user.department.accessibleTickets
                  .map<DropdownMenuItem<String>>((String value) {
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
              hint: statusSelected
                  ? Text(
                      'Selected Status: $selectedStatus',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    )
                  : const Text(
                      'Select a Status',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
              elevation: 16,
              onChanged: (String? newValue) {
                if (newValue == null) {
                  return;
                }

                selectedStatus = newValue;
                statusSelected = true;

                allSelected = statusSelected &&
                    departmentSelected &&
                    departmentSelectedFrom;
                if (allSelected) {
                  getTicketsUpdate();
                }

                setState(() {});
              },
              items: statuses.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                );
              }).toList(),
            ),
          ),
          allSelected
              ? Padding(
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
                                getColumn("Department"),
                                getColumn("Location"),
                                getColumn("Email"),
                                getColumn("Numbr"),
                                getColumn("Subject"),
                                getColumn("")
                              ],
                              rows: rows,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
      widget.user,
      widget.server,
    );
  }
}
