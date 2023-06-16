import 'package:flutter/material.dart';
import 'application_models.dart';
import 'supporting.dart' as supporting;

class ViewUsers extends StatefulWidget {
  final User user;
  final String protocol;
  final String domain;
  const ViewUsers({
    super.key, required this.user,
    required this.protocol, required this.domain
  });

  @override
  State<ViewUsers> createState() => _ViewUsersState();
}

class _ViewUsersState extends State<ViewUsers> {
  String selectedDepartment = "";
  bool departmentSelected = false;
  List<String> departments = [];

  @override
  Widget build(BuildContext context) {
    return supporting.getScaffold(
      ListView(
        children: [
          const Center(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                "Users",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 19
                ),
              ),
            ),
          ),

          SizedBox(
            width: supporting.getWindowWidth(context),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownButton<String>(
                hint: departmentSelected
                ? Text(
                  "Selected Department: $selectedDepartment",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500
                  ),
                )
                : const Text(
                  'Select a Department',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500
                  ),
                ),
                elevation: 16,
                focusColor: Colors.transparent,
                dropdownColor: Colors.red[800],
                onChanged: (String? newValue) {
                  if (newValue == null) {
                    return;
                  }

                  selectedDepartment = newValue;
                  departmentSelected = true;

                  setState(() {});
                },
                items: widget.user.ticketsFrom.map<DropdownMenuItem<String>>
                  ((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

        ],
      ),
      widget.user);
  }
}
