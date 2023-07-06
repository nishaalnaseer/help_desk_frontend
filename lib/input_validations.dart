import 'package:flutter/material.dart';
import 'supporting.dart' as supporting;

class MandatoryInputError implements Exception {
  /*
  this is generally thrown if a mandatory input field is empty
   */
  final String message;

  MandatoryInputError(this.message);

  @override
  String toString() {
    return 'MandatoryInputError: $message';
  }
}

class InputField {
  String _holder = "";
  final String _display;

  final int maximumLines;
  final int minimumLines;
  final bool mandatory;
  final TextEditingController controller = TextEditingController();
  final bool obscureText; // for password fields

  late final TextField inputField = initialise();

  InputField({
    this.mandatory = true,
    this.maximumLines = 1,
    this.minimumLines = 1,
    this.obscureText = false,
    required String display,
  }) : _display = display;

  TextField initialise() {
    return TextField(
      controller: controller,
      cursorColor: Colors.red,
      minLines: minimumLines,
      maxLines: maximumLines,
      obscureText: obscureText,
      onChanged: (value) => _holder = value,
      style: const TextStyle(fontSize: 18, color: Colors.white),
      decoration: InputDecoration(
        // label: const Text("Text *"),
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
        labelText: mandatory ? "$_display*" : _display,
        labelStyle: const TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  String text() {
    String value = controller.text;
    if (value.trim().isEmpty) {
      throw MandatoryInputError("$_display Cant be Empty!");
    }

    return value;
  }

  void setText(String value) {
    controller.text = value;
  }

  void clear() {
    controller.text = "";
  }
}

bool inputValidation(List<InputField> inputs, BuildContext context) {
  String output = "";

  for (var x in inputs) {
    try {
      x.text();
    } on MandatoryInputError catch (e) {
      output += '${e.message}\n';
    }
  }

  if (output == "") {
    return true;
  } else {
    output = output.substring(0, output.length - 1);
    supporting.showPopUp(
        context,
        "Validation Error!",
        output
    );
    return false;
  }

}