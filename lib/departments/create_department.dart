import 'dart:convert';

import 'package:flutter/material.dart';

import '../application_models.dart';
import 'drop_down_selector.dart';
import '../input_validations.dart';
import '../supporting.dart' as supporting;


class CreateDepartment extends StatefulWidget {
  final User user;
  final String protocol;
  final String domain;
  final List<String> modules;
  final List<String> departments;
  final List<String> ticketableList;

  const CreateDepartment({
    super.key,
    required this.user,
    required this.protocol,
    required this.domain,
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
                   );
                   var data = jsonEncode(department.toJson());

                   supporting.postRequest2(
                     data,
                     widget.protocol,
                     widget.domain,
                     "department",
                     context,
                     headers: widget.user.getAuth(),
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
      widget.protocol,
      widget.domain,
    );
  }
}
