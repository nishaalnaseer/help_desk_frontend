import 'package:flutter/material.dart';

import 'supporting.dart' as supporting;

class DropDownSelector extends StatefulWidget {
  final String trackText;
  final String buttonText;
  final List<String> options;
  final List<String>? initialValues;
  const DropDownSelector({
    super.key,
    required this.trackText,
    required this.buttonText, 
    required this.options,
    this.initialValues,
  });

  @override
  State<DropDownSelector> createState() => DropDownSelectorState();
}

class DropDownSelectorState extends State<DropDownSelector> {
  late String trackText = widget.trackText;
  bool boolController = false;
  String valueHolder = "";
  late String buttonText = "Add ${widget.buttonText}";
  late List<String> selections = widget.initialValues ?? [];
  late List<String> options = widget.options;

  List<String> get selected => selections;

  List<String> getSelected() {
    return selections;
  }

  // void update(List<String> newSelections) {
  //   setState(() {
  //     options = newSelections;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
      return Column(
        children: [
          Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
            child: Text(
              trackText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18
              ),
            ),
          ),
        ),

          SizedBox(
            width: supporting.getWindowWidth(context),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownButton<String>(
                focusColor: Colors.transparent,
                dropdownColor: Colors.red[800],
                hint: boolController
                ? Text(
                  "Add / Remove $valueHolder",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                  ),
                )
                : Text(
                  'Add a ${widget.buttonText}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                  ),
                ),
                elevation: 16,
                onChanged: (String? newValue) {
                  if (newValue == null) {
                    return;
                  }
                  boolController = true;
                  valueHolder = newValue;

                  if(selections.contains(valueHolder)) {
                    buttonText = "Remove ${widget.buttonText}";
                  } else {
                    buttonText = "Add ${widget.buttonText}";
                  }

                  setState(() {

                  });

                },
                items: options
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
          ),

          Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
          width: 300,
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                if(selections.contains(valueHolder)) {
                  selections.remove(valueHolder);
                  buttonText = "Add ${widget.buttonText}";
                } else {
                  selections.add(valueHolder);
                  buttonText = "Remove ${widget.buttonText}";
                }
                trackText = widget.trackText;

                for(String value in selections) {
                  trackText += " $value,";
                }
                setState(() {

                });
              },
              child: Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 18
                ),
              )
            ),
          ),
          ),
        ],
    );
  }
}
