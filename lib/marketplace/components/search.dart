import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: TextField(
        style: const TextStyle(
          fontSize: fSize1,
          color: Colors.black87,
        ),
        maxLines: 1,
        cursorColor: primaryColor,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          constraints: const BoxConstraints(
            minHeight: 30,
            maxHeight: 40,
          ),
          focusColor: primaryColor,
          hoverColor: primaryColor,
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            borderSide: BorderSide(
              color: primaryColor,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(
                color: primaryColor,
              ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            borderSide: BorderSide(
              color: primaryColor,
            ),
          ),
          hintText: AppLocalizations.of(context)!.search,
          hintStyle: const TextStyle(
              fontSize: fSize0,
              color: Colors.black87,
            ),
          ),
        ),
    );
  }
}
