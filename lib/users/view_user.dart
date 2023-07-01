import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:help_desk_frontend/supporting.dart' as supporting;
import  'package:flutter/material.dart';
import 'package:help_desk_frontend/application_models.dart';

class ViewUser extends StatefulWidget {
  final String protocol;
  final String domain;
  final User user;
  final User userScope;

  const ViewUser({
    super.key,
    required this.protocol,
    required this.domain,
    required this.user,
    required this.userScope
  });

  @override
  State<ViewUser> createState() => _ViewUserState();
}

class _ViewUserState extends State<ViewUser> {
  late User user = widget.userScope;
  TextStyle style = const TextStyle(
    fontSize: 18,
    color: Colors.white,
    fontWeight: FontWeight.w500
  );
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
  bool resetPassword = false;
  late String status = user.status;

  late String selectedDepartment = user.department.name;
  List<String> departments = [];

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

  // department
  // status

  void init() async {

    var response = await http.get(
        Uri.parse("${widget.protocol}://"
            "${widget.domain}/all_departments_and_modules"),
        headers: widget.user.getAuth()
    );

    if(response.statusCode != 200) {
      return;
    }

    Map<String, dynamic> data = jsonDecode(response.body);

    List<dynamic> departments = data["departments"];

    for(var x in departments) {
      this.departments.add(x);
    }

    nameController.text = user.name;
    locationController.text = user.location;
    emailController.text = user.email;
    numberController.text = user.number;
    socialMediaController.text = user.socialMedia ?? "";
    setState(() {

    });
  }

  @override
  void initState() {
    init();
    super.initState();
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
                "View/Edit User",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 25
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
              child: Text(
                "ID: ${user.id}",
                style: style,
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
          Align(
            alignment: Alignment.bottomLeft,
            child: SizedBox(
              width: 350,
              child: CheckboxListTile(
                title: const Text(
                  "Reset Password?",
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
                // activeColor: Colors.white,
                selectedTileColor: Colors.red,
                checkColor: Colors.white,
                value: resetPassword,
                fillColor: MaterialStateProperty.all<Color>(Colors.red),
                hoverColor: Colors.red[100],
                onChanged: (bool? value) {
                  setState(() {
                    resetPassword = value ?? false;
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: DropdownButton<String>(
              focusColor: Colors.transparent,
              dropdownColor: Colors.red[800],
              hint: Text(
                'Set User Department: $selectedDepartment',
                style: const TextStyle(
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
                'Set User Status: $status',
                style: const TextStyle(
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
                status = newValue;
                setState(() {});
              },
              items: ["ENABLED", "DISABLED"]
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
          Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () async {

                  Department department = Department(
                    dId: user.department.dId,
                    name: selectedDepartment,
                    defaultView: user.department.defaultView,
                    ticketable: user.department.ticketable,
                    submittedBy: user.department.submittedBy,
                    modules: user.department.modules,
                    accessibleTickets: user.department.accessibleTickets,
                    ticketsRaisedFrom: user.department.ticketsRaisedFrom,
                    nonTicketableReports: user.department.nonTicketableReports,
                    ticketableReports: user.department.ticketableReports
                  );

                  User newUser = User(
                    id: user.id,
                    name: nameController.text,
                    department: department,
                    email: emailController.text,
                    number: numberController.text,
                    location: locationController.text,
                    defaultView: user.defaultView,
                    status: status,
                    socialMedia: socialMediaController.text
                  );
                  var data = newUser.toJson();
                  data.putIfAbsent("password", () => "p"*60);

                  var response = supporting.patchRequest(
                    jsonEncode(data),
                    widget.protocol,
                    widget.domain,
                    "user?reset_password=$resetPassword",
                    context,
                    widget.user.getAuth(),
                    backTwice: true,
                    showPrompt: true,
                    promptTitle: "User Details Changed!",
                    promptMessage: "${user.email} Changed!"
                  );
                },
                child: const Text(
                  "Submit Changes",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Colors.red
                  ),
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
