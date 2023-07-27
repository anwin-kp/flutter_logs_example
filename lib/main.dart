import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';

import 'file_logger.dart'; // Replace with the path to your file_logger.dart

final Logger _logger = Logger('MyApp');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FileLogger.init(); // Initialize the file logger
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Permission _permissionGroup = Permission.storage;
  @override
  void initState() {
    super.initState();
    requestPermission(_permissionGroup);
  }

  @override
  Widget build(BuildContext context) {
    _logger.info('MyApp started');
    return MaterialApp(
      title: 'MyApp',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('MyApp'),
        ),
        body: const Center(
          child: Text('Hello, World!'),
        ),
      ),
    );
  }
}

Future<void> requestPermission(Permission permission) => permission.request();
