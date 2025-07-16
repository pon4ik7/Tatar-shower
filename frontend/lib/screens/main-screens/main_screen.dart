import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tatar_shower/models/shower_model.dart';
import 'package:tatar_shower/screens/main-screens/full_table_screen.dart';
import 'package:tatar_shower/screens/main-screens/tabs.dart';
import 'package:tatar_shower/services/api_service.dart';
import 'package:tatar_shower/storage/prefer_streak_storage.dart';
import 'package:tatar_shower/storage/shower_log_storage.dart';
import 'package:tatar_shower/theme/colors.dart';
import 'package:tatar_shower/theme/fonts.dart';
import 'package:tatar_shower/theme/images.dart';
import 'package:tatar_shower/l10n/app_localizations.dart';

var _showersThisWeek = 0;
var currentStreak = 0;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int? currentStreak;

  @override
  void initState() {
    super.initState();
    _loadStreak();
  }

  Future<void> _loadStreak() async {
    try {
      final streak = await ApiService().getStreak();
      setState(() {
        currentStreak = streak.currentStreak;
      });
    } catch (e) {
      debugPrint("API error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    if (currentStreak == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: lightBackground, fit: BoxFit.cover),
        ),
        child: _MainScreenBody(loc: loc, streak: currentStreak),
      ),
    );
  }
}

class _MainScreenBody extends StatelessWidget {
  const _MainScreenBody({required this.loc, required this.streak});

  final AppLocalizations loc;
  final int? streak;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 24),
          _Diagram(loc: loc, streak: streak),
          const SizedBox(height: 40),
          _NewShowerButtom(loc: loc),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const FullTableScreen()),
                );
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 24, bottom: 16),
                child: Column(
                  children: [
                    _TableHeader(loc: loc),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Card(
                          color: appColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: FutureBuilder<List<ShowerLog>>(
                            future: ShowerLogStorage.loadLogs(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return CircularProgressIndicator();
                              }
                              final logs = snapshot.data!;
                              _showersThisWeek = logs.length;
                              return _ShowerTable(loc: loc, logs: logs);
                            },
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _Statistics(
                        loc: loc,
                        showersThisWeek: _showersThisWeek,
                        currentStreak: currentStreak,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Diagram extends StatelessWidget {
  const _Diagram({required this.loc, required this.streak});

  final AppLocalizations loc;
  final int? streak;
  Future<int?> getUserPreferStreak() async {
    return await UserStreakPreference.loadStreak();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int?>(
      future: getUserPreferStreak(),
      builder: (context, snapshot) {
        return SizedBox(
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _DonutChart(
                progress: ((currentStreak) / (snapshot.data ?? 1).toDouble()),
                size: 220,
                strokeWidth: 24,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "$currentStreak",
                    style: TextStyle(
                      fontFamily: appFonts.header,
                      fontSize: 40,
                      color: appColors.black,
                    ),
                  ),
                  Text(
                    loc.days.toUpperCase(),
                    style: TextStyle(
                      fontFamily: appFonts.header,
                      fontSize: 40,
                      color: appColors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NewShowerButtom extends StatelessWidget {
  const _NewShowerButtom({required this.loc});

  final AppLocalizations loc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
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
            tabIndexNotifier.value = 1;
          },
          child: Text(
            loc.newShower,
            style: TextStyle(
              fontFamily: appFonts.header,
              fontSize: 20,
              color: appColors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader({required this.loc});

  final AppLocalizations loc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          loc.recentShowers,
          style: TextStyle(
            fontFamily: appFonts.regular,
            fontSize: 16,
            color: appColors.deepBlue,
          ),
        ),
      ),
    );
  }
}

class _ShowerTable extends StatelessWidget {
  const _ShowerTable({required this.loc, required this.logs});

  final AppLocalizations loc;
  final List<ShowerLog> logs;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    final filledLogs = List<ShowerLog>.from(
      logs.length >= 4 ? logs.sublist(logs.length - 4) : logs,
    );

    final missingCount = 4 - filledLogs.length;

    final paddedLogs = [
      ...filledLogs,
      ...List.generate(missingCount, (_) => null),
    ];

    return DataTable(
      dataTextStyle: TextStyle(
        fontFamily: appFonts.regular,
        fontSize: 14,
        color: appColors.black,
      ),
      columns: [
        DataColumn(label: Text(loc.date, style: headerStyle)),
        DataColumn(label: Text(loc.duration, style: headerStyle)),
        DataColumn(label: Text(loc.coldDuration, style: headerStyle)),
      ],
      rows: paddedLogs.map((log) {
        if (log == null) {
          return DataRow(
            cells: [DataCell(Text('')), DataCell(Text('')), DataCell(Text(''))],
          );
        }

        final date = DateFormat('d MMM', locale).format(log.date);
        final dynamic totalMin;
        final dynamic coldMin;
        if (log.totalDuration.inSeconds.toString().length == 2) {
          totalMin =
              '${log.totalDuration.inMinutes}:${log.totalDuration.inSeconds}';
        } else {
          totalMin =
              '${log.totalDuration.inMinutes}:0${log.totalDuration.inSeconds}';
        }
        if (log.coldDuration.inSeconds.toString().length == 2) {
          coldMin =
              '${log.coldDuration.inMinutes}:${log.coldDuration.inSeconds}';
        } else {
          coldMin =
              '${log.coldDuration.inMinutes}:0${log.coldDuration.inSeconds}';
        }
        return DataRow(
          cells: [
            DataCell(Text(date)),
            DataCell(Text(totalMin)),
            DataCell(Text(coldMin)),
          ],
        );
      }).toList(),
    );
  }

  TextStyle get headerStyle => TextStyle(
    fontFamily: appFonts.header,
    fontSize: 14,
    color: appColors.black,
  );
}

class _Statistics extends StatelessWidget {
  const _Statistics({
    required this.loc,
    required this.showersThisWeek,
    required this.currentStreak,
  });

  final AppLocalizations loc;
  final int showersThisWeek;
  final int currentStreak;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: Card(
              color: appColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(
                      loc.thisWeek,
                      style: TextStyle(
                        fontFamily: appFonts.header,
                        fontSize: 14,
                        color: appColors.black,
                      ),
                    ),
                    Text(
                      '$showersThisWeek ${loc.showers}',
                      style: TextStyle(
                        fontFamily: appFonts.regular,
                        fontSize: 14,
                        color: appColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Card(
              color: appColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(
                      loc.longestStreak,
                      style: TextStyle(
                        fontFamily: appFonts.header,
                        fontSize: 14,
                        color: appColors.black,
                      ),
                    ),
                    Text(
                      '$currentStreak ${loc.days}',
                      style: TextStyle(
                        fontFamily: appFonts.regular,
                        fontSize: 14,
                        color: appColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DonutChart extends StatelessWidget {
  final double progress;
  final double size;
  final double strokeWidth;
  const _DonutChart({
    required this.progress,
    required this.size,
    required this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _DonutPainter(progress, strokeWidth, appColors.midBlue),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final double progress, stroke;
  final Color color;
  _DonutPainter(this.progress, this.stroke, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.width - stroke) / 2;
    final bgPaint = Paint()
      ..color = Color(0xFFD5E1FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    final fgPaint = Paint()
      ..color = Color(0xFF7FA1FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);
    final angle = 2 * 3.14159 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2,
      //-3.14159 / 2 + (3.14159 / 2),
      angle,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
