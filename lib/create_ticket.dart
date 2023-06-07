import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:window_manager/window_manager.dart';

import 'supporting.dart' as supporting;
import 'application_models.dart';

class CreateTicket extends StatefulWidget {
  final String protocol;
  final String domain;
  final User user;
  const CreateTicket({
    Key? key, required this.protocol, required this.domain, required this.user
  }) : super(key: key);

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
  bool isThisDevice = true;

  Padding inputField(
      TextEditingController controller, String holder, String display,
      {int maximumLines = 1, int minimumLines = 1}) {
    return Padding (
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: controller,
        cursorColor: Colors.red,
        minLines: minimumLines,
        maxLines: maximumLines,
        onChanged: (value) => holder = value,
        style: const TextStyle(
            fontSize: 18,
            color: Colors.white
        ),
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
          labelStyle: const TextStyle(
              fontSize: 18,
              color: Colors.white
          ),
        ),
      ),
    );
  }

  List<String> ticketForDepartments = ["IT"];
  List<String> ticketingDepartments = [];
  bool departmentSelected = false;
  String selectedDepartment = "";

  @override
  Widget build(BuildContext context) {
    return supporting.getScaffold(
        Container(
      color: Colors.black87,
      child: ListView(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  10,
                  supporting.getWindowHeight(context) * 0.05,
                  10,
                  20
              ),
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
                    nameController.text = widget.user.name;
                    emailController.text = widget.user.email;
                    numController.text = widget.user.number;
                    deptController.text = widget.user.department;
                    locationController.text = widget.user.location;
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
              hint: departmentSelected ? Text(
                'Send Ticket to: $selectedDepartment',
                style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                ),
              ) : const Text(
                'Send Ticket to: ',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                ),
              ),
              elevation: 16,
              onChanged: (String? newValue) {
                if(newValue == null) {
                  return;
                }
                selectedDepartment = newValue;
                departmentSelected = true;
                setState(() {
                });
              },
              items: ticketForDepartments.map<DropdownMenuItem<String>>((String value) {
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
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17
                  ),
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
          inputField(
              messageController, message, "Message",
              maximumLines: 50, minimumLines: 1
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                child: ElevatedButton(
                  onPressed: () async {

                    Ticket ticket = Ticket(
                        tId: 0,
                        submittedBy: widget.user.id,
                        ticketTo: selectedDepartment,
                        nameTicket: nameController.text,
                        emailTicket: emailController.text,
                        numberTicket: numController.text,
                        deptTicket: deptController.text,
                        location: locationController.text,
                        subject: subjectController.text,
                        message: messageController.text,
                        devices: [1]
                    );

                    await supporting.postRequest(
                        ticket.toJson(), widget.protocol, widget.domain,
                        "ticket", context
                    );
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
    )
    );
  }
}