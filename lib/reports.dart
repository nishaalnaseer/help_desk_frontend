import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';

import 'package:help_desk_frontend/supporting.dart' as supporting;

class ViewReports extends StatefulWidget {
  final String domain;
  final String protocol;
  const ViewReports({Key? key, required this.domain, required this.protocol})
      : super(key: key);

  @override
  State<ViewReports> createState() => _ViewReportsState();
}

class _ViewReportsState extends State<ViewReports> {
  bool typeSelected = false;
  List<String> types = ["Tickets", "Models"];
  String selectedType = "";

  bool departmentSelected = false;
  List<String> departments = ["IT", "Not IT"];
  String selectedDepartment = "";

  List<String> selections = [
    "Raised",
    "Ongoing",
    "On hold",
    "Completed",
    "Rejected",
    "All",
  ];
  bool selected = false;
  String selection = "";

  String startDate = "";
  String endDate = "";
  bool gen = false;

  List<Widget> children = [];
  Map<String, bool?> childrenRaw = {
    "Raised": false,
    "Ongoing": false,
    "On hold": false,
    "Completed": false,
    "Rejected": false,
    "All": false,
  };
  Map<String, int> indexes = {};

  @override
  void initState() {
    super.initState();
  }

  void change(bool? gen) {
    if (gen == null) {
      return;
    }
    gen = !gen;
    this.gen = gen;
    setState(() {});
  }

  void getObjects() {
    children = [];

    childrenRaw.forEach((raw, boolValue) {
      CheckboxListTile checkBox = CheckboxListTile(
        title: Text(raw),
        value: boolValue,
        onChanged: (bool? value) {
          setState(() {
            childrenRaw[raw] = value ?? false;
          });
        },
      );
      children.add(checkBox);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (typeSelected && departmentSelected) {
      getObjects();
    }

    return ListView(
      children: [
        Column(
          children: [
            SizedBox(
              width: supporting.getWindowWidth(context),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: DropdownButton<String>(
                  hint: departmentSelected
                      ? Text(selectedDepartment)
                      : const Text('Select a Department'),
                  elevation: 16,
                  dropdownColor: Colors.purple[100],
                  onChanged: (String? newValue) {
                    if (newValue == null) {
                      return;
                    }

                    selectedDepartment = newValue;
                    departmentSelected = true;

                    getObjects();

                    setState(() {});
                  },
                  items:
                      departments.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(
              width: supporting.getWindowWidth(context),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: DropdownButton<String>(
                  hint: typeSelected
                      ? Text(selectedType)
                      : const Text('Select an Object'),
                  elevation: 16,
                  dropdownColor: Colors.purple[100],
                  onChanged: (String? newValue) {
                    if (newValue == null) {
                      return;
                    }

                    selectedType = newValue;
                    typeSelected = true;

                    getObjects();

                    setState(() {});
                  },
                  items: types.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                width: 200,
                padding: const EdgeInsets.all(10),
                child: DateTimePicker(
                  initialValue: '',
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  dateLabelText: 'Start Date',
                  onChanged: (val) => startDate,
                  validator: (val) {
                    return null;
                  },
                  onSaved: (val) => startDate,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                width: 200,
                padding: const EdgeInsets.all(10),
                child: DateTimePicker(
                  initialValue: '',
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  dateLabelText: 'Start Date',
                  onChanged: (val) => startDate,
                  validator: (val) {
                    return null;
                  },
                  onSaved: (val) => startDate,
                ),
              ),
            ),
            typeSelected && departmentSelected
                ? Align(
                    alignment: Alignment.bottomLeft,
                    child: SizedBox(
                      width: 200,
                      child: Column(
                        children: children,
                      ),
                    ),
                  )
                : Container(),
            typeSelected && departmentSelected
                ? Center(
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text("Generate"),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ],
    );
  }
}
