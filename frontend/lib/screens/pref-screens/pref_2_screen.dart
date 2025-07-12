import 'package:flutter/material.dart';
import 'package:tatar_shower/theme/colors.dart';
import 'package:tatar_shower/theme/fonts.dart';
import 'package:tatar_shower/theme/images.dart';
import 'package:tatar_shower/l10n/app_localizations.dart';
import 'package:tatar_shower/screens/pref-screens/step_progress_bar_widget.dart';

class PreferencesScreen2 extends StatefulWidget {
  const PreferencesScreen2({super.key});
  @override
  _PreferencesScreen2State createState() => _PreferencesScreen2State();
}

class _PreferencesScreen2State extends State<PreferencesScreen2> {
  int? selectedIndex;
  final List<bool> _daysSelected = List<bool>.filled(7, false);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final options = [
      loc.every_day,
      loc.times_per_week,
      loc.only_weekdays,
      loc.other,
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
                            if (i == 3 || i == 1) {
                              _showDaysPicker(context, loc);
                            }
                            setState(() => selectedIndex = i);
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
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appColors.midBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        //TODO Save selected days
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
            Navigator.of(context).pushNamed('/pref3');
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
