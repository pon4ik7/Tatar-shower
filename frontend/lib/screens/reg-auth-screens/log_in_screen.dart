import 'package:flutter/material.dart';
import 'package:tatar_shower/l10n/app_localizations.dart';
import 'package:tatar_shower/theme/colors.dart';
import 'package:tatar_shower/theme/fonts.dart';
import 'package:tatar_shower/theme/images.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});
  @override
  State<LogInScreen> createState() => _SignUpSCreen();
}

class _SignUpSCreen extends State<LogInScreen> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(image: lightBackground, fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                height: 550,
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    Text(
                      loc.log_in,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: appFonts.header,
                        fontSize: 40,
                        color: appColors.midBlue,
                      ),
                    ),
                    SizedBox(height: 50),
                    SizedBox(
                      height: 55,
                      child: TextField(
                        textAlign: TextAlign.center,
                        style: TextStyle(color: appColors.midBlue),
                        decoration: InputDecoration(
                          hintText: loc.username,
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: appColors.midBlue,
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 16,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      height: 55,
                      child: TextField(
                        textAlign: TextAlign.center,
                        style: TextStyle(color: appColors.midBlue),
                        decoration: InputDecoration(
                          hintText: loc.password,
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: appColors.midBlue,
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 16,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    SizedBox(
                      width: 216,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appColors.deepBlue,
                          foregroundColor: appColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/pref1');
                        },
                        child: Text(
                          loc.log_in,
                          style: TextStyle(
                            fontFamily: appFonts.header,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      style: ButtonStyle(splashFactory: NoSplash.splashFactory),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/signup');
                      },
                      child: Text(
                        loc.not_have_account,
                        style: TextStyle(
                          fontFamily: appFonts.regular,
                          fontSize: 11,
                          color: appColors.midBlue,
                        ),
                      ),
                    ),
                    TextButton(
                      style: ButtonStyle(splashFactory: NoSplash.splashFactory),
                      onPressed: () {},
                      child: Text(
                        loc.forgot_password,
                        style: TextStyle(
                          fontFamily: appFonts.regular,
                          fontSize: 11,
                          color: appColors.midBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
