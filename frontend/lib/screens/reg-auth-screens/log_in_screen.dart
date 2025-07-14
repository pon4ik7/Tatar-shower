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
        child: _LogInScreenBody(loc: loc),
      ),
    );
  }
}

class _LogInScreenBody extends StatelessWidget {
  const _LogInScreenBody({required this.loc});

  final AppLocalizations loc;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: SizedBox(
            height: 550,
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                _LogInText(loc: loc),
                SizedBox(height: 50),
                _UserNameField(loc: loc),
                SizedBox(height: 30),
                _PasswordsField(loc: loc),
                SizedBox(height: 40),
                _LogInButton(loc: loc),
                SizedBox(height: 10),
                _NoAccountTextButton(loc: loc),
                _ForgotPasswordTextButton(loc: loc),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ForgotPasswordTextButton extends StatelessWidget {
  const _ForgotPasswordTextButton({required this.loc});

  final AppLocalizations loc;

  @override
  Widget build(BuildContext context) {
    return TextButton(
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
    );
  }
}

class _NoAccountTextButton extends StatelessWidget {
  const _NoAccountTextButton({required this.loc});

  final AppLocalizations loc;

  @override
  Widget build(BuildContext context) {
    return TextButton(
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
    );
  }
}

class _LogInButton extends StatelessWidget {
  const _LogInButton({required this.loc});

  final AppLocalizations loc;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
          Navigator.of(context).pushNamed('/tabs');
        },
        child: Text(
          loc.log_in,
          style: TextStyle(fontFamily: appFonts.header, fontSize: 24),
        ),
      ),
    );
  }
}

class _PasswordsField extends StatelessWidget {
  const _PasswordsField({required this.loc});

  final AppLocalizations loc;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: TextField(
        textAlign: TextAlign.center,
        style: TextStyle(color: appColors.midBlue),
        decoration: InputDecoration(
          hintText: loc.password,
          hintStyle: TextStyle(fontSize: 16, color: appColors.midBlue),
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
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
        ),
      ),
    );
  }
}

class _UserNameField extends StatelessWidget {
  const _UserNameField({required this.loc});

  final AppLocalizations loc;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: TextField(
        textAlign: TextAlign.center,
        style: TextStyle(color: appColors.midBlue),
        decoration: InputDecoration(
          hintText: loc.username,
          hintStyle: TextStyle(fontSize: 16, color: appColors.midBlue),
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
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
        ),
      ),
    );
  }
}

class _LogInText extends StatelessWidget {
  const _LogInText({required this.loc});

  final AppLocalizations loc;

  @override
  Widget build(BuildContext context) {
    return Text(
      loc.log_in,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: appFonts.header,
        fontSize: 40,
        color: appColors.midBlue,
      ),
    );
  }
}
