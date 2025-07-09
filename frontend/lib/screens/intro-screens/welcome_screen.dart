import 'package:flutter/material.dart';
import 'package:tatar_shower/l10n/app_localizations.dart';
import 'package:tatar_shower/theme/colors.dart';
import 'package:tatar_shower/theme/fonts.dart';
import 'package:tatar_shower/theme/images.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(image: lightBackground, fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 130,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        loc.cold_shower_training,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: appFonts.header,
                          fontSize: 40,
                          color: appColors.midBlue,
                        ),
                      ),
                      SizedBox(height: 80),
                      Image(image: lightLiquid, height: 134),
                      SizedBox(height: 80),
                      Text(
                        loc.build_habit,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: appFonts.regular,
                          fontSize: 20,
                          color: appColors.midBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  minimum: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  child: SizedBox(
                    width: 293,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appColors.deepBlue,
                        foregroundColor: appColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/mode');
                      },
                      child: Text(
                        loc.get_started,
                        style: TextStyle(
                          fontFamily: appFonts.header,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
