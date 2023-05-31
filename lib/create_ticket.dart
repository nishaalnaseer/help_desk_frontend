import 'package:flutter/material.dart';

class CreateTicket extends StatefulWidget {
  final String protocol;
  final String domain;
  const CreateTicket({Key? key, required this.protocol, required this.domain}) : super(key: key);

  @override
  State<CreateTicket> createState() => _CreateTicketState();
}

class _CreateTicketState extends State<CreateTicket> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
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
      ],
    );
  }
}
