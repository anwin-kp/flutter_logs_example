import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

class FileLogger {
  static late File _logFile;
  static late IOSink _logSink;

  static Future<void> init() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String logFilePath = '${directory.path}/app_logs.txt';
    if (kDebugMode) {
      print("Log File Path : $logFilePath");
    }
    _logFile = File(logFilePath);
    _logSink = _logFile.openWrite(mode: FileMode.append);

    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      final String logLine =
          '${record.time} [${record.level.name}] ${record.message}';
      _logSink.writeln(logLine);
      if (kDebugMode) {
        print(logLine);
      } // Print the log to console as well if needed
    });
  }

  static void dispose() {
    _logSink.close();
  }
}
