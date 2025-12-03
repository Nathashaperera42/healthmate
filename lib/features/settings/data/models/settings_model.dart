
class AppSettings {
  final int dailyStepsGoal;
  final double dailyCaloriesGoal;
  final double dailyWaterGoal;
  final double dailyActiveTimeGoal;
  final String measurementUnit;
  final bool notificationsEnabled;
  final bool darkMode;

  AppSettings({
    this.dailyStepsGoal = 10000,
    this.dailyCaloriesGoal = 2000.0,
    this.dailyWaterGoal = 8.0,
    this.dailyActiveTimeGoal = 60.0,
    this.measurementUnit = 'metric',
    this.notificationsEnabled = true,
    this.darkMode = false,
  });

  AppSettings copyWith({
    int? dailyStepsGoal,
    double? dailyCaloriesGoal,
    double? dailyWaterGoal,
    double? dailyActiveTimeGoal,
    String? measurementUnit,
    bool? notificationsEnabled,
    bool? darkMode,
  }) {
    return AppSettings(
      dailyStepsGoal: dailyStepsGoal ?? this.dailyStepsGoal,
      dailyCaloriesGoal: dailyCaloriesGoal ?? this.dailyCaloriesGoal,
      dailyWaterGoal: dailyWaterGoal ?? this.dailyWaterGoal,
      dailyActiveTimeGoal: dailyActiveTimeGoal ?? this.dailyActiveTimeGoal,
      measurementUnit: measurementUnit ?? this.measurementUnit,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkMode: darkMode ?? this.darkMode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dailyStepsGoal': dailyStepsGoal,
      'dailyCaloriesGoal': dailyCaloriesGoal,
      'dailyWaterGoal': dailyWaterGoal,
      'dailyActiveTimeGoal': dailyActiveTimeGoal,
      'measurementUnit': measurementUnit,
      'notificationsEnabled': notificationsEnabled,
      'darkMode': darkMode,
    };
  }

 factory AppSettings.fromMap(Map<String, dynamic> map) {
  return AppSettings(
    dailyStepsGoal: map['dailyStepsGoal']?.toInt() ?? 10000,
    dailyCaloriesGoal: map['dailyCaloriesGoal']?.toDouble() ?? 2000.0,
    dailyWaterGoal: map['dailyWaterGoal']?.toDouble() ?? 2000.0,
    dailyActiveTimeGoal: map['dailyActiveTimeGoal']?.toDouble() ?? 60.0,
    measurementUnit: map['measurementUnit']?.toString() ?? 'metric',
    notificationsEnabled: map['notificationsEnabled'] ?? true,
    darkMode: map['darkMode'] ?? false,
  );
}
}