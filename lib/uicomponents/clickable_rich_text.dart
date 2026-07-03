import 'package:apakly/constants.dart';
import 'package:flutter/material.dart';

class AsyncApaklyClickableRichText extends StatelessWidget {
  final Future Function() callback;
  final String preText;
  final String clickableText;
  final String postText;

  const AsyncApaklyClickableRichText(
      {super.key,
      required this.callback,
      required this.preText,
      required this.clickableText,
      required this.postText});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: RichText(
        text: TextSpan(
            text: preText,
            style: const TextStyle(color: textColor, fontSize: 16.0),
            children: <TextSpan>[
              TextSpan(
                  text: clickableText,
                  style: const TextStyle(
                      color: textColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline)),
              TextSpan(
                  text: postText,
                  style: const TextStyle(color: textColor, fontSize: 16.0))
            ]),
      ),
    );
  }
}

class ApaklyClickableRichText extends StatelessWidget {
  final Function() callback;
  final String preText;
  final String clickableText;
  final String postText;
  final double height;

  const ApaklyClickableRichText(
      {super.key,
      required this.callback,
      required this.preText,
      required this.clickableText,
      required this.postText,
      required this.height });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: callback,
        onLongPress: callback,
        child: Container(
          height: height,
          child: RichText(
            text: TextSpan(
                text: preText,
                style: const TextStyle(color: textColor, fontSize: fSize0),
                children: <TextSpan>[
                  TextSpan(
                      text: clickableText,
                      style: const TextStyle(
                          color: textColor,
                          fontSize: fSize0,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline)),
                  TextSpan(
                      text: postText,
                      style:
                          const TextStyle(color: textColor, fontSize: fSize0))
                ]),
          ),
        ));
  }
}
