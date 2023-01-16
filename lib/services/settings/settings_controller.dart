import 'package:bread/services/settings/settings_service.dart';
import 'package:flutter/material.dart';

class SettingsController extends ChangeNotifier {
  final SettingsService settingsService;

  SettingsController({required this.settingsService});

  late ThemeMode _theme;
  late bool _hintState;

  ThemeMode get theme => _theme;
  bool get hintState => _hintState;

  Future<void> loadSettings() async {
    _theme = await settingsService.getTheme();
    _hintState = await settingsService.getHintState();

    notifyListeners();
  }

  Future<void> setTheme(ThemeMode? newTheme) async {
    if (newTheme == null || newTheme == _theme) return;
    _theme = await settingsService.setTheme(newTheme);

    notifyListeners();
  }

  Future<void> setHintState(bool? newHintState) async {
    if (newHintState == null || newHintState == _hintState) return;
    _hintState = newHintState;

    notifyListeners();
  }
}
