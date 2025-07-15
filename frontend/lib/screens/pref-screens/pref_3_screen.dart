import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tatar_shower/onboarding/onboarding_data.dart';
import 'package:tatar_shower/theme/colors.dart';
import 'package:tatar_shower/theme/fonts.dart';
import 'package:tatar_shower/theme/images.dart';
import 'package:tatar_shower/l10n/app_localizations.dart';
import 'package:tatar_shower/screens/pref-screens/step_progress_bar_widget.dart';

class PreferencesScreen3 extends StatefulWidget {
  const PreferencesScreen3({super.key});
  @override
  _PreferencesScreen3State createState() => _PreferencesScreen3State();
}

class _PreferencesScreen3State extends State<PreferencesScreen3> {
  int? selectedIndex;
  int _dayIndex = 0;
  TimeOfDay? pickedTime;
  String? customTimeText;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final options = [loc.moring, loc.evening, customTimeText ?? loc.other];

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
                  StepProgressBar(steps: 5, currentStep: 2),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    child: Text(
                      loc.when_remind,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: appFonts.header,
                        fontSize: 24,
                        color: appColors.midBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Image(image: lightCalendar, width: 80, height: 80),
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
                              _showTimePickerDialog(context, loc);
                            } else {
                              setState(() {
                                selectedIndex = i;
                                customTimeText = null;
                              });
                            }
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
                    _NextButton(
                      loc: loc,
                      selectedIndex: selectedIndex,
                      options: options,
                    ),
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

  void _showTimePickerDialog(BuildContext context, AppLocalizations loc) {
    TimeOfDay tempPicked = pickedTime ?? TimeOfDay.now();
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: StatefulBuilder(
          builder: (ctx, setStateDialog) {
            return Container(
              width: 311,
              height: 350,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      initialDateTime: DateTime(
                        0,
                        0,
                        0,
                        tempPicked.hour,
                        tempPicked.minute,
                      ),
                      use24hFormat: false,
                      onDateTimeChanged: (dt) {
                        setStateDialog(() {
                          tempPicked = TimeOfDay(
                            hour: dt.hour,
                            minute: dt.minute,
                          );
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: appColors.midBlue),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            loc.cancel,
                            style: TextStyle(
                              fontFamily: appFonts.header,
                              fontSize: 14,
                              color: appColors.midBlue,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              pickedTime = tempPicked;
                              selectedIndex = 2;
                              customTimeText = pickedTime!.format(context);
                              final data = context.read<OnboardingData>();
                              final day = data.customDays![_dayIndex];
                              final chosenTime = pickedTime!.format(context);
                              data.setTimeForDay(day, chosenTime);
                            });
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appColors.midBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            loc.save,
                            style: TextStyle(
                              fontFamily: appFonts.header,
                              fontSize: 14,
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
  const _NextButton({
    required this.loc,
    required this.selectedIndex,
    required this.options,
  });
  final List<String> options;
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

          // TODO: implement navigation logic (it depends on the current day in the schedule)
          onPressed: () {
            if (selectedIndex != null) {
              List<String> toData = [];
              toData.add(options[selectedIndex!]);
              context.read<OnboardingData>().setCustomDays(toData);
              Navigator.of(context).pushNamed('/pref4');
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
