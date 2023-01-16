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
  @override
  Future<bool> setHintState(bool hintState) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool("settings:hints", hintState);

    return hintState;
  }

  @override
  Future<bool> getHintState() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool("settings:hints") ?? true;
  }

  @override
  Future<ThemeMode> getTheme() async {
    final prefs = await SharedPreferences.getInstance();

    final themeNum = prefs.getInt("settings:theme");

    return themeNum != null ? ThemeMode.values[themeNum] : ThemeMode.system;
  }

  @override
  Future<ThemeMode> setTheme(ThemeMode newTheme) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt("settings:theme", newTheme.index);

    return newTheme;
  }
}
