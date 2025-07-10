import 'package:flutter/material.dart';
import 'package:tatar_shower/l10n/app_localizations.dart';
import 'package:tatar_shower/theme/colors.dart';
import 'package:tatar_shower/theme/fonts.dart';
import 'package:tatar_shower/theme/images.dart';

String currentLocaleGlobal = "";

class SettingsMode extends StatefulWidget {
  const SettingsMode({super.key});

  @override
  State<SettingsMode> createState() => _SettingsMode();
}

class _SettingsMode extends State<SettingsMode> {
  final _keys = ['light', 'dark'];
  String _selected = 'light';
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    String label(String key) {
      switch (key) {
        case 'light':
          return loc.light;
        case 'dark':
          return loc.dark;
        default:
          return key;
      }
    }

    return Scaffold(
      extendBody: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(image: lightBackground, fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            Center(
              child: Container(
                width: 311,
                height: 195,
                decoration: BoxDecoration(
                  color: appColors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      loc.choose_the_mode,
                      style: TextStyle(
                        fontFamily: appFonts.header,
                        fontSize: 20,
                        color: appColors.midBlue,
                      ),
                    ),
                    Divider(),
                    SizedBox(height: 30),
                    ..._keys.map((key) {
                      final isSel = key == _selected;
                      return InkWell(
                        onTap: () {
                          setState(() => _selected = key);
                        },
                        child: Container(
                          height: 48,
                          color: isSel
                              ? appColors.midBlue.withOpacity(0.2)
                              : Colors.transparent,
                          alignment: Alignment.center,
                          child: Text(
                            label(key),
                            style: TextStyle(
                              fontFamily: appFonts.regular,
                              fontSize: 20,
                              fontWeight: isSel
                                  ? FontWeight.bold
                                  : FontWeight.w400,
                              color: appColors.black,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 70),
              child: Align(
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
                        Navigator.of(context).pushNamed('/tabs');
                      },
                      child: Text(
                        loc.apply,
                        style: TextStyle(
                          fontFamily: appFonts.header,
                          fontSize: 24,
                        ),
                      ),
                    ),
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
