import 'package:flutter/material.dart';
import 'package:tatar_shower/screens/main-screens/full_table_screen.dart';
import 'package:tatar_shower/theme/colors.dart';
import 'package:tatar_shower/theme/fonts.dart';
import 'package:tatar_shower/theme/images.dart';
import 'package:tatar_shower/l10n/app_localizations.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: lightBackground, fit: BoxFit.cover),
        ),
        child: _MainScreenBody(loc: loc),
      ),
    );
  }
}

class _MainScreenBody extends StatelessWidget {
  const _MainScreenBody({required this.loc});

  final AppLocalizations loc;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 24),
          _Diagram(loc: loc),
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
                          child: _ShowerTable(loc: loc),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _Statistics(loc: loc),
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
  const _Diagram({required this.loc});

  final AppLocalizations loc;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const _DonutChart(progress: 0.7, size: 220, strokeWidth: 24),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '7',
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
            //Navigator.of(context).pushNamed('/new_shower');
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
  const _ShowerTable({required this.loc});

  final AppLocalizations loc;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      dataTextStyle: TextStyle(
        fontFamily: appFonts.regular,
        fontSize: 14,
        color: appColors.black,
      ),
      columns: [
        DataColumn(
          label: Text(
            loc.date,
            style: TextStyle(
              fontFamily: appFonts.header,
              fontSize: 14,
              color: appColors.black,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            loc.duration,
            style: TextStyle(
              fontFamily: appFonts.header,
              fontSize: 14,
              color: appColors.black,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            loc.coldDuration,
            style: TextStyle(
              fontFamily: appFonts.header,
              fontSize: 14,
              color: appColors.black,
            ),
          ),
        ),
      ],
      rows: [
        DataRow(
          cells: [
            DataCell(Text('Jul 7')),
            DataCell(Text('9 min')),
            DataCell(Text('4 min')),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Text('Jul 4')),
            DataCell(Text('7 min')),
            DataCell(Text('2 min')),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Text('Jul 1')),
            DataCell(Text('7 min')),
            DataCell(Text('2 min')),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Text('Jun 28')),
            DataCell(Text('5 min')),
            DataCell(Text('1 min')),
          ],
        ),
      ],
    );
  }
}

class _Statistics extends StatelessWidget {
  const _Statistics({required this.loc});

  final AppLocalizations loc;

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
                      '3 ${loc.showers}',
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
                      '10 ${loc.days}',
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
