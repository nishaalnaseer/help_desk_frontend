import 'package:flutter/material.dart';

class ViewTicket extends StatefulWidget {
  final String protocol;
  final String domain;
  final int ticketId;
  const ViewTicket({
    super.key, required this.protocol, required this.domain,
    required this.ticketId
  });

  @override
  State<ViewTicket> createState() => _ViewTicketState();
}

class _ViewTicketState extends State<ViewTicket> {
  TextStyle style = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 18
  );


  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Center(
          child: Text(
            "View Ticket",
            style: style,
          ),
        )
      ],
    );
  }
}
