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

  final ScrollController controller = ScrollController();
  final ScrollController controller2 = ScrollController();
  List<DataRow> rows = [];

  Future<void> getModels() async {
    String contents = await supporting.getApiData(
      "models?department=IT&category=TV",
      widget.domain,
      widget.protocol
    );
    List<dynamic> coded = jsonDecode(contents);
    rows = [];
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
    String contents = await supporting.getApiData(
      "departments",
      widget.domain,
      widget.protocol
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
      widget.domain,
      widget.protocol
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

  double getWindowWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Center(
          child: SizedBox(
            width: getWindowWidth(context) - 20,
            child: Padding(
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
          ),
        ),
        departmentSelected ? Center(
          child: SizedBox(
            width: getWindowWidth(context) - 20,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownButton<String>(
                hint: categorySelected ? Text(selectedCategory) : const Text('Select a Category'),
                elevation: 16,
                dropdownColor: Colors.purple[100],
                onChanged: (String? newValue) {
                  if(newValue == null) {
                    return;
                  }
                  selectedCategory = newValue;
                  categorySelected = true;

                  getModels();

                  setState(() {

                  });
                },
                items: categories.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        )
            : Container(),

        categorySelected ? Center(
          child: Scrollbar(
            controller: controller2,
            child: SingleChildScrollView(
              controller: controller2,
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: getWindowWidth(context) - 20,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Brand"),),
                    DataColumn(label: Text("Description"),),
                    DataColumn(label: Text("Department"),),
                    DataColumn(label: Text("Category"),),
                    DataColumn(label: Text("Qty"),),
                    DataColumn(label: Text('Year'),),
                  ],
                  rows: rows,
                ),
              ),
            ),
          ),
        ) :
        Container(),
      ],
    );
  }
}
