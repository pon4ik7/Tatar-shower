import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tatar_shower/l10n/app_localizations.dart';
import 'package:tatar_shower/onboarding/onboarding_data.dart';
import 'package:tatar_shower/theme/colors.dart';
import 'package:tatar_shower/theme/fonts.dart';
import 'package:tatar_shower/theme/images.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpSCreen();
}

class _SignUpSCreen extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<OnboardingData>().setLogin(_usernameController.text);
      context.read<OnboardingData>().setPassword(
        _confirmPasswordController.text,
      );
      Navigator.of(context).pushNamed('/pref1');
    }
  }

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
        child: _SignUpScreenBody(
          loc: loc,
          formKey: _formKey,
          onSubmit: _onSubmit,
          usernameController: _usernameController,
          passwordController: _passwordController,
          confirmPasswordController: _confirmPasswordController,
        ),
      ),
    );
  }
}

class _SignUpScreenBody extends StatelessWidget {
  final AppLocalizations loc;
  final GlobalKey<FormState> formKey;
  final VoidCallback onSubmit;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  const _SignUpScreenBody({
    required this.loc,
    required this.formKey,
    required this.onSubmit,
    required this.usernameController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: SizedBox(
            height: 550,
            width: 300,
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  _SignUpText(loc: loc),
                  SizedBox(height: 50),
                  _UsernameTextField(loc: loc, controller: usernameController),
                  SizedBox(height: 15),
                  _PasswordTextField(loc: loc, controller: passwordController),
                  SizedBox(height: 15),
                  _ConfirmPasswordTextField(
                    loc: loc,
                    controller: confirmPasswordController,
                    matchController: passwordController,
                  ),
                  SizedBox(height: 40),
                  _SignUpTextButton(loc: loc, onPressed: onSubmit),
                  SizedBox(height: 10),
                  _HaveAccountTextButton(loc: loc),
                ],
              ),
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

class _UsernameTextField extends StatelessWidget {
  final TextEditingController controller;
  const _UsernameTextField({required this.loc, required this.controller});

  final AppLocalizations loc;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: TextFormField(
        maxLength: 30,
        controller: controller,
        textAlignVertical: TextAlignVertical.center,
        maxLines: 1,
        textAlign: TextAlign.center,
        style: TextStyle(color: appColors.midBlue),
        decoration: InputDecoration(
          helperText: ' ',
          errorMaxLines: 1,
          isDense: true,
          hintText: loc.username,
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
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          border: OutlineInputBorder(borderSide: BorderSide(width: 2)),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
        ),
        validator: (v) {
          if (v == null || v.length < 5) {
            return loc.error_username_short;
          }
          return null;
        },
      ),
    );
  }
}

class _PasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  const _PasswordTextField({required this.loc, required this.controller});

  final AppLocalizations loc;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: TextFormField(
        maxLength: 30,
        controller: controller,
        obscureText: true,
        obscuringCharacter: '•',
        textAlignVertical: TextAlignVertical.center,
        maxLines: 1,
        textAlign: TextAlign.center,
        style: TextStyle(color: appColors.midBlue),
        decoration: InputDecoration(
          helperText: ' ',
          errorMaxLines: 1,
          isDense: true,
          hintText: loc.password,
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
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          border: OutlineInputBorder(borderSide: BorderSide(width: 2)),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
        ),
        validator: (v) {
          if (v == null || v.length < 5 || v.length > 30) {
            return loc.error_password_short;
          }
          return null;
        },
      ),
    );
  }
}

class _ConfirmPasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController matchController;
  const _ConfirmPasswordTextField({
    required this.loc,
    required this.controller,
    required this.matchController,
  });

  final AppLocalizations loc;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: TextFormField(
        maxLength: 30,
        controller: controller,
        obscureText: true,
        obscuringCharacter: '•',
        textAlignVertical: TextAlignVertical.center,
        maxLines: 1,
        textAlign: TextAlign.center,
        style: TextStyle(color: appColors.midBlue),
        decoration: InputDecoration(
          helperText: ' ',
          errorMaxLines: 1,
          isDense: true,
          hintText: loc.confirm_password,
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
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          border: OutlineInputBorder(borderSide: BorderSide(width: 2)),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
        ),
        validator: (v) {
          if (v != matchController.text) {
            return loc.error_passwords_must_match;
          }
          return null;
        },
      ),
    );
  }
}

class _SignUpTextButton extends StatelessWidget {
  final AppLocalizations loc;
  final VoidCallback onPressed;
  const _SignUpTextButton({required this.loc, required this.onPressed});

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
        onPressed: onPressed,
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
