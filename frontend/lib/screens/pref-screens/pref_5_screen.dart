import 'package:flutter/material.dart';
import 'package:tatar_shower/theme/colors.dart';
import 'package:tatar_shower/theme/fonts.dart';
import 'package:tatar_shower/theme/images.dart';
import 'package:tatar_shower/l10n/app_localizations.dart';
import 'package:tatar_shower/screens/pref-screens/step_progress_bar_widget.dart';
import 'package:provider/provider.dart';
import 'package:tatar_shower/onboarding/onboarding_data.dart';

// TODO: handle the "other" option

final Set<String> _selectedOptions = {};

class PreferencesScreen5 extends StatefulWidget {
  const PreferencesScreen5({super.key});
  @override
  _PreferencesScreen5State createState() => _PreferencesScreen5State();
}

class _PreferencesScreen5State extends State<PreferencesScreen5> {
  int? selectedIndex;
  final _formKey = GlobalKey<FormState>();
  final _otherController = TextEditingController();

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  void _onNext(AppLocalizations loc) {
    if (selectedIndex == 3) {
      if (_formKey.currentState?.validate() ?? false) {
        Navigator.of(context).pushNamed("/prefDone");
      }
    } else {
      if (_selectedOptions.isNotEmpty) {
        Navigator.of(context).pushNamed('/prefDone');
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final options = [loc.week, loc.two_weeks, loc.three_weeks, loc.other];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: lightBackground, fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    StepProgressBar(steps: 5, currentStep: 4),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      child: Text(
                        loc.minimum_streak,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: appFonts.header,
                          fontSize: 24,
                          color: appColors.midBlue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Image(image: lightTarget, width: 80, height: 80),
                    const SizedBox(height: 30),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        itemCount: options.length,
                        itemBuilder: (_, i) {
                          final isSel = selectedIndex == i;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                  _selectedOptions.add(options[i]);
                                  selectedIndex = i;
                                  if (i != 3) _otherController.clear();
                                  }),
                                  const streaks = [7, 14, 21, 7];
                            context.read<OnboardingData>().setTargetStreak(
                              streaks[i],
                            );
                                }
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 13,
                                  ),
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
                              ),
                              if (i == 3 && isSel)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 30,
                                    bottom: 8,
                                  ),
                                  child: SizedBox(
                                    height: 55,
                                    child: TextFormField(
                                      controller: _otherController,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                        hintText: loc.enter_your_streak,
                                        helperText: "",
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 8,
                                            ),
                                        filled: true,
                                        fillColor: appColors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: appColors.midBlue,
                                          ),
                                        ),
                                      ),
                                      validator: (v) {
                                        if (v == null || v.isEmpty) {
                                          return loc.error_enter_number;
                                        }
                                        if (int.tryParse(v) == null) {
                                          return loc.error_enter_number;
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                          onPressed: () => _onNext(loc),
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
                    const SizedBox(height: 4),
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
