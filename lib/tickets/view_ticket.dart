import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../application_models.dart';
import '../supporting.dart' as supporting;
import 'package:http/http.dart' as http;


class ViewTicket extends StatefulWidget {
  final String server;
  final Ticket ticket;
  final User user;
  const ViewTicket(
      {super.key,
      required this.server,
      required this.ticket,
      required this.user,
      });

  @override
  State<ViewTicket> createState() => _ViewTicketState();
}

class _ViewTicketState extends State<ViewTicket> {
  TextStyle style = const TextStyle(
      color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18);
  bool newStatusSelected = false;
  String selectedNewStatus = "";
  TextEditingController controller = TextEditingController();
  String newMessage = "";
  bool addingMessage = false;
  ScrollController scroll = ScrollController();

  List<Widget> updates = [];
  bool messagesHidden = false;
  bool hideButtons = false;
  final FocusNode _textFieldFocusNode = FocusNode();
  late bool canAddMessages = (widget.ticket.status != "COMPLETED" &&
      widget.ticket.status != "REJECTED");
  late bool showChangeStatus =
      (widget.ticket.ticketTo == widget.user.department.name) && canAddMessages;
  late String newCategory = widget.ticket.category;
  bool newCategorySelected = false;
  List<String> categoryOptions = [];

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

  void getUpdates(Map<int, dynamic> orderedMap) {
    for (UpdateBox box in orderedMap.values) {
      Widget child =
          listChild(box.displayTime, box.displayFrom, box.displayMessage);
      updates.add(child);
    }
  }

  Padding listChild(String time, String from, String message) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
          constraints: const BoxConstraints(minWidth: 1920, minHeight: 50),
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
                      time,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      from,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      message,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  void initData() async {
    Map<int, UpdateBox> updateMap = {};

    for (Message message in widget.ticket.messages) {
      UpdateBox box = UpdateBox("message", formatDate(message.time),
          message.personFrom, message.message);
      updateMap.putIfAbsent(message.time, () => box);
    }

    for (TicketUpdate update in widget.ticket.updates) {
      int time = update.time.toInt();
      UpdateBox box = UpdateBox(
          "update", formatDate(time), update.updatedBy, update.newStatus);
      updateMap.putIfAbsent(time, () => box);
    }

    // Convert map entries to a list
    List<MapEntry<int, dynamic>> entries = updateMap.entries.toList();

    // Sort the entries based on the key in ascending order
    entries.sort((a, b) => a.key.compareTo(b.key));

    // Create a new ordered map from the sorted entries
    Map<int, dynamic> orderedMap = Map.fromEntries(entries);
    getUpdates(orderedMap);

    hideButtons = !messagesHidden && widget.ticket.messages.length > 2;

    String uri = "${widget.server}/department/ticket_categories?department="
        "${widget.ticket.ticketTo}";
    var response = await http.get(
        Uri.parse(uri),
      headers: widget.user.getAuth()
    );

    if (response.statusCode != 200) {
      setState(() {

      });
      return;
    }

    var json = jsonDecode(response.body);
    categoryOptions = List.generate(
        json.length,
            (index) => json[index]
    );
    setState(() {

    });

  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  void dispose() {
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  void _focusOnTextField() {
    _textFieldFocusNode.requestFocus();
  }

  Future<void> sendMessage(String newMessage) async {
    Message message = Message(
        time: DateTime.now().millisecondsSinceEpoch ~/
            1000,
        personFrom: widget.user.email,
        message: newMessage);
    var header = widget.user.getAuth();
    header.putIfAbsent(
        "Content-Type", () => "application/json"
    );
    var response = await supporting.postRequest2(
        jsonEncode({}),
        widget.server,
        "/message?message=$newMessage"
            "&ticket_id=${widget.ticket.tId}",
        context,
        headers: header,
        showPrompt: false,
        promptTitle: "Nice",
        promptMessage: "$newMessage Submitted");

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      widget.ticket.messages.add(message);
      controller.clear();
      updates.add(
          listChild(
              "Just Now", widget.user.email, newMessage
          ));
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return supporting.getScaffold(
      ListView(
        controller: scroll,
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 20),
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
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                  ),
                ),
              ),
            ),
          const Padding(
              padding: EdgeInsets.fromLTRB(10, 30, 10, 20),
              child: Center(
                child: Text(
                  "View Ticket",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                ),
              ),
            ),

          getText('Ticket ID: ${widget.ticket.tId}'),

          !showChangeStatus
         ? Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              "Status: ${widget.ticket.status}",
              style: TextStyle(
                  color: widget.ticket.status == "COMPLETED" ||
                      widget.ticket.status == "REJECTED"
                      ? Colors.red
                      : Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18),
            ),
          )
         : Padding(
           padding: const EdgeInsets.all(10),
           child: Row(
             children: [
               SizedBox(
                 width: 300,
                 child: DropdownButton<String>(
                   focusColor: Colors.transparent,
                   dropdownColor: Colors.red[800],
                   hint: newStatusSelected
                       ? Text(
                           'Mark Ticket as:  ${widget.ticket.status}',
                           style: const TextStyle(
                               fontSize: 18,
                               fontWeight: FontWeight.w500,
                               color: Colors.white),
                         )
                       : Text(
                           'Ticket Status: ${widget.ticket.status}',
                           style: const TextStyle(
                               fontSize: 18,
                               fontWeight: FontWeight.w500,
                               color: Colors.white),
                         ),
                   elevation: 16,
                   onChanged: (String? newValue) {
                     if (newValue != null) {
                       selectedNewStatus = newValue;
                       newStatusSelected = true;
                     }
                     setState(() {});
                   },
                   items: [
                     "Ongoing".toUpperCase(),
                     "On_hold".toUpperCase(),
                     "Completed".toUpperCase(),
                     "Rejected".toUpperCase(),
                   ].map<DropdownMenuItem<String>>((String value) {
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
               newStatusSelected
               ? Padding(
                 padding: const EdgeInsets.all(10),
                 child: ElevatedButton(
                   onPressed: () async {
                     var header = widget.user.getAuth();
                     header.putIfAbsent(
                         "Content-Type", () => "application/json");
                     var response =
                       await supporting.patchRequest(
                         jsonEncode({}),
                         widget.server,
                         "/status?new_status=$selectedNewStatus"
                           "&ticket_id=${widget.ticket.tId}",
                         context,
                         header,
                         showPrompt: true,
                         promptTitle: "Status Changed!",
                         promptMessage:
                           "Status Changed to: $selectedNewStatus"
                       );

                     if (response.statusCode == 200 ||
                         response.statusCode == 201) {
                       TicketUpdate update = TicketUpdate(
                         newStatus: selectedNewStatus,
                         time: (DateTime.now()
                                     .millisecondsSinceEpoch ~/
                                 1000)
                             .toDouble(),
                         updatedBy: widget.user.email);
                       widget.ticket.updates.add(update);

                       widget.ticket.status =
                           selectedNewStatus;
                       updates.add(listChild(
                           "Just Now",
                           widget.user.email,
                           "Changed Status to : $selectedNewStatus"));

                       canAddMessages = (
                           widget.ticket.status != "COMPLETED" &&
                           widget.ticket.status != "REJECTED"
                       );
                       showChangeStatus = (widget.ticket.ticketTo == widget.user.department.name)
                           && canAddMessages;

                       setState(() {});
                       }
                     },
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

          !showChangeStatus
              ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Category: ${widget.ticket.category}",
                    style: TextStyle(
                      color: widget.ticket.status == "COMPLETED" ||
                        widget.ticket.status == "REJECTED"
                        ? Colors.red
                        : Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                      children: [
                        SizedBox(
                          width: 600,
                          child: DropdownButton<String>(
                            focusColor: Colors.transparent,
                            dropdownColor: Colors.red[800],
                            hint: newCategorySelected
                                ? Text(
                              'Set Category as:  $newCategory',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            )
                                : Text(
                              'Ticket Category: $newCategory',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                            elevation: 16,
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                newCategory = newValue;
                                newCategorySelected = true;
                              }
                              setState(() {});
                            },
                            items: categoryOptions.map<DropdownMenuItem<String>>((String value) {
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
                        newCategorySelected
                            ? Padding(
                              padding: const EdgeInsets.all(10),
                              child: ElevatedButton(
                                onPressed: () async {
                                  var header = widget.user.getAuth();
                                  header.putIfAbsent(
                                      "Content-Type", () => "application/json"
                                  );
                                  int tId = widget.ticket.tId;
                                  var response =
                                    await supporting.patchRequest(
                                        jsonEncode({"t_id": tId, "new_category": newCategory}),
                                      widget.server,
                                      "/ticket/category",
                                      context,
                                      header,
                                      showPrompt: true,
                                      promptTitle: "Category Changed!",
                                      promptMessage:
                                      "Category Changed to: $newCategory"
                                    );

                                  await sendMessage("Category Changed to: $newCategory");

                                  if (response.statusCode == 200 ||
                                      response.statusCode == 201) {
                                    widget.ticket.category = newCategory;
                                    newCategorySelected = false;

                                    setState(() {});
                                  }
                                },
                                child: const Text(
                                  "Set Category",
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

         getText('Submitted On: ${formatDate(widget.ticket.submittedOn)}'),
         getText('Submitted By: ${widget.ticket.submittedBy}'),
         getText('Ticket To: ${widget.ticket.ticketTo}'),
         getText('Name on Ticket: ${widget.ticket.nameTicket}'),
         getText('Email on Ticket: ${widget.ticket.emailTicket}'),
         getText('Contact Number on Ticket: ${widget.ticket.numberTicket}'),
         getText('Department on Ticket: ${widget.ticket.deptTicket}'),
         getText('Location on Ticket: ${widget.ticket.location}'),
         getText('Ticket Subject: ${widget.ticket.subject}'),
         getText('Ticket Initial Message: ${widget.ticket.message}'),
         getText('IP: ${widget.ticket.ip}'),
         getText('Host: ${widget.ticket.host}'),
         getText('Username: ${widget.ticket.username}'),
         getText('Host Issue? ${widget.ticket.hostIssue}'),
         getText('Platform: ${widget.ticket.platform}'),
         hideButtons
         ? Align(
           alignment: Alignment.topLeft,
           child: Padding(
             padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
             child: ElevatedButton(
               onPressed: () {
                 // messagesHidden != messagesHidden;

                 hideButtons = false;

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
         messagesHidden
         ? Container()
         : Column(
             children: updates,
         ),
         hideButtons
         ? Align(
           alignment: Alignment.topLeft,
           child: Padding(
               padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
               child: ElevatedButton(
                 onPressed: () {
                   setState(() {
                     hideButtons = false;

                     messagesHidden = true;
                   });
                 },
                 child: const Text(
                   "Hide Messages",
                   style: TextStyle(
                     fontSize: 18,
                     fontWeight: FontWeight.w500,
                     color: Colors.red),
                 )
               ),
             ),
           )
         : Container(),
         messagesHidden
         ? Center(
         child: Padding(
           padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
           child: ElevatedButton(
             onPressed: () {
               WidgetsBinding.instance.
                  addPostFrameCallback((_) {
                 scroll.animateTo(
                   scroll.position.maxScrollExtent,
                   duration: const Duration(
                     milliseconds: 300
                   ),
                   curve: Curves.easeOut,
                 );
               });

               setState(() {
                 messagesHidden = false;
                 hideButtons = true;
               });
             },
             child: const Text(
               "Show Messages",
               style: TextStyle(
                 fontSize: 18,
                 fontWeight: FontWeight.w500,
                 color: Colors.red),
             )),
           ),
         )
         : Container(),
         addingMessage
         ? Padding(
             padding: const EdgeInsets.all(10),
             child: TextField(
               focusNode: _textFieldFocusNode,
               controller: controller,
               cursorColor: Colors.red,
               minLines: 1,
               maxLines: 10,
               onChanged: (value) => newMessage = value,
               style: const TextStyle(fontSize: 18, color: Colors.white),
               decoration: const InputDecoration(
                 border: OutlineInputBorder(),
                 focusedBorder: OutlineInputBorder(
                   borderSide: BorderSide(
                       color: Colors.red), // Change the color here
                 ),
                 enabledBorder: OutlineInputBorder(
                   borderSide: BorderSide(
                       color: Colors.red), // Change the color here
                 ),
                 errorBorder: OutlineInputBorder(
                   borderSide: BorderSide(
                       color: Colors.red), // Change the color here
                 ),
                 labelText: "Add a Message",
                 labelStyle:
                   TextStyle(
                     fontSize: 18,
                     color: Colors.white
                   ),
               ),
             ),
           )
         : !canAddMessages
             ? Container()
             : Center(
                 child: Padding(
                   padding: const EdgeInsets.all(10),
                   child: ElevatedButton(
                   onPressed: () {
                     _focusOnTextField();

                     setState(() {
                       addingMessage = true;
                     });
                     WidgetsBinding.instance
                         .addPostFrameCallback((_) {
                       scroll.animateTo(
                         scroll.position.maxScrollExtent,
                         duration: const Duration(
                             milliseconds: 300
                         ),
                         curve: Curves.easeOut,
                       );
                     });
                   },
                   child: const Text(
                     "Add a Message",
                     style: TextStyle(
                       fontSize: 18,
                       fontWeight: FontWeight.w500,
                       color: Colors.red),
                   )),
                 ),
               ),
            addingMessage
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () async {
                        String newMessage = controller.text;

                        if( newMessage.trim().isEmpty) {
                          supporting.showPopUp(
                              context,
                              "Validation Error!",
                              "Message Can Not Be Empty!"
                          );
                          return;
                        }
                        await sendMessage(newMessage);

                        setState(() {
                          addingMessage = false;
                        });

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          scroll.animateTo(
                            scroll.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        });
                        setState(() {});
                        },
                      child: const Text(
                        "Submit Message",
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
      ),
      widget.user,
      widget.server,
    );
  }
}
