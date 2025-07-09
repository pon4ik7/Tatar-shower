import 'package:flutter/material.dart';
import 'package:tatar_shower/theme/colors.dart';
import 'package:tatar_shower/theme/fonts.dart';
import 'package:tatar_shower/theme/images.dart';
import 'package:tatar_shower/l10n/app_localizations.dart';
import 'package:tatar_shower/screens/pref-screens/step_progress_bar_widget.dart';

class PreferencesDoneScreen extends StatefulWidget {
  const PreferencesDoneScreen({super.key});
  @override
  _PreferencesDoneScreenState createState() => _PreferencesDoneScreenState();
}

class _PreferencesDoneScreenState extends State<PreferencesDoneScreen> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: lightBackground, fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Column(
            children: [
              StepProgressBar(steps: 5, currentStep: 4),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: Text(
                  loc.done_prefs,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: appFonts.header,
                    fontSize: 24,
                    color: appColors.midBlue,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Image(image: lightShower, width: 80, height: 80),
              const SizedBox(height: 30),
              Image(image: lightFrozen, width: 80, height: 80),
              const SizedBox(height: 30),
              Image(image: lightLiquid, width: 80, height: 80),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 8,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appColors.deepBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      //Navigator.of(context).pushNamed("/pref5");
                    },
                    child: Text(
                      loc.next,
                      style: TextStyle(
                        fontFamily: appFonts.header,
                        fontSize: 20,
                        color: appColors.white,
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
