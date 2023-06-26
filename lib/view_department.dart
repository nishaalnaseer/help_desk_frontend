import 'package:flutter/material.dart';
import 'supporting.dart' as supporting;
import 'application_models.dart';
import 'drop_down_selector.dart';

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

  final modulesKey = GlobalKey<DropDownSelectorState>();
  final ticketsToKey = GlobalKey<DropDownSelectorState>();
  final ticketsFromKey = GlobalKey<DropDownSelectorState>();
  final ticketableReportsKey = GlobalKey<DropDownSelectorState>();
  final nonTicketableReportsKey = GlobalKey<DropDownSelectorState>();
  late DropDownSelector modulesSelector = DropDownSelector(
    key: modulesKey,
    trackText: modulesSelectorDisplay,
    buttonText: "Module",
    options: widget.modules,
    initialValues: widget.department.modules,
  );
  late DropDownSelector ticketToSelector = DropDownSelector(
    key: ticketsToKey,
    trackText: ticketToSelectorDisplay,
    buttonText: "Department",
    options: widget.ticketableList,
    initialValues: widget.department.accessibleTickets,
  );
  late DropDownSelector ticketFromSelector = DropDownSelector(
    key: ticketsFromKey,
    trackText: ticketFromSelectorDisplay,
    buttonText: "Department",
    options: departments,
    initialValues: widget.department.ticketsRaisedFrom,
  );
  late DropDownSelector reportsTicketable = DropDownSelector(
    key: ticketableReportsKey,
    trackText: reportsTicketableDisplay,
    buttonText: "Department",
    options: widget.ticketableList,
    initialValues: widget.department.ticketableReports,
  );
  late DropDownSelector reportsNonTicketable = DropDownSelector(
    key: nonTicketableReportsKey,
    trackText: reportsNonTicketableDisplay,
    buttonText: "Department",
    options: departments,
    initialValues: widget.department.nonTicketableReports,
  );

  @override
  void dispose() {
    super.dispose();
  }

  void initData() async {
    var modulesSelectorDisplay = "Available Modules:";
    var ticketToSelectorDisplay = "Which ticketable department's"
        " tickets can this department can access?";
    var ticketFromSelectorDisplay = "Which departments raised"
        " tickets can this department access?";
    var reportsTicketableDisplay = "Which tickeatable departments"
        " reports can this department access?";
    var reportsNonTicketableDisplay = "Which departments reports"
        " can this department access?";

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
  }

  List<String> getDepartments() {
    List<String> departments = widget.departments;
    departments.remove("This department");
    return departments;
  }

  List<String> getValues(GlobalKey<DropDownSelectorState> key) {
    DropDownSelectorState? state = key.currentState;
    List<String>? selectedFromTicketable =
      state?.getSelected();

    if(selectedFromTicketable == null) {
      throw Exception("Null DropDownSelectorState Value");
    }

    return selectedFromTicketable;
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
                  var headers = widget.user.getAuth();
                  await supporting.postRequest2(
                    "",
                    widget.protocol,
                    widget.domain,
                    "release_department_lock?"
                        "d_id=${widget.department.dId}",
                    context,
                    headers: headers
                  );
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
                    // DropDownSelectorState? state =
                    //     modulesKey.currentState;
                    // List<String>? selectedModules = state?.getSelected();
                    //
                    // state = ticketsToKey.currentState;
                    // List<String>? selectedToTicketable =
                    // state?.getSelected();
                    //
                    // state = ticketsFromKey.currentState;
                    // List<String>? selectedFromTicketable =
                    // state?.getSelected();
                    //
                    // state = ticketableReportsKey.currentState;
                    // List<String>? ticketableReports =
                    // state?.getSelected();
                    //
                    // state = nonTicketableReportsKey.currentState;
                    // List<String>? nonTicketableReports =
                    // state?.getSelected();
                    //
                    // if (
                    // selectedModules == null ||
                    //     selectedToTicketable == null ||
                    //     selectedFromTicketable == null ||
                    //     nonTicketableReports == null ||
                    //     ticketableReports == null
                    // ) {
                    //   return;
                    // }
                    //
                    // Department department = Department(
                    //   dId: 0,
                    //   name: nameController.text,
                    //   defaultView: selectedView,
                    //   ticketable: ticketable,
                    //   modules: selectedModules,
                    //   accessibleTickets: selectedToTicketable,
                    //   ticketsRaisedFrom: selectedFromTicketable,
                    //   nonTicketableReports: nonTicketableReports,
                    //   ticketableReports: ticketableReports,
                    //   submittedBy: widget.user.email,
                    // );
                    // var data = jsonEncode(department.toJson());
                    //
                    // supporting.postRequest2(
                    //   data,
                    //   widget.protocol,
                    //   widget.domain,
                    //   "department",
                    //   context,
                    //   headers: widget.user.getAuth(),
                    //   showPrompt: true,
                    //   promptTitle: "Nice",
                    //   promptMessage: "Department Created",
                    // );
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
      widget.user
    );
  }
}
