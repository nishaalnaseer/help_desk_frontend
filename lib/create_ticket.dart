import 'package:flutter/material.dart';
import 'supporting.dart' as supporting;

class CreateTicket extends StatefulWidget {
  final String protocol;
  final String domain;
  const CreateTicket({Key? key, required this.protocol, required this.domain}) : super(key: key);

  @override
  State<CreateTicket> createState() => _CreateTicketState();
}

class _CreateTicketState extends State<CreateTicket> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String email = "";
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

  List<String> ticketForDepartments = ["IT"];
  List<String> ticketingDepartments = [];
  bool departmentSelected = false;
  String selectedDepartment = "";

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              10,
              supporting.getWindowHeight(context) * 0.05,
              10,
              20
            ),
            child: SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: () {  },
                child: const Text(
                  "Autofill with your details!"
                ),
              ),
            ),
          ),
        ),
        Row(
          children: [
            const Expanded(
              flex: 20,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Send Ticket to: ",
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            Expanded(
              flex: 80,
              child: SizedBox(
                width: 150,
                child: DropdownButton<String>(
                  hint: departmentSelected ? Text(selectedDepartment) : const Text('Select a Department'),
                  elevation: 16,
                  dropdownColor: Colors.purple[100],
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
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: nameController,
            onChanged: (value) => username = value,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Name',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: emailController,
            onChanged: (value) => email = value,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: numController,
            onChanged: (value) => contacts = value,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Contact Number',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: deptController,
            onChanged: (value) => department = value,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Department',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: locationController,
            onChanged: (value) => location = value,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Location of Issue',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: subjectController,
            onChanged: (value) => subject = value,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Subject',
            ),
          ),
        ),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
              child: Text("Is this the device having issues?"),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              child: Checkbox(

                value: isThisDevice, // Pass the boolean variable to the value property
                onChanged: (bool? value) {
                  setState(() {
                    isThisDevice = value ?? false; // Update the checkbox state when it's toggled
                  });
                },
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            maxLines: 15,
            controller: messageController,
            onChanged: (value) => message = value,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Message',
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              child: ElevatedButton(
                onPressed: () {  },
                child: const Text(
                  "Submit!"
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
