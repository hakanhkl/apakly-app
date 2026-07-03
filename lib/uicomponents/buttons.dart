import 'package:flutter/material.dart';

import '../constants.dart';

class ApaklyOutlinedButton extends StatelessWidget {
  final Function() callback;
  final String btnText;

  const ApaklyOutlinedButton(
      {super.key, required this.callback, required this.btnText});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: callback,
      style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
          animationDuration: const Duration(milliseconds: 1000),
          shape: const StadiumBorder(),
          side: const BorderSide(width: 1.5, color: primaryColor),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8)),
      child: Text(
        btnText,
        style: const TextStyle(color: textColor, fontSize: fSize1),
      ),
    );
  }
}

class ApaklyElevatedButton extends StatelessWidget {
  final Function() callback;
  final String btnText;

  const ApaklyElevatedButton(
      {super.key, required this.callback, required this.btnText});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: callback,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        animationDuration: const Duration(milliseconds: 1000),
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
      child: Text(
        btnText,
        style: const TextStyle(color: textColor, fontSize: fSize1),
      ),
    );
  }
}
