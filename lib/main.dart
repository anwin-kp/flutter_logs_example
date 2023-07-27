import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MaterialApp(
    home: LoggingExampleApp(),
  ));
}

class LoggingExampleApp extends StatefulWidget {
  const LoggingExampleApp({super.key});

  @override
  State<LoggingExampleApp> createState() => _LoggingExampleAppState();
}

class _LoggingExampleAppState extends State<LoggingExampleApp> {
  List<String> logs = [];
  final String customFolderName = "MyLogs"; // Custom folder name

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _loadLogs();
  }

  Future<bool> _requestPermissions() async {
    // Request both read and write permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage, // For read and write access
      // You can add other necessary permissions here if needed
    ].request();

    // Return true if both permissions are granted, otherwise return false
    return statuses[Permission.storage] == PermissionStatus.granted;
  }

  void _loadLogs() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final customDirectory = Directory('${directory.path}/$customFolderName');
      if (kDebugMode) {
        print(customDirectory);
      }
      await customDirectory.create(recursive: true);

      final file = File('${customDirectory.path}/log.txt');
      if (await file.exists()) {
        final contents = await file.readAsString();
        setState(() {
          logs = contents.split('\n').where((line) => line.isNotEmpty).toList();
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading logs: $e');
      }
    }
  }

  void _writeLog(String log) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final customDirectory = Directory('${directory.path}/$customFolderName');
      await customDirectory.create(recursive: true);

      final file = File('${customDirectory.path}/log.txt');
      await file.writeAsString('$log\n', mode: FileMode.append);
      setState(() {
        logs.add(log);
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error writing log: $e');
      }
    }
  }

  void _clearLogs() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final customDirectory = Directory('${directory.path}/$customFolderName');
      final file = File('${customDirectory.path}/log.txt');
      if (await file.exists()) {
        await file.delete();
        setState(() {
          logs.clear();
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing logs: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logging Example'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(logs[index]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                final timestamp = DateTime.now().toString();
                final logMessage = 'Log entry at $timestamp';
                _writeLog(logMessage);
              },
              child: const Text('Log Data'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _clearLogs,
              child: const Text('Clear Logs'),
            ),
          ),
        ],
      ),
    );
  }
}
