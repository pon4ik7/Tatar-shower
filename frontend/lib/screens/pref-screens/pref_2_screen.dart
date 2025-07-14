import 'package:flutter/material.dart';
import 'package:tatar_shower/theme/colors.dart';
import 'package:tatar_shower/theme/fonts.dart';
import 'package:tatar_shower/theme/images.dart';
import 'package:tatar_shower/l10n/app_localizations.dart';
import 'package:tatar_shower/screens/pref-screens/step_progress_bar_widget.dart';
import 'package:provider/provider.dart';
import 'package:tatar_shower/onboarding/onboarding_data.dart';

class PreferencesScreen2 extends StatefulWidget {
  const PreferencesScreen2({super.key});

  @override
  _PreferencesScreen2State createState() => _PreferencesScreen2State();
}

class _PreferencesScreen2State extends State<PreferencesScreen2> {
  int? selectedIndex;
  final List<bool> _daysSelected = List<bool>.filled(7, false);
  String? customDaysText;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final options = [
      loc.every_day,
      loc.only_weekdays,
      customDaysText ?? loc.other,
    ];
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
                  StepProgressBar(steps: 5, currentStep: 1),
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    child: Text(
                      loc.how_often_take_shower,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: appFonts.header,
                        fontSize: 24,
                        color: appColors.midBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Image(image: lightClock, width: 80, height: 80),
                  const SizedBox(height: 30),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      itemCount: options.length,
                      itemBuilder: (_, i) {
                        final isSel = selectedIndex == i;
                        return InkWell(
                          onTap: () {
                            if (i == 2) {
                              _showDaysPicker(context, loc);
                            } else {
                              setState(() {
                                selectedIndex = i;
                                customDaysText = null;
                              });
                            }
                            const codes = [
                              'everyday',
                              'only_weekdays',
                              'custom',
                            ];
                            context.read<OnboardingData>().setFrequencyType(
                              codes[i],
                            );
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
                    _NextButton(loc: loc, selectedIndex: selectedIndex),
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

  void _showDaysPicker(BuildContext context, AppLocalizations loc) {
    final weekDays = [
      loc.monday,
      loc.tuesday,
      loc.wednesday,
      loc.thursday,
      loc.friday,
      loc.saturday,
      loc.sunday,
    ];

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: StatefulBuilder(
          builder: (context, setStateDialog) {
            return Container(
              width: 311,
              height: 350,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: weekDays.length,
                      itemBuilder: (_, idx) {
                        return CheckboxListTile(
                          title: Text(
                            weekDays[idx],
                            style: TextStyle(
                              fontFamily: appFonts.regular,
                              fontSize: 16,
                              color: appColors.black,
                            ),
                          ),
                          value: _daysSelected[idx],
                          onChanged: (val) {
                            setStateDialog(() {
                              _daysSelected[idx] = val!;
                            });
                          },
                        );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            loc.cancel,
                            style: TextStyle(
                              fontFamily: appFonts.header,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appColors.midBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            final selectedDays = <String>[];
                            for (int i = 0; i < _daysSelected.length; i++) {
                              if (_daysSelected[i])
                                selectedDays.add(weekDays[i]);
                            }
                            if (selectedDays.isEmpty) {
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
                            } else {
                              setState(() {
                                selectedIndex = 2;
                                customDaysText = selectedDays.join(', ');
                              });
                              context.read<OnboardingData>().setCustomDays(
                                selectedDays,
                              );
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text(
                            loc.save,
                            style: TextStyle(
                              fontFamily: appFonts.header,
                              fontSize: 20,
                              color: appColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
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

class _NextButton extends StatelessWidget {
  const _NextButton({required this.loc, required this.selectedIndex});

  final AppLocalizations loc;
  final int? selectedIndex;

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
            if (selectedIndex != null) {
              Navigator.of(context).pushNamed('/pref3');
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
