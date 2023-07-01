import 'dart:convert';

import 'package:help_desk_frontend/supporting.dart' as supporting;
import  'package:flutter/material.dart';
import 'package:help_desk_frontend/application_models.dart';
import 'package:http/http.dart' as http;

class CreateUser extends StatefulWidget {
  final String protocol;
  final String domain;
  final User user;
  const CreateUser({
    super.key,
    required this.protocol,
    required this.domain,
    required this.user
  });

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  TextEditingController nameController = TextEditingController();
  String name = "";
  TextEditingController locationController = TextEditingController();
  String location = "";
  TextEditingController emailController = TextEditingController();
  String email = "";
  TextEditingController numberController = TextEditingController();
  String number = "";
  TextEditingController socialMediaController = TextEditingController();
  String socialMedia = "";

  String department = "";
  late String defaultModule = widget.user.department.defaultView;
  bool departmentSelected = false;
  bool moduleSelected = false;
  List<String> departments = [];
  List<String> modules = [];

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
        style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w500
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
          labelStyle: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  void getModulesDepartments() async {
    var response = await http.get(
      Uri.parse("${widget.protocol}://"
          "${widget.domain}/all_departments_and_modules"),
      headers: widget.user.getAuth()
    );

    if(response.statusCode != 200) {
      return;
    }

    Map<String, dynamic> data = jsonDecode(response.body);

    List<dynamic> modules = data["modules"];
    List<dynamic> departments = data["departments"];

    for(var x in modules) {
      this.modules.add(x);
    }

    for(var x in departments) {
      this.departments.add(x);
    }

    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    getModulesDepartments();
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
            const Center(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  "Create User",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 25
                  ),
                ),
              ),
            ),
            inputField(
              nameController,
              name,
              "Name"
            ),
            inputField(
              emailController,
              email,
              "Email"
            ),
            inputField(
              numberController,
              number,
              "Number"
            ),
            inputField(
              locationController,
              location,
              "Location"
            ),
            inputField(
              socialMediaController,
              socialMedia,
              "Social Media ID"
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownButton<String>(
                focusColor: Colors.transparent,
                dropdownColor: Colors.red[800],
                hint: departmentSelected
                    ? Text(
                  'User Department: $department',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                  ),
                )
                    : const Text(
                  'Select User Department',
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
                  department = newValue;
                  departmentSelected = true;
                  setState(() {});
                },
                items: departments
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
            Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownButton<String>(
                focusColor: Colors.transparent,
                dropdownColor: Colors.red[800],
                hint: Text(
                  'User Default View $defaultModule',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
                ),
                elevation: 16,
                onChanged: (String? newValue) {
                  if (newValue == null) {
                    return;
                  }
                  defaultModule = newValue;
                  setState(() {});
                },
                items: modules
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

            Center(
              child: Container(
                padding: const EdgeInsets.all(10),
                width: 200,
                child: ElevatedButton(
                  onPressed: () async {
                    String name = nameController.text;
                    String location = locationController.text;
                    String email = emailController.text;
                    String number = numberController.text;
                    String socialMedia = socialMediaController.text;

                    User user = User(
                      id: 0,
                      name: name,
                      department: Department(
                        dId: 0,
                        name: department,
                        defaultView: widget.user.
                              department.defaultView,
                        ticketable: false,
                        submittedBy: '1',
                        modules: ["CREATE_TICKET"],
                        accessibleTickets: [],
                        ticketsRaisedFrom: [],
                        nonTicketableReports: [],
                        ticketableReports: [],
                      ),
                      socialMedia: socialMedia,
                      email: email,
                      number: number,
                      location: location,
                      defaultView: defaultModule,
                      status: "ENABLED",
                    );

                    var data = user.toJson();
                    data.putIfAbsent("password", () => "p" * 60);
                    data.putIfAbsent("status", () => "ENABLED");
                    var headers = widget.user.getAuth();
                    var response = await supporting.postRequest2(
                      jsonEncode(data),
                      widget.protocol,
                      widget.domain,
                      "user",
                      context,
                      headers: headers,
                      showPrompt: true,
                      promptTitle: "Nice!",
                      promptMessage: "$email Created!",
                      backTwice: true
                    );
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Colors.red
                    ),
                  )
                ),
              ),
            )
          ],
        ),
        widget.user
    );
  }
}
