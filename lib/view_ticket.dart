import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'application_models.dart';
import 'supporting.dart' as supporting;

class ViewTicket extends StatefulWidget {
  final String protocol;
  final String domain;
  final Ticket ticket;
  final User user;
  const ViewTicket({
    super.key, required this.protocol, required this.domain,
    required this.ticket, required this.user
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
  bool newStatusSelected = false;
  String selectedNewStatus = "";
  TextEditingController controller = TextEditingController();
  String newMessage = "";
  bool addingMessage = false;
  ScrollController scroll = ScrollController();

  List<Widget> messages = [];
  bool messagesHidden = false;
  bool hideButtons = false;

  Padding getText(String text) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        style: style,
      ),
    );
  }

  String formatDate(int time) {
    // Convert timestamp to DateTime
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time * 1000);

    // Format DateTime as "Monday 11-May-23"
    String formattedDate = DateFormat("EEEE d-MMM-yy HH:MM").format(dateTime);

    return formattedDate; // Output: Monday 11-May-23
  }

  void getMessages() {
    for(Message message in widget.ticket.messages) {
      Widget child = Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
            constraints: const BoxConstraints(
                minWidth: 1920,
                minHeight: 50
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Time: ${formatDate(message.time)}",
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 18
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "From: ${message.personFrom}",
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Message: ${message.message}",
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 18
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
        ),
      );
      messages.add(child);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMessages();

    hideButtons = messagesHidden &&
        widget.ticket.messages.length > 2;
  }

  @override
  Widget build(BuildContext context) {
    return supporting.getScaffold(
      ListView(
        controller: scroll,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 20),
            child: Center(
              child: Text(
              "View Ticket",
              style: style,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                SizedBox(
                  width: 300,
                  child: DropdownButton<String>(
                    focusColor: Colors.transparent,
                    dropdownColor: Colors.red[800],
                    hint: newStatusSelected ? Text(
                      'Mark Ticket as:  $selectedNewStatus',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.white
                      ),
                    ) : const Text(
                      'Mark Ticket as: ',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.white
                      ),
                    ),
                    elevation: 16,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        selectedNewStatus = newValue;
                        newStatusSelected = true;
                      }
                      setState(() {

                      });
                    },
                    items: [
                      "Ongoing",
                      "On hold",
                      "Completed",
                      "Rejected",
                    ].map<DropdownMenuItem<String>>((String value) {
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
                newStatusSelected ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                      onPressed: () {},
                      child: const Text(
                        "Set Status",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.red
                        ),
                      )
                  ),
                )
                  : Container()
              ],
            ),
          ),
          getText('Ticket ID: ${formatDate(widget.ticket.submittedOn)}'),
          getText('Submitted On: ${widget.ticket.submittedOn}'),
          getText('Submitted By: ${widget.ticket.submittedBy}'),
          getText('Ticket To: ${widget.ticket.ticketTo}'),
          getText('Name on Ticket: ${widget.ticket.nameTicket}'),
          getText('Email on Ticket: ${widget.ticket.emailTicket}'),
          getText('Contact Number on Ticket: ${widget.ticket.numberTicket}'),
          getText('Department on Ticket: ${widget.ticket.deptTicket}'),
          getText('Location on Ticket: ${widget.ticket.location}'),
          getText('Ticket Subject: ${widget.ticket.subject}'),
          getText('Ticket Initial Message: ${widget.ticket.message}'),

          hideButtons
          ? Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10,20,10,10),
              child: ElevatedButton(
                  onPressed: () {
                    messagesHidden != messagesHidden;

                    hideButtons = messagesHidden &&
                        widget.ticket.messages.length > 2;

                    setState(() {
                      messagesHidden = true;
                    });
                  },
                  child: const Text(
                    "Hide Messages",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.red
                    ),
                  )
              ),
            ),
          )
          : Container(),

          messagesHidden ?
          Container() :
          Column(
            children: messages,
          ),

          hideButtons
          ? Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10,20,10,10),
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      messagesHidden = true;
                    });
                  },
                  child: const Text(
                    "Hide Messages",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.red
                    ),
                  )
              ),
            ),
          )
          : Container(),

          messagesHidden ?
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10,20,10,10),
              child: ElevatedButton(
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    scroll.animateTo(
                      scroll.position.maxScrollExtent,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  });

                  setState(() {
                    messagesHidden = false;
                  });
                },
                child: const Text(
                  "Show Messages",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.red
                  ),
                )
              ),
            ),
          )
          : Container(),

          addingMessage ? Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: controller,
              cursorColor: Colors.red,
              minLines: 1,
              maxLines: 10,
              onChanged: (value) => newMessage = value,
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white
              ),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red), // Change the color here
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red), // Change the color here
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red), // Change the color here
                ),
                labelText: "Add a Message",
                labelStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.white
                ),
              ),
            ),
          )
          : Center(
               child: Padding(
                 padding: const EdgeInsets.all(10),
                 child: ElevatedButton(
                   onPressed: () {
                     WidgetsBinding.instance.addPostFrameCallback((_) {
                       scroll.animateTo(
                         scroll.position.maxScrollExtent,
                         duration: Duration(milliseconds: 300),
                         curve: Curves.easeOut,
                       );
                     });
                     setState(() {
                       addingMessage = true;

                     });
                   },
                   child: const Text(
                     "Add a Message",
                     style: TextStyle(
                       fontSize: 18,
                       fontWeight: FontWeight.w500,
                       color: Colors.red
                     ),
                   )
                 ),
               ),
          ),

          addingMessage ? Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      addingMessage = false;
                    });
                  },
                  child: const Text(
                    "Add a Message",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.red
                    ),
                  )
              ),
            ),
          )
          : Container()
        ],
      ), widget.user
    );
  }
}
