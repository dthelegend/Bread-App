import 'package:bread/services/settings/settings_controller.dart';
import 'package:bread/services/settings/settings_service.dart';
import 'package:bread/views/bread_main_view.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SettingsController settingsController =
      SettingsController(settingsService: SharedPreferencesSettingsService());

  await settingsController.loadSettings();

  runApp(BreadApp(
    settingsController: settingsController,
  ));
}

class BreadApp extends StatelessWidget {
  const BreadApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: settingsController,
        builder: (context, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorSchemeSeed: Colors.brown,
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorSchemeSeed: Colors.brown,
              brightness: Brightness.dark,
              useMaterial3: true,
            ),
            themeMode: settingsController.theme,
            home: BreadMainView(
              settingsController: settingsController,
            ),
          );
        });
  }
}
