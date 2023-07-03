import 'dart:convert';

import 'package:flutter/material.dart';
import '../supporting.dart' as supporting;
import '../application_models.dart';
import 'drop_down_selector.dart';
import 'package:http/http.dart' as http;

class ViewDepartment extends StatefulWidget {
  final String protocol;
  final String domain;
  final Department department;
  final User user;
  final List<String> modules;
  final List<String> departments;
  final List<String> ticketableList;

  const ViewDepartment({
    super.key,
    required this.protocol,
    required this.domain,
    required this.department,
    required this.user,
    required this.modules,
    required this.departments,
    required this.ticketableList
  });

  @override
  State<ViewDepartment> createState() => _ViewDepartmentState();
}

class _ViewDepartmentState extends State<ViewDepartment> {
  late String modulesSelectorDisplay;
  late String ticketToSelectorDisplay;
  late String ticketFromSelectorDisplay;
  late String reportsTicketableDisplay;
  late String reportsNonTicketableDisplay;

  late bool newTicketable = widget.department.ticketable;
  late String selectedView = widget.department.defaultView;

  late List<String> departments = getDepartments();
  bool releaseSent = false;

  final modulesKey = GlobalKey<DropDownSelectorState>();
  final ticketsToKey = GlobalKey<DropDownSelectorState>();
  final ticketsFromKey = GlobalKey<DropDownSelectorState>();
  final ticketableReportsKey = GlobalKey<DropDownSelectorState>();
  final nonTicketableReportsKey = GlobalKey<DropDownSelectorState>();
  late DropDownSelector modulesSelector;
  late DropDownSelector ticketToSelector;
  late DropDownSelector ticketFromSelector;
  late DropDownSelector reportsTicketable;
  late DropDownSelector reportsNonTicketable;

  @override
  void dispose() {
    releaseApiLock();
    super.dispose();
  }

  void releaseApiLock() async {
    if(!releaseSent) {
      http.post(
          Uri.parse(
              "${widget.protocol}://${widget.domain}/"
                  "release_lock?module=DEPARTMENTS&resource_id="
                  "${widget.department.dId}"
          ),
          headers: widget.user.getAuth()
      );
      releaseSent = false;
    }
  }

  void initData() async {
    var modulesSelectorDisplay = "Available Modules:";
    var ticketToSelectorDisplay = "Which ticketable department's"
        " tickets can this department can access?";
    var ticketFromSelectorDisplay = "Which departments raised"
        " tickets can this department access?";
    var reportsTicketableDisplay = "Which tickeatable departments"
        " reports can this department access?";
    var reportsNonTicketableDisplay = "Which non-ticketable "
        "departments reports can this department access?";

    for(var x in widget.department.modules) {
      modulesSelectorDisplay += " $x,";
    }

    for(var x in widget.department.accessibleTickets) {
      ticketToSelectorDisplay += " $x,";
    }

    for(var x in widget.department.ticketsRaisedFrom) {
      ticketFromSelectorDisplay += " $x,";
    }

    for(var x in widget.department.ticketableReports) {
      reportsTicketableDisplay += " $x,";
    }

    for(var x in widget.department.nonTicketableReports) {
      reportsNonTicketableDisplay += " $x,";
    }
    this.modulesSelectorDisplay = modulesSelectorDisplay;
    this.ticketToSelectorDisplay = ticketToSelectorDisplay;
    this.reportsTicketableDisplay = reportsTicketableDisplay;
    this.ticketFromSelectorDisplay = ticketFromSelectorDisplay;
    this.reportsNonTicketableDisplay = reportsNonTicketableDisplay;

    modulesSelector = DropDownSelector(
      key: modulesKey,
      trackText: "Available Modules: ",
      buttonText: "Module",
      options: widget.modules,
      initialValues: widget.department.modules,
      initialText: modulesSelectorDisplay,
    );
    ticketToSelector = DropDownSelector(
      key: ticketsToKey,
      trackText:  "Which ticketable department's tickets can"
          " this department can access?",
      buttonText: "Department",
      options: widget.ticketableList,
      initialValues: widget.department.accessibleTickets,
      initialText: ticketToSelectorDisplay,
    );
    ticketFromSelector = DropDownSelector(
      key: ticketsFromKey,
      trackText: "Which departments raised tickets can this "
          "department access?",
      buttonText: "Department",
      options: departments,
      initialValues: widget.department.ticketsRaisedFrom,
      initialText: ticketFromSelectorDisplay,
    );
    reportsTicketable = DropDownSelector(
      key: ticketableReportsKey,
      trackText: "Which tickeatable departments reports can this "
          "department access?",
      buttonText: "Department",
      options: widget.ticketableList,
      initialValues: widget.department.ticketableReports,
      initialText: reportsTicketableDisplay,
    );
    reportsNonTicketable = DropDownSelector(
      key: nonTicketableReportsKey,
      trackText: "Which non-ticketable departments reports "
          "can this department access?",
      buttonText: "Department",
      options: departments,
      initialValues: widget.department.nonTicketableReports,
      initialText: reportsNonTicketableDisplay,
    );
  }

  List<String> getDepartments() {
    List<String> departments = widget.departments;
    departments.remove("This department");
    return departments;
  }

  List<String> getValues(GlobalKey<DropDownSelectorState> key) {
    DropDownSelectorState? state = key.currentState;
    List<String>? values = state?.selections;

    if(values == null) {
      throw Exception("Null DropDownSelectorState Value");
    }

    return values;
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return supporting.getScaffold(
      ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.topLeft,
              child: ElevatedButton(
                onPressed: () async {
                  releaseApiLock();
                  Navigator.pop(context);
                },
                child: const Text(
                  "Back",
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
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                10,
                supporting.getWindowHeight(context) * 0.05,
                10,
                20
              ),
              child: const Text(
                "Edit / View Department",
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
            child: Text(
              "Department ID: ${widget.department.dId}",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 18
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              "Department Name: ${widget.department.name}",
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 18
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              "Department Submitted by: "
                  "${widget.department.submittedBy}",
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 18
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              width: 400,
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
              child: CheckboxListTile(
                title: const Text(
                  "Can tickets be raised to this department?",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                // activeColor: Colors.white,
                selectedTileColor: Colors.red,
                checkColor: Colors.white,
                value: newTicketable,
                fillColor: MaterialStateProperty.all<Color>(Colors.red),
                hoverColor: Colors.red[100],
                onChanged: (bool? value) {
                  setState(() {
                    newTicketable = value ?? false;
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
            child: DropdownButton<String>(
              focusColor: Colors.transparent,
              dropdownColor: Colors.red[800],
              hint: Text(
                'Selected Default View: $selectedView',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
              ),
              elevation: 16,
              onChanged: (String? newValue) {
                if (newValue == null) {
                  return;
                }
                selectedView = newValue;
                setState(() {});
              },
              items: widget.modules
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          modulesSelector,
          ticketToSelector,
          ticketFromSelector,
          reportsTicketable,
          reportsNonTicketable,
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 10, 50),
            child: SizedBox(
              width: 200,
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    DropDownSelectorState? state =
                        modulesKey.currentState;
                    List<String>? selectedModules =
                    state?.getSelected();

                    state = ticketsToKey.currentState;
                    List<String>? selectedToTicketable =
                    state?.getSelected();

                    state = ticketsFromKey.currentState;
                    List<String>? selectedFromTicketable =
                    state?.getSelected();

                    state = ticketableReportsKey.currentState;
                    List<String>? ticketableReports =
                    state?.getSelected();

                    state = nonTicketableReportsKey.currentState;
                    List<String>? nonTicketableReports =
                    state?.getSelected();

                    if (
                    selectedModules == null ||
                        selectedToTicketable == null ||
                        selectedFromTicketable == null ||
                        nonTicketableReports == null ||
                        ticketableReports == null
                    ) {
                      return;
                    }

                    var department = Department(
                      dId: widget.department.dId,
                      name: widget.department.name,
                      defaultView: selectedView,
                      ticketable: newTicketable,
                      submittedBy: widget.department.submittedBy,
                      modules: selectedModules,
                      accessibleTickets: selectedToTicketable,
                      ticketsRaisedFrom: selectedFromTicketable,
                      nonTicketableReports: nonTicketableReports,
                      ticketableReports: ticketableReports
                    );

                    var data = department.toJson();
                    var header = widget.user.getAuth();
                    header.putIfAbsent(
                        "Content-Type", () => "application/json");

                    var response = await supporting.patchRequest(
                      jsonEncode(data),
                      widget.protocol,
                      widget.domain,
                      "department",
                      context,
                      widget.user.getAuth(),
                      showPrompt: true,
                      promptTitle: "Nice",
                      promptMessage: "Department: "
                          "${department.name} changes submitted",
                      backTwice: true
                    );
                  },
                  child: const Text(
                    "Submit Changes",
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  )
                ),
              ),
            ),
          )
        ],
      ),
      widget.user,
      widget.protocol,
      widget.domain,
    );
  }
}
