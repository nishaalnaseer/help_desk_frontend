import 'package:flutter/material.dart';

import 'application_models.dart';
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
      "Which ticketable department's tickets this department can access?";
  String ticketableDepartment = "Add ticketable Department";
  String departmentReport =
      "Which departments reports can this department access?";
  String ticketsFrom =
      "Which departments raised tickets can this department access?";

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
                      onPressed: () {},
                      child: const Text(
                        "Load Data",
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      )
                  ),
                ),
              ),
            ),

            inputField(nameController, name, "Name"),
            Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownButton<String>(
                focusColor: Colors.transparent,
                dropdownColor: Colors.red[800],
                hint: viewSelected
                    ? Text(
                  'Select a Default View: $selectedView',
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
                items: widget.user.ticketableDepartments
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

            Align(
              alignment: Alignment.bottomLeft,
              child: SizedBox(
                width: 400,
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
              padding: const EdgeInsets.all(10),
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
                hint: viewSelected
                    ? Text(
                  selectedView,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
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
                  selectedView = newValue;
                  viewSelected = true;
                  setState(() {});
                },
                items: widget.user.ticketableDepartments
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
              padding: const EdgeInsets.all(10),
              width: 200,
              child: Center(
                child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      modulesButton,
                      style: const TextStyle(color: Colors.red, fontSize: 18),
                    )
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Wrap(
                children: [
                  Text(
                  ticketableDepartmentsTicketsAccessible,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownButton<String>(
                focusColor: Colors.transparent,
                dropdownColor: Colors.red[800],
                hint: viewSelected
                    ? Text(
                  selectedView,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
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
                  selectedView = newValue;
                  viewSelected = true;
                  setState(() {});
                },
                items: widget.user.ticketableDepartments
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
              padding: const EdgeInsets.all(10),
              width: 200,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    ticketableDepartment,
                    style: const TextStyle(color: Colors.red, fontSize: 18),
                  )
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
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
                hint: viewSelected
                    ? Text(
                  selectedView,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
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
                  selectedView = newValue;
                  viewSelected = true;
                  setState(() {});
                },
                items: widget.user.ticketableDepartments
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
              padding: const EdgeInsets.all(10),
              width: 200,
              child: Center(
                child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      modulesButton,
                      style: const TextStyle(color: Colors.red, fontSize: 18),
                    )
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
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
                hint: viewSelected
                    ? Text(
                  selectedView,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
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
                  selectedView = newValue;
                  viewSelected = true;
                  setState(() {});
                },
                items: widget.user.ticketableDepartments
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
              padding: const EdgeInsets.all(10),
              width: 200,
              child: Center(
                child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      modulesButton,
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
                    onPressed: () {},
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
