import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants.dart';

class NoUpcomingSong extends StatelessWidget {
  const NoUpcomingSong({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.noupcomingsongs,
            style: const TextStyle(color: textColor, fontSize: fSize2, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20,),
          Text(
            AppLocalizations.of(context)!.noupcomingsongstext,
            style: const TextStyle(color: textColor, fontSize: fSize0),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
