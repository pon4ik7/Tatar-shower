import 'package:flutter/material.dart';
import 'package:tatar_shower/theme/colors.dart';
import 'package:tatar_shower/theme/fonts.dart';
import 'package:tatar_shower/theme/images.dart';
import 'package:tatar_shower/l10n/app_localizations.dart';

class FullTableScreen extends StatelessWidget {
  const FullTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          loc.recentShowers,
          style: TextStyle(fontFamily: appFonts.header, color: appColors.black),
        ),
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: lightBackground, fit: BoxFit.cover),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Card(
                  color: appColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: _ShowerTable(loc: loc),
                  ),
                ),
              ),
            ),
          ),
        ],
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
        DataColumn(label: Text(loc.date, style: headerStyle)),
        DataColumn(label: Text(loc.duration, style: headerStyle)),
        DataColumn(label: Text(loc.coldDuration, style: headerStyle)),
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

  TextStyle get headerStyle => TextStyle(
    fontFamily: appFonts.header,
    fontSize: 14,
    color: appColors.black,
  );
}
