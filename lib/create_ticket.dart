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
              10
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
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: nameController,
            onChanged: (value) => username = value,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'User Name',
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
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
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
