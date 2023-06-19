import 'dart:convert';

import 'package:flutter/material.dart';

import 'application_models.dart';
import 'drop_down_selector.dart';
import 'supporting.dart' as supporting;


class CreateDepartment extends StatefulWidget {
  final User user;
  final String protocol;
  final String domain;
  const CreateDepartment({super.key, required this.user, required this.protocol, required this.domain});

  @override
  State<CreateDepartment> createState() => _CreateDepartmentState();
}

class _CreateDepartmentState extends State<CreateDepartment> {
  TextEditingController nameController = TextEditingController();
  String name = "";
  String selectedView = "";
  bool viewSelected = false;
  bool ticketable = false;
  String availableModules = "Available Modules: ";
  String modulesButton = "Add Module";
  String ticketableDepartmentsTicketsAccessible =
      "Which ticketable department's tickets can this department can access?";
  String ticketableDepartment = "Add ticketable Department";
  String departmentReport =
      "Which departments reports can this department access?";
  String ticketsFrom =
      "Which departments raised tickets can this department access?";

  List<String> modules = [];
  List<String> departments = ["This Department"];
  List<String> ticketableList = [];

  String moduleHolder = "";
  String reportHolder = "";
  String ticketableHolder = "";
  String raisedHolder = "";
  bool raisedSelected = false;

  List<String> selectedModules = [];
  List<String> viewableTicketableDepartments = [];
  List<String> viewableReports = [];
  List<String> selectedRaised = [];

  String selectedModulesString = "";
  bool modulesSelectedBool = false;
  bool reportSelectedBool = false;
  bool ticketableDepartmenSelected = false;

  String raisedButton = "Add Department";
  String reportsButton = "Add Department";

  Padding inputField(
      TextEditingController controller, String holder, String display,
      {int maximumLines = 1, int minimumLines = 1}) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: controller,
        cursorColor: Colors.red,
        minLines: minimumLines,
        maxLines: maximumLines,
        onChanged: (value) => holder = value,
        style: const TextStyle(fontSize: 18, color: Colors.white),
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red), // Change the color here
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red), // Change the color here
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red), // Change the color here
          ),
          labelText: display,
          labelStyle: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
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
                  onPressed: () {
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
                  "Add A Department!",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.red),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: 200,
                child: Center(
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

                      modules = [];
                      departments = ["This Department"];
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

                      setState(() {

                      });

                    },
                    child: const Text(
                      "Load Data",
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    )
                  ),
                ),
              ),
            ),

            inputField(nameController, name, "Name"),

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
                  value: ticketable,
                  fillColor: MaterialStateProperty.all<Color>(Colors.red),
                  hoverColor: Colors.red[100],
                  onChanged: (bool? value) {
                    setState(() {
                      ticketable = value ?? false;
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
                hint: viewSelected
                    ? Text(
                  'Selected Default View: $selectedView',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
                )
                    : const Text(
                  'Select a Default View: ',
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
                  viewSelected = true;
                  setState(() {});
                },
                items: modules
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

            DropDownSelector(
                trackText: "Available Modules: ",
                buttonText: "Add Module",
                options: modules
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
              child: Text(
                availableModules,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownButton<String>(
                focusColor: Colors.transparent,
                dropdownColor: Colors.red[800],
                hint: modulesSelectedBool
                    ? Text(
                  "Add / Remove $moduleHolder",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                  ),
                )
                  : const Text(
                  'Add a Module',
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
                  modulesSelectedBool = true;
                  moduleHolder = newValue;

                  if(selectedModules.contains(moduleHolder)) {
                    modulesButton = "Remove Module";
                  } else {
                    modulesButton = "Add Module";
                  }

                  setState(() {

                  });

                },
                items: modules
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
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
              width: 200,
              child: Center(
                child: ElevatedButton(
                    onPressed: () {
                      if(selectedModules.contains(moduleHolder)) {
                        selectedModules.remove(moduleHolder);
                        modulesButton = "Add Module";
                      } else {
                        selectedModules.add(moduleHolder);
                        modulesButton = "Remove Module";
                      }
                      availableModules = "Available Modules: ";

                      for(String module in selectedModules) {
                        availableModules += " $module,";
                      }
                      setState(() {

                      });

                    },
                    child: Text(
                      modulesButton,
                      style: const TextStyle(color: Colors.red, fontSize: 18),
                    )
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
              child: Text(
                ticketableDepartmentsTicketsAccessible,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownButton<String>(
                focusColor: Colors.transparent,
                dropdownColor: Colors.red[800],
                hint: ticketableDepartmenSelected
                    ? Text(
                  "Add / Remove $ticketableHolder",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                  ),
                )
                    : const Text(
                  'Add a Ticketable department',
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
                  ticketableDepartmenSelected = true;
                  ticketableHolder = newValue;

                  if(viewableTicketableDepartments.contains(ticketableHolder)) {
                    ticketableDepartment = "Remove Ticketable Department";
                  } else {
                    ticketableDepartment = "Add Ticketable Department";
                  }

                  setState(() {

                  });

                },
                items: ticketableList
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
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
              width: 200,
              child: Center(
                child: ElevatedButton(
                    onPressed: () {
                      if(viewableTicketableDepartments.contains(ticketableHolder)) {
                        viewableTicketableDepartments.remove(ticketableHolder);
                        ticketableDepartment = "Add Ticketable Department";
                      } else {
                        viewableTicketableDepartments.add(ticketableHolder);
                        ticketableDepartment = "Remove Ticketable Department";
                      }
                      ticketableDepartmentsTicketsAccessible =
                      "Which ticketable department's tickets can this department can access? ";

                      for(String department in viewableTicketableDepartments) {
                        ticketableDepartmentsTicketsAccessible += " $department,";
                      }
                      setState(() {

                      });

                    },
                    child: Text(
                      ticketableDepartment,
                      style: const TextStyle(color: Colors.red, fontSize: 18),
                    )
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
              child: Text(
                ticketsFrom,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownButton<String>(
                focusColor: Colors.transparent,
                dropdownColor: Colors.red[800],
                hint: raisedSelected
                    ? Text(
                  "Add / Remove $raisedHolder",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                  ),
                )
                    : const Text(
                  'Add a Department',
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
                  raisedSelected = true;
                  raisedHolder = newValue;

                  if(selectedRaised.contains(raisedHolder)) {
                    raisedButton = "Remove Module";
                  } else {
                    raisedButton = "Add Module";
                  }

                  setState(() {

                  });

                },
                items:
                    departments.map<DropdownMenuItem<String>>
                      ((String value) {
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
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
              width: 200,
              child: Center(
                child: ElevatedButton(
                    onPressed: () {
                      if(selectedRaised.contains(raisedHolder)) {
                        selectedRaised.remove(raisedHolder);
                        raisedButton = "Add Department";
                      } else {
                        selectedRaised.add(raisedHolder);
                        raisedButton = "Remove Department";
                      }
                      ticketsFrom = "Available Modules: ";

                      for(String department in selectedRaised) {
                        ticketsFrom += " $department,";
                      }
                      setState(() {

                      });

                    },
                    child: Text(
                      raisedButton,
                      style: const TextStyle(color: Colors.red, fontSize: 18),
                    )
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
              child: Text(
                departmentReport,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownButton<String>(
                focusColor: Colors.transparent,
                dropdownColor: Colors.red[800],
                hint: reportSelectedBool
                    ? Text(
                  "Add / Remove $reportHolder",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                  ),
                )
                    : const Text(
                  'Add a Department',
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
                  reportSelectedBool = true;
                  reportHolder = newValue;

                  if(viewableReports.contains(reportHolder)) {
                    reportsButton = "Remove Department";
                  } else {
                    reportsButton = "Add Department";
                  }

                  setState(() {

                  });

                },
                items: departments
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
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
              width: 200,
              child: Center(
                child: ElevatedButton(
                    onPressed: () {
                      if(viewableReports.contains(reportHolder)) {
                        viewableReports.remove(reportHolder);
                        reportsButton = "Add Department";
                      } else {
                        viewableReports.add(reportHolder);
                        reportsButton = "Remove Department";
                      }
                      departmentReport = "Which departments reports can "
                          "this department access?";

                      for(String department in viewableReports) {
                        departmentReport += " $department,";
                      }
                      setState(() {

                      });

                    },
                    child: Text(
                      reportsButton,
                      style: const TextStyle(color: Colors.red, fontSize: 18),
                    )
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 10, 50),
              child: SizedBox(
                width: 200,
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      Department department = Department(
                          dId: 0,
                          name: nameController.text,
                          defaultView: selectedView,
                          ticketable: ticketable,
                          modules: selectedModules,
                          accessibleTickets: viewableTicketableDepartments,
                          ticketsRaisedFrom: selectedRaised,
                          reportsFrom: viewableReports
                      );

                    },
                    child: const Text(
                      "Submit",
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    )
                  ),
                ),
              ),
            )
          ],
        ),
      widget.user
    );
  }
}
