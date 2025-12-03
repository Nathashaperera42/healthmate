import 'package:flutter/material.dart';
import 'package:healthmate/features/settings/data/models/settings_model.dart';
import 'package:healthmate/data/database/health_database.dart';

class SettingsProvider extends ChangeNotifier {
  AppSettings? _settings;
  final HealthDatabase _database = HealthDatabase();

  AppSettings get settings => _settings ?? AppSettings();

  SettingsProvider() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadSettings();
    });
  }

 
  Future<void> loadSettings() async {
    await _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final settingsMap = await _database.getSettings();
      if (settingsMap.isNotEmpty) {
        _settings = AppSettings.fromMap(settingsMap);
      } else {
        _settings = AppSettings();
        await _saveToDatabase();
      }
    } catch (e) {
    
      _settings = AppSettings();
    }
    notifyListeners();
  }

  Future<void> _saveToDatabase() async {
    if (_settings != null) {
      await _database.saveSettings(_settings!.toMap());
    }
  }

  Future<void> updateSettings(AppSettings newSettings) async {
    _settings = newSettings;
    await _saveToDatabase();
    notifyListeners();
  }

  Future<void> updateDailyStepsGoal(int goal) async {
    _settings = settings.copyWith(dailyStepsGoal: goal);
    await _saveToDatabase();
    notifyListeners();
  }

  Future<void> updateDailyCaloriesGoal(double goal) async {
    _settings = settings.copyWith(dailyCaloriesGoal: goal);
    await _saveToDatabase();
    notifyListeners();
  }

  Future<void> updateDailyWaterGoal(double goal) async {
    _settings = settings.copyWith(dailyWaterGoal: goal);
    await _saveToDatabase();
    notifyListeners();
  }

  Future<void> updateDailyActiveTimeGoal(double goal) async {
    _settings = settings.copyWith(dailyActiveTimeGoal: goal);
    await _saveToDatabase();
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool value) async {
    _settings = settings.copyWith(darkMode: value);
    await _saveToDatabase();
    notifyListeners();
  }

  Future<void> toggleNotifications(bool value) async {
    _settings = settings.copyWith(notificationsEnabled: value);
    await _saveToDatabase();
    notifyListeners();
  }

  Future<void> updateMeasurementUnit(String unit) async {
    _settings = settings.copyWith(measurementUnit: unit);
    await _saveToDatabase();
    notifyListeners();
  }

  int get dailyStepsGoal => settings.dailyStepsGoal;
  double get dailyCaloriesGoal => settings.dailyCaloriesGoal;
  double get dailyWaterGoal => settings.dailyWaterGoal;
  double get dailyActiveTimeGoal => settings.dailyActiveTimeGoal;
  bool get isDarkMode => settings.darkMode;
  bool get notificationsEnabled => settings.notificationsEnabled;
  String get measurementUnit => settings.measurementUnit;
}