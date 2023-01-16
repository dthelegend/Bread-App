import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsService {
  const SettingsService();

  Future<bool> setHintState(bool hintState);

  Future<bool> getHintState();

  Future<ThemeMode> getTheme();

  Future<ThemeMode> setTheme(ThemeMode newTheme);
}

class SharedPreferencesSettingsService extends SettingsService {
  final prefs = SharedPreferences.getInstance();
  
  @override
  Future<bool> setHintState(bool hintState) async {
    await (await prefs).setBool("settings:hints", hintState);

    return hintState;
  }

  @override
  Future<bool> getHintState() async {

    return (await prefs).getBool("settings:hints") ?? true;
  }

  @override
  Future<ThemeMode> getTheme() async {
    final themeNum = (await prefs).getInt("settings:theme");

    return themeNum != null ? ThemeMode.values[themeNum] : ThemeMode.system;
  }

  @override
  Future<ThemeMode> setTheme(ThemeMode newTheme) async {
    await (await prefs).setInt("settings:theme", newTheme.index);

    return newTheme;
  }
}
