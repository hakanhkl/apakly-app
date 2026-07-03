import 'package:flutter/material.dart';

import '../constants.dart';

class InputField extends StatelessWidget {
  final Function(String) callbackFunction;
  final String hint;
  final TextInputType inputType;
  final Function(String)? callbackValidator;

  const InputField(
      {Key? key,
      required this.callbackFunction,
      required this.hint,
      required this.inputType,
      this.callbackValidator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        cursorColor: textColor,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(
            fontSize: fSize1, color: textColor, fontFamily: 'primFont'),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.black54,
          focusColor: primaryColor,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor, width: 1.0),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 3.0),
          ),
          // Allow up to 5 lines so long validation messages are shown in full.
          errorMaxLines: 5,
          hintText: hint,
          hintStyle: const TextStyle(
              fontSize: fSize1, color: Colors.grey, fontFamily: 'primFont'),
        ),
        onChanged: (value) {
          callbackFunction(value);
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: callbackValidator != null
            ? (value) {
                return callbackValidator!(value!);
              }
            : (value) {
                return null;
              });
  }
}

class _PasswordInputField extends State<PasswordInputField> {
  bool hideInput = true;

  @override
  Widget build(BuildContext context) {
    void switchHideInput() {
      setState(() {
        hideInput = !hideInput;
      });
    }

    return TextFormField(
        cursorColor: textColor,
        obscureText: hideInput,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(
            fontSize: fSize1, color: textColor, fontFamily: 'primFont'
        ),
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
                hideInput ? Icons.visibility_off : Icons.visibility),
            color: iconColor,
            onPressed: switchHideInput,
          ),
          filled: true,
          fillColor: Colors.black54,
          focusColor: primaryColor,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor, width: 1.0),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 2.0),
          ),
          // Allow up to 5 lines so long validation messages are shown in full.
          errorMaxLines: 5,
          hintText: widget.hint,
          hintStyle: const TextStyle(
              fontSize: fSize1, color: Colors.grey, fontFamily: 'primFont'),
        ),
        onChanged: (value) {
          widget.callbackFunction(value);
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: widget.callbackValidator != null
            ? (value) {
                return widget.callbackValidator!(value!);
              }
            : (value) {
                return null;
              });
  }
}

class PasswordInputField extends StatefulWidget {
  final Function(String) callbackFunction;
  final String hint;
  final TextInputType inputType;
  final Function(String)? callbackValidator;

  const PasswordInputField(
      {super.key,
      required this.callbackFunction,
      required this.hint,
      required this.inputType,
      this.callbackValidator});

  @override
  _PasswordInputField createState() => _PasswordInputField();
}
