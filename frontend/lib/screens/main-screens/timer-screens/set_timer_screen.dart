import 'package:flutter/material.dart';
import 'package:tatar_shower/theme/colors.dart';
import 'package:tatar_shower/theme/fonts.dart';
import 'package:tatar_shower/theme/images.dart';
//import 'package:tatar_shower/l10n/app_localizations.dart';

class SetTimerScreen extends StatelessWidget {
  const SetTimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //final loc = AppLocalizations.of(context)!;
    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: lightBackground, fit: BoxFit.cover),
        ),
        child: Center(
          child: Text(
            "Погоди, еще не сделал",
            style: TextStyle(
              fontFamily: appFonts.header,
              fontSize: 30,
              color: appColors.midBlue,
            ),
          ),
        ),
      ),
    );
  }
}
