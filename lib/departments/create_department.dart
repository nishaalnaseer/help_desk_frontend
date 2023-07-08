import 'dart:convert';

import 'package:flutter/material.dart';

import '../application_models.dart';
import 'drop_down_selector.dart';
import '../input_validations.dart';
import '../supporting.dart' as supporting;


class CreateDepartment extends StatefulWidget {
  final User user;
  final String server;
  final List<String> modules;
  final List<String> departments;
  final List<String> ticketableList;

  const CreateDepartment({
    super.key,
    required this.user,
    required this.server,
    required this.modules,
    required this.departments,
    required this.ticketableList,
  });

  @override
  State<CreateDepartment> createState() => _CreateDepartmentState();
}

class _CreateDepartmentState extends State<CreateDepartment> {
  InputField name = InputField(
    display: "Department Name",
    mandatory: true
  );
  String selectedView = "";
  bool viewSelected = false;
  bool ticketable = false;

  final modulesKey = GlobalKey<DropDownSelectorState>();
  final ticketsToKey = GlobalKey<DropDownSelectorState>();
  final ticketsFromKey = GlobalKey<DropDownSelectorState>();
  final ticketableReportsKey = GlobalKey<DropDownSelectorState>();
  final nonTicketableReportsKey = GlobalKey<DropDownSelectorState>();
  late DropDownSelector modulesSelector = DropDownSelector(
    key: modulesKey,
    trackText: "Available Modules: ",
    buttonText: "Module",
    options: widget.modules
  );
  late DropDownSelector ticketToSelector = DropDownSelector(
    key: ticketsToKey,
    trackText: "Which ticketable department's tickets can"
        " this department can access?",
    buttonText: "Department",
    options: widget.ticketableList
  );
  late DropDownSelector ticketFromSelector = DropDownSelector(
    key: ticketsFromKey,
    trackText: "Which departments raised tickets can this "
        "department access?",
    buttonText: "Department",
    options: widget.departments
  );
  late DropDownSelector reportsTicketable = DropDownSelector(
    key: ticketableReportsKey,
    trackText: "Which tickeatable departments reports can this "
        "department access?",
    buttonText: "Department",
    options: widget.ticketableList
  );
  late DropDownSelector reportsNonTicketable = DropDownSelector(
    key: nonTicketableReportsKey,
    trackText: "Which departments reports can this"
        " department access?",
    buttonText: "Department",
    options: widget.departments
  );

  Map<String, String> ticketCategories = {"Other": "ENABLED"};
  List<Widget> categories = [];

  void assignCategoryWidgets() {
    List<Widget> newWidgets = [];
    ticketCategories.forEach((key, value) {
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
                          ticketCategories.update(key, (value) => _holder);
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

  @override
  void initState() {
    assignCategoryWidgets();
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
            child: name.inputField,
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

          ticketable ?
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
                                    "Submit",
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

                                    ticketCategories.putIfAbsent(
                                        category, () => "ENABLED"
                                    );
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
                                                    ticketCategories.update(category, (value) => value);
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

          ticketable ? Container(
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

                   String departmentName;

                   try {
                     departmentName = name.text();
                   } on MandatoryInputError catch (e) {
                     supporting.showPopUp(
                       context,
                       "Validation Error!",
                       e.message
                     );
                     return;
                   }

                   Department department = Department(
                     dId: 0,
                     name: departmentName,
                     defaultView: selectedView,
                     ticketable: ticketable,
                     modules: selectedModules,
                     accessibleTickets: selectedToTicketable,
                     ticketsRaisedFrom: selectedFromTicketable,
                     nonTicketableReports: nonTicketableReports,
                     ticketableReports: ticketableReports,
                     submittedBy: widget.user.email,
                     ticketCategories: ticketCategories
                   );
                   var data = jsonEncode(department.toJson());
                   var header = widget.user.getAuth();
                   header.putIfAbsent("Content-type", () => "application/json");
                   supporting.postRequest2(
                     data,
                     widget.server,
                     "/department",
                     context,
                     headers: header,
                     showPrompt: true,
                     promptTitle: "Nice",
                     promptMessage: "Department Created",
                     backTwice: true
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
      widget.user,
      widget.server,
    );
  }
}
