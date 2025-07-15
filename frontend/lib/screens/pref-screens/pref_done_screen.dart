import 'package:flutter/material.dart';
import 'package:tatar_shower/theme/colors.dart';
import 'package:tatar_shower/theme/fonts.dart';
import 'package:tatar_shower/theme/images.dart';
import 'package:tatar_shower/l10n/app_localizations.dart';
import 'package:tatar_shower/screens/pref-screens/step_progress_bar_widget.dart';
import 'package:provider/provider.dart';
import 'package:tatar_shower/onboarding/onboarding_data.dart';
import 'package:tatar_shower/models/register_request.dart';
import 'package:tatar_shower/services/api_service.dart';

class PreferencesDoneScreen extends StatefulWidget {
  const PreferencesDoneScreen({super.key});
  @override
  _PreferencesDoneScreenState createState() => _PreferencesDoneScreenState();
}

class _PreferencesDoneScreenState extends State<PreferencesDoneScreen> {
  int? selectedIndex;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
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
                  Expanded(
                    child: Align(
                      alignment: const Alignment(0, -0.5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image(image: lightShower, width: 80, height: 80),
                          const SizedBox(height: 70),
                          Image(image: lightFrozen, width: 80, height: 80),
                          const SizedBox(height: 70),
                          Image(image: lightLiquid, width: 80, height: 80),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              setState(() => _isLoading = true);
                              final data = context.read<OnboardingData>();
                              final req = RegisterRequest(
                                login: data.login!,
                                password: data.password!,
                                language: data.language,
                                reason: data.reason,
                                frequencyType: data.frequencyType,
                                customDays: data.customDays,
                                experienceType: data.experienceType,
                                targetStreak: data.targetStreak,
                              );

                              try {
                                await ApiService().registerUserWithPrefs(req);
                                Navigator.of(
                                  context,
                                ).pushReplacementNamed('/tabs');
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Ошибка: $e')),
                                );
                              } finally {
                                setState(() => _isLoading = false);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appColors.deepBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : Text(
                              loc.start,
                              style: TextStyle(
                                fontFamily: appFonts.header,
                                fontSize: 20,
                                color: appColors.white,
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

// class _NextButton extends StatelessWidget {
//   const _NextButton({required this.loc});

//   final AppLocalizations loc;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
//       child: SizedBox(
//         width: double.infinity,
//         height: 52,
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: appColors.deepBlue,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//           onPressed: () {
//             Navigator.of(context).pushNamed("/tabs");
//           },
//           child: Text(
//             loc.start,
//             style: TextStyle(
//               fontFamily: appFonts.header,
//               fontSize: 20,
//               color: appColors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
