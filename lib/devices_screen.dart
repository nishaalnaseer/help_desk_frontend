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

  final ScrollController controller = ScrollController();
  final ScrollController controller2 = ScrollController();
  List<DataRow> rows = [];

  Future<List<String>> getDepartments() async {
    String contents = await supporting.getApiData(
      "departments",
      widget.domain,
      widget.protocol,
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
      widget.protocol,
    );
    categories = [];
    List<dynamic> coded = jsonDecode(contents);
    for(var x in coded) {
      categories.add(x);
    }

    setState(() {

    });
  }

  Future<void> getDevices() async {
    String contents = await supporting.getApiData(
      "devices?department=$selectedDepartment&category=$selectedCategory",
      widget.domain,
      widget.protocol,
    );
    rows = [];
    List<dynamic> coded = jsonDecode(contents);
    for(var x in coded) {
      Device device = Device.fromJson(x);
      rows.add(
          DataRow(
              cells: [
                DataCell(Text(device.model.brand),),
                DataCell(Text(device.model.description),),
                DataCell(Text(device.location)),
                DataCell(Text("${device.model.year}")),
                DataCell(Text(device.serialNo)),
                DataCell(Text("${device.staticIp}")),
                DataCell(Text(device.ip)),
                DataCell(Text(device.mac)),
                DataCell(Text(device.remarks)),
                DataCell(Text(device.supplies)),
                DataCell(Text(device.obtainedOn)),
                DataCell(Text(device.obtainedFrom)),
                DataCell(Text(device.lastServiced)),
                DataCell(Text('${device.totalServiced}')),
              ]
          )
      );
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

                  getDevices();

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
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Brand'),),
                  DataColumn(label: Text('Description'),),
                  DataColumn(label: Text('Location'),),
                  DataColumn(label: Text('Year'),),
                  DataColumn(label: Text('Serial Number'),),
                  DataColumn(label: Text('Static IP?'),),
                  DataColumn(label: Text('Last Known IP'),),
                  DataColumn(label: Text('MAC'),),
                  DataColumn(label: Text('Remarks'),),
                  DataColumn(label: Text('Supplies'),),
                  DataColumn(label: Text('Obtained'),),
                  DataColumn(label: Text('Obtained From'),),
                  DataColumn(label: Text('Last Serviced'),),
                  DataColumn(label: Text('Total Serviced'),),
                ],
                rows: rows,
              ),
            ),
          ),
        ) :
        Container(),
      ],
    );
  }
}


