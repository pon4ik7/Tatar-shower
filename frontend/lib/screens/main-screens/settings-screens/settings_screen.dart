import 'package:flutter/material.dart';
import 'package:tatar_shower/theme/colors.dart';
import 'package:tatar_shower/theme/fonts.dart';
import 'package:tatar_shower/theme/images.dart';
import 'package:tatar_shower/l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationEnabled = true;
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: lightBackground, fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                height: 63,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                    backgroundColor: appColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed("/settingsLanguage");
                  },
                  child: Text(
                    loc.change_the_language,
                    style: TextStyle(
                      fontFamily: appFonts.header,
                      fontSize: 20,
                      color: appColors.deepBlue,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                height: 63,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                    backgroundColor: appColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed("/settingsMode");
                  },
                  child: Text(
                    loc.change_the_mode,
                    style: TextStyle(
                      fontFamily: appFonts.header,
                      fontSize: 20,
                      color: appColors.deepBlue,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                height: 63,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                    backgroundColor: _notificationEnabled
                        ? appColors.white
                        : Color(0xFFCCCACA),
                    foregroundColor: _notificationEnabled
                        ? appColors.deepBlue
                        : appColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _notificationEnabled = !_notificationEnabled;
                    });
                  },
                  child: Text(
                    _notificationEnabled
                        ? loc.notification_enabled
                        : loc.notification_disabled,
                    style: TextStyle(fontFamily: appFonts.header, fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
