import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tatar_shower/models/shower_model.dart';
import 'package:tatar_shower/screens/main-screens/timer-screens/log_shower_screen.dart';
import 'package:tatar_shower/theme/colors.dart';
import 'package:tatar_shower/theme/fonts.dart';
import 'package:tatar_shower/theme/images.dart';

class TimerScreen extends StatefulWidget {
  final Duration warmDuration;
  final Duration coldDuration;
  final int periods;

  const TimerScreen({
    super.key,
    required this.warmDuration,
    required this.coldDuration,
    required this.periods,
  });

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen>
    with TickerProviderStateMixin {
  late DateTime _startTime;
  int _elapsedSeconds = 0;
  int _elapsedColdSeconds = 0;
  late Duration _currentDuration;
  late int _remainingPeriods;
  late bool _isColdPhase;
  Timer? _timer;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _remainingPeriods = widget.periods;
    _isColdPhase = true;
    _startPhase();
  }

  void _startPhase() {
    setState(() {
      _currentDuration = _isColdPhase
          ? widget.coldDuration
          : widget.warmDuration;
    });
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        if (_currentDuration.inSeconds > 0) {
          setState(() {
            _currentDuration -= const Duration(seconds: 1);
            _elapsedSeconds++;
            if (_isColdPhase) _elapsedColdSeconds++;
          });
        } else {
          _timer?.cancel();
          if (!_isColdPhase) {
            _remainingPeriods--;
          }
          if (_remainingPeriods > 0) {
            _isColdPhase = !_isColdPhase;
            _startPhase();
          } else {
            setState(() {
              _currentDuration = Duration.zero;
            });
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds % 60)}";
  }

  @override
  Widget build(BuildContext context) {
    final title = _remainingPeriods == 0
        ? "Time is out"
        : _isColdPhase
        ? "Cold water"
        : "Warm water";

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
              const SizedBox(height: 32),
              Text(
                title,
                style: TextStyle(
                  fontFamily: appFonts.header,
                  fontSize: 24,
                  color: appColors.black,
                ),
              ),
              if (_remainingPeriods > 0) ...[
                const SizedBox(height: 4),
                Text(
                  "Rounds left: $_remainingPeriods",
                  style: TextStyle(
                    fontFamily: appFonts.regular,
                    fontSize: 16,
                    color: appColors.black.withOpacity(0.6),
                  ),
                ),
              ],
              const SizedBox(height: 48),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 220,
                    height: 220,
                    child: CircularProgressIndicator(
                      strokeWidth: 25,
                      value:
                          _currentDuration.inSeconds /
                          (_isColdPhase
                              ? widget.coldDuration.inSeconds
                              : widget.warmDuration.inSeconds),
                      backgroundColor: Color(0xFFE5ECFF),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF7FA1FF),
                      ),
                    ),
                  ),
                  Text(
                    _formatDuration(_currentDuration),
                    style: TextStyle(
                      fontFamily: appFonts.header,
                      fontSize: 36,
                      color: appColors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => setState(() => _isPaused = !_isPaused),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7FA1FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _isPaused ? 'Continue' : 'Pause',
                          style: TextStyle(
                            fontFamily: appFonts.header,
                            fontSize: 20,
                            color: appColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      _timer?.cancel();
                      final totalDuration = Duration(seconds: _elapsedSeconds);
                      final coldDuration = Duration(
                        seconds: _elapsedColdSeconds,
                      );
                      final log = ShowerLog(
                        date: DateTime.now(),
                        totalDuration: totalDuration,
                        coldDuration: coldDuration,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ShowerResultScreen(log: log),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appColors.deepBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Stop shower',
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
}
