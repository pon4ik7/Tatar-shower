import 'package:flutter/material.dart';
import 'package:tatar_shower/l10n/app_localizations.dart';
import 'package:tatar_shower/theme/colors.dart';
import 'package:tatar_shower/theme/fonts.dart';
import 'package:tatar_shower/theme/images.dart';

String currentLocaleGlobal = "";

class SettingsLanguage extends StatefulWidget {
  final void Function(Locale) onLocaleChanged;
  final String currentLocale;
  const SettingsLanguage({
    super.key,
    required this.onLocaleChanged,
    required this.currentLocale,
  });

  @override
  State<SettingsLanguage> createState() => _SettingsLanguage();
}

class _SettingsLanguage extends State<SettingsLanguage> {
  @override
  void initState() {
    super.initState();
    currentLocaleGlobal = widget.currentLocale;
  }

  final Map<String, Locale> _options = {
    'English': const Locale('en'),
    'Русский': const Locale('ru'),
  };
  String _selected = "English";
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
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
                      loc.choose_the_language,
                      style: TextStyle(
                        fontFamily: appFonts.header,
                        fontSize: 20,
                        color: appColors.midBlue,
                      ),
                    ),
                    Divider(),
                    SizedBox(height: 30),
                    ..._options.entries.map((e) {
                      final isSel = e.key == _selected;
                      return InkWell(
                        onTap: () {
                          setState(() => _selected = e.key);
                          widget.onLocaleChanged(e.value);
                        },
                        child: Container(
                          height: 48,
                          color: isSel
                              ? appColors.midBlue.withOpacity(0.2)
                              : Colors.transparent,
                          alignment: Alignment.center,
                          child: Text(
                            e.key,
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
                        Navigator.of(context).pop();
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
