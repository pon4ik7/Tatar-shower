import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tatar_shower/models/shower_model.dart';
import 'package:tatar_shower/storage/shower_log_storage.dart';
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
                  color: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: FutureBuilder<List<ShowerLog>>(
                      future: ShowerLogStorage.loadLogs(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }
                        final logs = snapshot.data!;
                        return _ShowerTable(loc: loc, logs: logs);
                      },
                    ),
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
  const _ShowerTable({required this.loc, required this.logs});

  final AppLocalizations loc;
  final List<ShowerLog> logs;

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
      rows: logs.map((log) {
        final date = DateFormat(
          'd MMM',
          Localizations.localeOf(context).languageCode,
        ).format(log.date);
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
            DataCell(Text('$totalMin')),
            DataCell(Text('$coldMin')),
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
