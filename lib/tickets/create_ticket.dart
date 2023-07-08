import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:platform/platform.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../supporting.dart' as supporting;
import '../application_models.dart';
import '../input_validations.dart';

class CreateTicket extends StatefulWidget {
  final String server;
  final User user;
  final List<String> modules;
  const CreateTicket(
      {Key? key,
        required this.server,
        required this.user,
        required this.modules})
      : super(key: key);

  @override
  State<CreateTicket> createState() => _CreateTicketState();
}

class _CreateTicketState extends State<CreateTicket> {
  List<String> categories = [];
  var name = InputField(display: "Name");
  var email = InputField(display: "Email");
  var number = InputField(display: "Contact Number");
  var location = InputField(display: "Location");
  var subject = InputField(display: "Subject");
  var message = InputField(
      display: "Message",
      maximumLines: 50,
      minimumLines: 1
  );
  late final List<InputField>  inputs = [
    name, email, number,
    location, subject, message
  ];

  bool isThisDevice = false;
  List<String> ticketableDepartments = [];
  bool departmentSelected = false;
  String selectedDepartment = "";

  String selectedCategory = "";
  bool categorySelected = false;

  void getData() async {
    var response = await http.get(
        Uri.parse(
            "${widget.server}/all_departments_and_modules"
        ),
        headers: widget.user.getAuth()
    );

    if (response.statusCode != 200) {
      return;
    }

    Map<String, dynamic> data = jsonDecode(response.body);
    List<dynamic> ticketable = data["ticketable"];
    List<String> deps = [];

    for (var x in ticketable) {
      deps.add(x);
    }

    ticketableDepartments = deps;
    setState(() {

    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return supporting.getScaffold(
      ListView(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  10, supporting.getWindowHeight(context) * 0.05, 10, 20),
              child: const Text(
                "Create a Ticket!",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: Colors.red
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: () {
                    name.setText(widget.user.name);
                    email.setText(widget.user.email);
                    number.setText(widget.user.number);
                    location.setText(widget.user.location);
                    setState(() {

                    });
                  },
                  child: const Text(
                    "Autofill with your details!",
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.red,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: DropdownButton<String>(
              focusColor: Colors.transparent,
              dropdownColor: Colors.red[800],
              hint: departmentSelected
                  ? Text(
                'Send Ticket to: $selectedDepartment',
                style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              )
                  : const Text(
                'Send Ticket to: *',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                ),
              ),
              elevation: 16,
              onChanged: (String? newValue) async {
                if (newValue == null) {
                  return;
                }
                selectedDepartment = newValue;
                departmentSelected = true;

                var response = await supporting.getRequest(
                  widget.server,
                  "/department/ticket_categories?department=$selectedDepartment",
                  context,
                  headers: widget.user.getAuth()
                );

                if (response.statusCode != 200) {
                  return;
                }

                var categories = jsonDecode(response.body);
                setState(() {
                  this.categories = List.generate(
                      categories.length, (index) => categories[index]
                  );
                });
              },
              items: ticketableDepartments
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  ),
                );
              }).toList(),
            ),
          ),
          departmentSelected ? Padding(
            padding: const EdgeInsets.all(10),
            child: DropdownButton<String>(
              focusColor: Colors.transparent,
              dropdownColor: Colors.red[800],
              hint: categorySelected
                  ? Text(
                'Category: $selectedCategory',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
              )
                  : const Text(
                'Select a Category: *',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Colors.white
                ),
              ),
              elevation: 16,
              onChanged: (String? newValue) async {
                if (newValue == null) {
                  return;
                }
                selectedCategory = newValue;
                categorySelected = true;

                setState(() {});
              },
              items: categories
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
          ) :
          Container(),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              "Ticket From: ${widget.user.department.name}",
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: name.inputField,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: email.inputField,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: number.inputField,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: location.inputField,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: subject.inputField,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: SizedBox(
              width: 400,
              child: CheckboxListTile(
                title: const Text(
                  "Is this the device having issues?",
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
                // activeColor: Colors.white,
                selectedTileColor: Colors.red,
                checkColor: Colors.white,
                value: isThisDevice,
                fillColor: MaterialStateProperty.all<Color>(Colors.red),
                hoverColor: Colors.red[100],
                onChanged: (bool? value) {
                  setState(() {
                    isThisDevice = value ?? false;
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: message.inputField,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                child: ElevatedButton(
                  onPressed: () async {

                    if (!(departmentSelected || categorySelected)) {
                      supporting.showPopUp(
                          context,
                          "Validation Error",
                          "Department AND OR Category Can't be Empty!"
                      );
                      return;
                    }

                    bool ok = inputValidation(inputs, context);
                    if (!ok) {
                      return;
                    }

                    Platform platform = const LocalPlatform();
                    String host;
                    String username;
                    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                    if (kIsWeb) {
                      WebBrowserInfo webBrowserInfo =
                      await deviceInfo.webBrowserInfo;
                      host = webBrowserInfo.browserName.name;
                      username = "";
                    } else if (platform.isWindows) {
                      WindowsDeviceInfo windowsInfo =
                      await deviceInfo.windowsInfo;
                      host = windowsInfo.computerName;
                      username = windowsInfo.userName;
                    } else if (platform.isLinux) {
                      LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
                      host = linuxInfo.machineId ?? "";
                      username = linuxInfo.name;
                    } else if (platform.isAndroid) {
                      AndroidDeviceInfo android =
                      await deviceInfo.androidInfo;
                      host = android.host;
                      username = "";
                    } else if (platform.isIOS) {
                      IosDeviceInfo ios = await deviceInfo.iosInfo;
                      host = ios.name;
                      username = "";
                    } else {
                      host = "unknown";
                      username = "unknown";
                    }

                    Ticket ticket = Ticket(
                        tId: 0,
                        submittedOn: 0,
                        submittedBy: widget.user.email,
                        ticketTo: selectedDepartment,
                        nameTicket: name.text(),
                        emailTicket: email.text(),
                        numberTicket: number.text(),
                        deptTicket: widget.user.department.name,
                        location: location.text(),
                        subject: subject.text(),
                        message: message.text(),
                        ip: "",
                        host: host,
                        username: username,
                        hostIssue: isThisDevice,
                        platform: platform.operatingSystem,
                        status: "RAISED",
                        category: selectedCategory,
                        devices: [],
                        messages: [],
                        updates: []);
                    var ticketInfo = ticket.toJson();
                    var header = widget.user.getAuth();
                    header.putIfAbsent(
                        "Content-Type", () => "application/json");
                    var response = await supporting.postRequest2(
                        jsonEncode(ticketInfo),
                        widget.server,
                        "/ticket",
                        context,
                        headers: header,
                        showPrompt: true,
                        promptTitle: "Nice!",
                        promptMessage: "Ticket Submitted"
                    );
                    if(response.statusCode == 200 ||
                        response.statusCode == 201) {
                      name.clear();
                      email.clear();
                      number.clear();
                      location.clear();
                      subject.clear();
                      message.clear();
                      selectedDepartment = "";
                      departmentSelected = false;
                    }
                    setState(() {});
                  },
                  child: const Text(
                    "Submit!",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                        fontSize: 17
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      widget.user,
      widget.server,
    );
  }
}
