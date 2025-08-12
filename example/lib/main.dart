import 'package:flutter/material.dart';
import 'package:app_update_helper/app_update_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userCanUpdate = false;

  void allowUpdateIfMajorOrMinorVersion() async {
    final update = await AppUpdateHelper.checkForUpdate();

    switch (update.type) {
      case UpdateType.major:
      case UpdateType.minor:
        setState(() => userCanUpdate = true);
        break;
      default:
    }
  }

  @override
  void initState() {
    super.initState();
    allowUpdateIfMajorOrMinorVersion();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: userCanUpdate ? ElevatedButton(onPressed: () => AppUpdateHelper.update(), child: const Text('Update App')) : const Text("no update available"),
        ),
      ),
    );
  }
}
