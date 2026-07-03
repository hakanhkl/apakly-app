import 'package:apakly/uicomponents/buttons.dart';
import 'package:flutter/material.dart';

class TwoOptionPopup extends StatelessWidget {
  final Function() positiveFunction;
  final Function() negativeFunction;
  final String popupTitle;
  final String popupContent;
  final String positiveBtnText;
  final String negativeBtnText;

  const TwoOptionPopup(
      {super.key,
      required this.positiveFunction,
      required this.negativeFunction,
      required this.popupTitle,
      required this.popupContent,
      required this.positiveBtnText,
      required this.negativeBtnText});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(popupTitle),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(popupContent),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ApaklyOutlinedButton(
                        callback: negativeFunction, btnText: negativeBtnText),
                    ApaklyOutlinedButton(
                        callback: positiveFunction, btnText: positiveBtnText)
                  ],
                )
              ]),
        )
      ],
    );
  }
}

class SingleOptionPopup extends StatelessWidget {
  final Function() callback;
  final String popupTitle;
  final String popupContent;
  final String btnText;

  const SingleOptionPopup(
      {super.key,
      required this.callback,
      required this.popupTitle,
      required this.popupContent,
      required this.btnText});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(popupTitle),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(popupContent),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ApaklyOutlinedButton(
                        callback: callback, btnText: btnText),
                  ],
                )
              ]),
        )
      ],
    );
  }
}
