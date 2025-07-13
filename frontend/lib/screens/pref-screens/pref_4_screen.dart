import 'package:flutter/material.dart';
import 'package:tatar_shower/theme/colors.dart';
import 'package:tatar_shower/theme/fonts.dart';
import 'package:tatar_shower/theme/images.dart';
import 'package:tatar_shower/l10n/app_localizations.dart';
import 'package:tatar_shower/screens/pref-screens/step_progress_bar_widget.dart';

final Set<String> _selectedOptions = {};

class PreferencesScreen4 extends StatefulWidget {
  const PreferencesScreen4({super.key});
  @override
  _PreferencesScreen4State createState() => _PreferencesScreen4State();
}

class _PreferencesScreen4State extends State<PreferencesScreen4> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final options = [loc.no_practice, loc.tried, loc.practice_regularly];
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: lightBackground, fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  StepProgressBar(steps: 5, currentStep: 3),
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    child: Text(
                      loc.practice_before,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: appFonts.header,
                        fontSize: 24,
                        color: appColors.midBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Image(image: lightRun, width: 80, height: 80),
                  const SizedBox(height: 30),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      itemCount: options.length,
                      itemBuilder: (_, i) {
                        final isSel = selectedIndex == i;
                        return InkWell(
                          onTap: () {
                            setState(() => selectedIndex = i);
                            _selectedOptions.add(options[i]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: appColors.midBlue,
                                      width: 2,
                                    ),
                                  ),
                                  child: isSel
                                      ? Center(
                                          child: Container(
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                              color: appColors.midBlue,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    options[i],
                                    style: TextStyle(
                                      fontFamily: appFonts.regular,
                                      fontSize: 15,
                                      color: appColors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _NextButton(loc: loc),
                    _SkipButton(loc: loc),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton({required this.loc});

  final AppLocalizations loc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
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
            if (_selectedOptions.isNotEmpty) {
              Navigator.of(context).pushNamed('/pref5');
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  padding: EdgeInsets.zero,
                  content: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(120),
                    alignment: Alignment.center,
                    child: Text(
                      loc.choose_option,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: appColors.deepBlue,
                        fontFamily: appFonts.header,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              );
            }
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
    );
  }
}

class _SkipButton extends StatelessWidget {
  const _SkipButton({required this.loc});

  final AppLocalizations loc;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(splashFactory: NoSplash.splashFactory),
      onPressed: () {},
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          loc.skip,
          style: TextStyle(
            fontFamily: appFonts.regular,
            fontSize: 14,
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
