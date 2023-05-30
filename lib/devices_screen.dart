import 'dart:convert';

import 'package:flutter/material.dart';

import 'supporting.dart' as supporting;
import 'application_models.dart';

class DevicesScreen extends StatefulWidget {
  final String protocol;
  final String domain;
  const DevicesScreen({Key? key, required this.protocol, required this.domain}) : super(key: key);

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  List<String> departments = [];
  String selectedDepartment = "";
  bool departmentSelected = false;

  List<String> categories = [];
  String selectedCategory = "";
  bool categorySelected = false;

  DataTable devices = DataTable(
    columns: const [
      DataColumn(label: Wrap(children: [Text('Brand'),])),
      DataColumn(label: Wrap(children: [Text('Description'),])),
      DataColumn(label: Wrap(children: [Text('Location'),])),
      DataColumn(label: Wrap(children: [Text('Year'),])),
      DataColumn(label: Wrap(children: [Text('Obtained'),])),
      DataColumn(label: Wrap(children: [Text('Obtained From'),])),
      DataColumn(label: Wrap(children: [Text('Last Serviced'),])),
      DataColumn(label: Wrap(children: [Text('Total Serviced'),])),
    ],
    rows: [],
  );

  Future<List<String>> getDepartments() async {
    String contents = await supporting.getApiData(
      "departments",
      widget.protocol,
      widget.domain
    );
    List<dynamic> coded = await jsonDecode(contents);
    List<String> departments = [];
    for(var x in coded) {
      departments.add(x);
    }
    return departments;
  }

  Future<void> initDangIt() async {
    departments = await getDepartments();
    setState(() {
    });
  }

  Future<void> getCategories() async {
    String contents = await supporting.getApiData(
      "categories?department=$selectedDepartment",
      widget.protocol,
      widget.domain
    );
    categories = [];
    List<dynamic> coded = jsonDecode(contents);
    for(var x in coded) {
      categories.add(x);
    }

    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    initDangIt();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 500,
        width: 1500,
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: DropdownButton<String>(
                  hint: departmentSelected ? Text(selectedDepartment) : const Text('Select a Department'),
                  elevation: 16,
                  dropdownColor: Colors.purple[100],
                  onChanged: (String? newValue) {
                    if(newValue == null) {
                      return;
                    }

                    categorySelected = false;
                    selectedDepartment = newValue;
                    departmentSelected = true;
                    getCategories();
                    setState(() {
                    });
                  },
                  items: departments.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              departmentSelected ? Padding(
                padding: const EdgeInsets.all(10),
                child: DropdownButton<String>(
                  hint: categorySelected ? Text(selectedCategory) : const Text('Select a Category'),
                  elevation: 16,
                  dropdownColor: Colors.purple[100],
                  onChanged: (String? newValue) {
                    if(newValue == null) {
                      return;
                    }

                    setState(() {
                      selectedCategory = newValue;
                      categorySelected = true;
                    });
                  },
                  items: categories.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              )
                  : Container(),
              categorySelected ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                      width: 1500,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: devices
                  ),
                ),
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
