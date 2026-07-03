import 'package:apakly/constants.dart';
import 'package:apakly/login/recovery_phrase_screen.dart';
import 'package:apakly/uicomponents/clickable_rich_text.dart';
import 'package:flutter/material.dart';
import '../http/auth.dart';

class Verification extends StatefulWidget {
  final String email;

  const Verification({super.key, required this.email});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  List<TextEditingController> controllers =
      List.generate(6, (index) => TextEditingController());

  Widget buildResendBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Center(
        child: AsyncApaklyClickableRichText(
            callback: () async {
              await resendVerificationEmail(widget.email);
            },
            preText: 'Nichts erhalten? ',
            clickableText: 'Nochmal senden.',
            postText: ''),
      ),
    );
  }

  Widget buildVerifyBtn() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        height: 50.0,
        width: double.infinity,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              String code =
                  controllers.map((controller) => controller.text).join();
              await verify(widget.email, code);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RecoveryPhraseScreen(),
                ),
              );
            },
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Center(
                child: Text(
                  'Verifizieren',
                  style: TextStyle(
                    fontSize: fSize1,
                    color: textColor,
                  ),
                ),
              ),
            )),
      ),
    );
  }

  Widget buildVerificationPins() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          6,
          (index) => SizedBox(
            width: 50.0,
            child: TextField(
              controller: controllers[index],
              textAlign: TextAlign.center,
              cursorColor: Colors.white,
              keyboardType: TextInputType.number,
              maxLength: 1,
              style: const TextStyle(
                color: Colors.white,
                fontSize: fSize4,
              ),
              onChanged: (value) {
                if (value.length == 1) {
                  if (index < 5) {
                    FocusScope.of(context).nextFocus();
                  }
                }
              },
              decoration: const InputDecoration(
                  counterText: '', // Hide the character counter
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor))),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 160,
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Bitte geben den Verifikationscode ein.',
              style: TextStyle(color: textColor, fontSize: fSize2),
            ),
          ),
          buildVerificationPins(),
          buildResendBtn(),
          buildVerifyBtn()
        ],
      ),
    );
  }
}
