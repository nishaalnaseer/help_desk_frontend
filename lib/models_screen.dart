import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import 'application_models.dart';
import 'supporting.dart' as supporting;

class ModelsScreen extends StatefulWidget {
  final String protocol;
  final String domain;
  const ModelsScreen({Key? key, required this.protocol, required this.domain}) : super(key: key);

  @override
  State<ModelsScreen> createState() => _ModelsScreenState();
}

class _ModelsScreenState extends State<ModelsScreen> {
  List<String> departments = [];
  String selectedDepartment = "";
  bool departmentSelected = false;

  List<String> categories = [];
  String selectedCategory = "";
  bool categorySelected = false;

  DataTable childrenModels = DataTable(
    columns: const [
      DataColumn(label: Text('Brand')),
      DataColumn(label: Text('Description')),
      DataColumn(label: Text('Department')),
      DataColumn(label: Text('Category')),
      DataColumn(label: Text('Qty')),
      DataColumn(label: Text('Year')),
    ],
    rows: [],
  );

  Future<void> getModels() async {
    String contents = await getApiData("models?department=IT&category=TV");
    List<dynamic> coded = jsonDecode(contents);
    List<DataRow> rows = [];

    childrenModels = DataTable(
      columns: const [
        DataColumn(label: Text('Brand')),
        DataColumn(label: Text('Description')),
        DataColumn(label: Text('Department')),
        DataColumn(label: Text('Category')),
        DataColumn(label: Text('Qty')),
        DataColumn(label: Text('Year')),
      ],
      rows: rows,
    );
    for(var obj in coded){
      Map<String, dynamic> dataMap = supporting.convertDynamicToMap(obj);

      Model model = Model.fromJson(dataMap);
      rows.add(
        DataRow(
          cells: [
            DataCell(Text(model.brand),),
            DataCell(Text(model.description)),
            DataCell(Text(model.department)),
            DataCell(Text(model.category)),
            DataCell(Text("${model.qty}")),
            DataCell(Text("${model.year}")),
          ]
        )
      );
    }
    setState(() {
    });
  }

  Future<List<String>> getDepartments() async {
    String contents = await getApiData("departments");
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

  Future<String> getApiData(String path) async {
    String domain = widget.domain;
    String protocol = widget.protocol;

    var uri = Uri.parse('$protocol://$domain/$path');
    var response = await http.get(uri);
    return response.body;
  }

  Future<void> getCategories() async {
    String contents = await getApiData("categories?department=$selectedDepartment");
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

                    getModels();
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
                      child: childrenModels
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
