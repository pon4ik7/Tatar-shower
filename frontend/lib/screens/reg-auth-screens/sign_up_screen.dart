import 'package:flutter/material.dart';
import 'package:tatar_shower/l10n/app_localizations.dart';
import 'package:tatar_shower/theme/colors.dart';
import 'package:tatar_shower/theme/fonts.dart';
import 'package:tatar_shower/theme/images.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpSCreen();
}

class _SignUpSCreen extends State<SignUpScreen> {
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
        child: _SignUpScreenBody(loc: loc),
      ),
    );
  }
}

class _SignUpScreenBody extends StatelessWidget {
  const _SignUpScreenBody({required this.loc});

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
                _SignUpText(loc: loc),
                SizedBox(height: 50),
                _EmailTextField(loc: loc),
                SizedBox(height: 30),
                _UserNameTextField(loc: loc),
                SizedBox(height: 30),
                _PasswordTextField(loc: loc),
                SizedBox(height: 40),
                _SignUpTextButton(loc: loc),
                SizedBox(height: 10),
                _HaveAccountTextButton(loc: loc),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SignUpText extends StatelessWidget {
  const _SignUpText({required this.loc});

  final AppLocalizations loc;

  @override
  Widget build(BuildContext context) {
    return Text(
      loc.sign_up,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: appFonts.header,
        fontSize: 40,
        color: appColors.midBlue,
      ),
    );
  }
}

class _EmailTextField extends StatelessWidget {
  const _EmailTextField({required this.loc});

  final AppLocalizations loc;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: TextField(
        textAlign: TextAlign.center,
        style: TextStyle(color: appColors.midBlue),
        decoration: InputDecoration(
          hintText: loc.e_mail,
          hintStyle: TextStyle(fontSize: 16, color: appColors.midBlue),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 16,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
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

class _UserNameTextField extends StatelessWidget {
  const _UserNameTextField({required this.loc});

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

class _PasswordTextField extends StatelessWidget {
  const _PasswordTextField({required this.loc});

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

class _SignUpTextButton extends StatelessWidget {
  const _SignUpTextButton({required this.loc});

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
          Navigator.of(context).pushNamed('/pref1');
        },
        child: Text(
          loc.sign_up,
          style: TextStyle(fontFamily: appFonts.header, fontSize: 24),
        ),
      ),
    );
  }
}

class _HaveAccountTextButton extends StatelessWidget {
  const _HaveAccountTextButton({required this.loc});

  final AppLocalizations loc;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(splashFactory: NoSplash.splashFactory),
      onPressed: () {
        Navigator.of(context).pushNamed('/login');
      },
      child: Text(
        loc.have_account,
        style: TextStyle(
          fontFamily: appFonts.regular,
          fontSize: 13,
          color: appColors.midBlue,
        ),
      ),
    );
  }
}
