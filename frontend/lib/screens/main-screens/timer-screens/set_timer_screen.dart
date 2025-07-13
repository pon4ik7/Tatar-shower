import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tatar_shower/theme/colors.dart';
import 'package:tatar_shower/theme/images.dart';
import 'package:tatar_shower/theme/fonts.dart';
import 'package:tatar_shower/screens/main-screens/timer-screens/timer_screen.dart';

class TimeTextInputFormatter extends TextInputFormatter {
  final RegExp _exp = RegExp(r'^[0-9:]*$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (!_exp.hasMatch(newValue.text)) return oldValue;

    String digits = newValue.text.replaceAll(':', '');

    if (digits.length > 4) {
      digits = digits.substring(digits.length - 4);
    }

    String formatted;
    if (digits.length <= 2) {
      formatted = '00:${digits.padLeft(2, '0')}';
    } else {
      final mm = digits.substring(0, digits.length - 2).padLeft(2, '0');
      final ss = digits.substring(digits.length - 2);
      formatted = '$mm:$ss';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class SetTimerScreen extends StatefulWidget {
  const SetTimerScreen({super.key});

  @override
  State<SetTimerScreen> createState() => _SetTimerScreenState();
}

class _SetTimerScreenState extends State<SetTimerScreen> {
  final _formKey = GlobalKey<FormState>();

  final _warmController = TextEditingController();
  final _coldController = TextEditingController();
  final _periodsController = TextEditingController();

  @override
  void dispose() {
    _warmController.dispose();
    _coldController.dispose();
    _periodsController.dispose();
    super.dispose();
  }

  Duration _parseDuration(String input) {
    final parts = input.split(":");
    final minutes = int.tryParse(parts[0]) ?? 0;
    final seconds = int.tryParse(parts[1]) ?? 0;
    return Duration(minutes: minutes, seconds: seconds);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(image: lightBackground, fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  style: ButtonStyle(splashFactory: NoSplash.splashFactory),
                  icon: Icon(Icons.info_outline, color: appColors.midBlue),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        title: Text(
                          'Info',
                          style: TextStyle(
                            fontFamily: appFonts.header,
                            fontSize: 20,
                            color: appColors.deepBlue,
                          ),
                        ),
                        content: Text(
                          'Set the time for warm and cold water, choose how many periods you want, and click Start shower',
                          style: TextStyle(
                            fontFamily: appFonts.regular,
                            fontSize: 16,
                            color: appColors.black,
                          ),
                        ),
                        actions: [
                          TextButton(
                            style: ButtonStyle(
                              splashFactory: NoSplash.splashFactory,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              'OK',
                              style: TextStyle(
                                fontFamily: appFonts.header,
                                color: appColors.midBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7FA1FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            "Set previous settings",
                            style: TextStyle(
                              fontFamily: appFonts.header,
                              fontSize: 20,
                              color: appColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildTimeField(
                              label: "Warm water time",
                              controller: _warmController,
                              hint: 'mm:ss',
                            ),
                            const SizedBox(height: 16),
                            _buildTimeField(
                              label: "Cold water time",
                              controller: _coldController,
                              hint: 'mm:ss',
                            ),
                            const SizedBox(height: 16),
                            _buildNumberField(
                              label: "Number of periods",
                              controller: _periodsController,
                              hint: 'enter the number',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appColors.deepBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final warmDuration = _parseDuration(
                          _warmController.text,
                        );
                        final coldDuration = _parseDuration(
                          _coldController.text,
                        );
                        final periods =
                            int.tryParse(_periodsController.text) ?? 1;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TimerScreen(
                              warmDuration: warmDuration,
                              coldDuration: coldDuration,
                              periods: periods,
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      "Start shower",
                      style: TextStyle(
                        fontFamily: appFonts.header,
                        fontSize: 20,
                        color: appColors.white,
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

  Widget _buildTimeField({
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: appFonts.regular,
            fontSize: 16,
            color: appColors.black,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [TimeTextInputFormatter()],
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white.withOpacity(0.5),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 12,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: (v) {
            if (v == null || !RegExp(r'^[0-9]{2}:[0-5][0-9]$').hasMatch(v)) {
              return 'Invalid format';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildNumberField({
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: appFonts.regular,
            fontSize: 16,
            color: appColors.black,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white.withOpacity(0.5),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 12,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: (v) {
            if (v == null || v.isEmpty || int.tryParse(v) == null) {
              return 'Enter a number';
            }
            return null;
          },
        ),
      ],
    );
  }
}
