import 'dart:convert';

import 'package:flutter/material.dart';
import '../supporting.dart' as supporting;
import '../application_models.dart';
import 'drop_down_selector.dart';
import 'package:http/http.dart' as http;

class ViewDepartment extends StatefulWidget {
  final String server;
  final Department department;
  final User user;
  final List<String> modules;
  final List<String> departments;
  final List<String> ticketableList;

  const ViewDepartment({
    super.key,
    required this.server,
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
  List<Widget> categories = [];
  late Map<String, String> newCategories = widget.department.ticketCategories;

  @override
  void dispose() {
    releaseApiLock();
    super.dispose();
  }

  void releaseApiLock() async {
    if(!releaseSent) {
      http.post(
          Uri.parse(
              "${widget.server}/"
                  "release_lock?module=DEPARTMENTS&resource_id="
                  "${widget.department.dId}"
          ),
          headers: widget.user.getAuth()
      );
      releaseSent = false;
    }
  }

  void initData() async {
    assignCategoryWidgets();

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

    setState(() {

    });
  }

  void assignCategoryWidgets() {
    List<Widget> newWidgets = [];
    widget.department.ticketCategories.forEach((key, value) {
      String _holder = value;
      newWidgets.add(
          SizedBox(
            width: 800,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                children: [
                  Expanded(
                      flex: 75,
                      child: Wrap(
                        children: [
                          Text(
                            key,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white
                            ),
                          )
                        ],
                      )
                  ),
                  Expanded(
                      flex: 25,
                      child: DropdownButton<String>(
                        focusColor: Colors.transparent,
                        dropdownColor: Colors.red[800],
                        hint: Text(
                          'Set Status: $_holder',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white
                          ),
                        ),
                        elevation: 16,
                        onChanged: (String? newValue) {
                          if (newValue == null) {
                            return;
                          }
                          _holder = newValue;
                          newCategories.update(key, (value) => _holder);
                          assignCategoryWidgets();
                        },
                        items: const ["ENABLED", "DISABLED"]
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
                      )
                  ),
                ],
              ),
            ),
          )
      );
    });
    categories = newWidgets;
    setState(() {

    });
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

          newTicketable ?
          Container(
            width: 200,
            padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      TextEditingController controller = TextEditingController();
                      String _holder = "";
                      return AlertDialog(
                        backgroundColor: supporting.hexToColor("#222222"),
                        title: const Text(
                          'Add a Category',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white
                          ),
                        ),
                        content: SizedBox(
                          width: 300,
                          height: 200,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: TextField(
                                  controller: controller,
                                  cursorColor: Colors.red,
                                  onChanged: (value) => _holder = value,
                                  style: const TextStyle(fontSize: 18, color: Colors.white),
                                  decoration: const InputDecoration(
                                    // label: const Text("Text *"),
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red), // Change the color here
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red), // Change the color here
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red), // Change the color here
                                    ),
                                    labelText: "Category*",
                                    labelStyle: TextStyle(fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: ElevatedButton(
                                  child: const Text(
                                    "Add Category",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red
                                    ),
                                  ),
                                  onPressed: () {
                                    String category = controller.text;
                                    if (category.trim().isEmpty) {
                                      supporting.showPopUp(
                                          context,
                                          "Error",
                                          "Category Cannot be Empty!"
                                      );
                                    }

                                    newCategories.putIfAbsent(category, () => "ENABLED");
                                    controller.text = "";
                                    categories.add(
                                        SizedBox(
                                          width: 800,
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    flex: 75,
                                                    child: Wrap(
                                                      children: [
                                                        Text(
                                                          category,
                                                          style: const TextStyle(
                                                              fontSize: 18,
                                                              fontWeight: FontWeight.w500,
                                                              color: Colors.white
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                ),
                                                Expanded(
                                                    flex: 25,
                                                    child: DropdownButton<String>(
                                                      focusColor: Colors.transparent,
                                                      dropdownColor: Colors.red[800],
                                                      hint: const Text(
                                                        'Set Status: ENABLED',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.w500,
                                                            color: Colors.white
                                                        ),
                                                      ),
                                                      elevation: 16,
                                                      onChanged: (String? newValue) {
                                                        if (newValue == null) {
                                                          return;
                                                        }
                                                        selectedView = newValue;
                                                        setState(() {});
                                                        newCategories.update(category, (value) => value);
                                                      },
                                                      items: ["ENABLED", "DISABLED"]
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
                                                    )
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                    );
                                    setState(() {

                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: ElevatedButton(
                                  child: const Text(
                                    "Close",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red
                                    ),
                                  ),
                                  onPressed: () { Navigator.pop(context); },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const Text(
                  "Add Category",
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                      fontSize: 18
                  ),
                ),
              ),
            )
          )
              : Container(),

          newTicketable ? Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 40),
            child: Column(
              children: categories,
            ),
          ) :
          Container(),
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
                      ticketableReports: ticketableReports,
                      ticketCategories: newCategories
                    );

                    var data = department.toJson();
                    var header = widget.user.getAuth();
                    header.putIfAbsent(
                        "Content-Type", () => "application/json");

                    var response = await supporting.patchRequest(
                      jsonEncode(data),
                      widget.server,
                      "/department",
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
      widget.server,
    );
  }
}
