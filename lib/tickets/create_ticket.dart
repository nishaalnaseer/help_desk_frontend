import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:platform/platform.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../supporting.dart' as supporting;
import '../application_models.dart';

class CreateTicket extends StatefulWidget {
  final String protocol;
  final String domain;
  final User user;
  final List<String> modules;
  const CreateTicket(
      {Key? key,
      required this.protocol,
      required this.domain,
      required this.user,
      required this.modules})
      : super(key: key);

  @override
  State<CreateTicket> createState() => _CreateTicketState();
}

class _CreateTicketState extends State<CreateTicket> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String email = "";
  String name = "";
  TextEditingController numController = TextEditingController();
  String contacts = "";
  TextEditingController deptController = TextEditingController();
  String department = "";
  TextEditingController locationController = TextEditingController();
  String location = "";
  TextEditingController subjectController = TextEditingController();
  String subject = "";
  TextEditingController messageController = TextEditingController();
  String message = "";
  String username = "";
  bool isThisDevice = false;

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

  List<String> ticketingDepartments = [];
  bool departmentSelected = false;
  String selectedDepartment = "";

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
                  color: Colors.red),
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
                    nameController.text = widget.user.name;
                    emailController.text = widget.user.email;
                    numController.text = widget.user.number;
                    deptController.text = widget.user.department.name;
                    locationController.text = widget.user.location;
                    setState(() {});
                  },
                  child: const Text(
                    "Autofill with your details!",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.red,
                      fontWeight: FontWeight.w500),
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
                    'Send Ticket to: ',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                    ),
                  ),
              elevation: 16,
              onChanged: (String? newValue) {
                if (newValue == null) {
                  return;
                }
                selectedDepartment = newValue;
                departmentSelected = true;
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
                      fontSize: 18),
                  ),
                );
              }).toList(),
            ),
          ),
          inputField(nameController, name, "Name"),
          inputField(emailController, email, "Email"),
          inputField(numController, contacts, "Contact Number"),
          inputField(deptController, department, "Department"),
          inputField(locationController, location, "Location"),
          inputField(subjectController, subject, "Subject"),
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
          inputField(messageController, message, "Message",
              maximumLines: 50, minimumLines: 1),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                child: ElevatedButton(
                  onPressed: () async {
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

                // todo return new ticket id from server and display it on the prompt

                    Ticket ticket = Ticket(
                        tId: 0,
                        submittedOn: 0,
                        submittedBy: widget.user.email,
                        ticketTo: selectedDepartment,
                        nameTicket: nameController.text,
                        emailTicket: emailController.text,
                        numberTicket: numController.text,
                        deptTicket: deptController.text,
                        location: locationController.text,
                        subject: subjectController.text,
                        message: messageController.text,
                        ip: "",
                        host: host,
                        username: username,
                        hostIssue: isThisDevice,
                        platform: platform.operatingSystem,
                        status: "RAISED",
                        devices: [],
                        messages: [],
                        updates: []);
                    var ticketInfo = ticket.toJson();
                    var header = widget.user.getAuth();
                    header.putIfAbsent(
                        "Content-Type", () => "application/json");
                    var response = await supporting.postRequest2(
                      jsonEncode(ticketInfo),
                      widget.protocol,
                      widget.domain,
                      "ticket",
                      context,
                      headers: header,
                      showPrompt: true,
                      promptTitle: "Nice!",
                      promptMessage: "Ticket Submitted"
                    );
                    if(response.statusCode == 200 ||
                      response.statusCode == 201) {
                      nameController.text = "";
                      emailController.text = "";
                      numController.text = "";
                      deptController.text = "";
                      locationController.text = "";
                      subjectController.text = "";
                      messageController.text = "";
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
                      fontSize: 17),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      widget.user);
  }
}
