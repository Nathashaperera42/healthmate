

class HealthReport {
  final DateTime fromDate;
  final DateTime toDate;
  final List<Map<String, dynamic>> records;
  final int totalSteps;
  final int totalCalories;
  final int totalWater;
  final double avgSteps;
  final double avgCalories;
  final double avgWater;
  final int bestStepsDay;
  final int bestCaloriesDay;
  final int bestWaterDay;

  HealthReport({
    required this.fromDate,
    required this.toDate,
    required this.records,
    required this.totalSteps,
    required this.totalCalories,
    required this.totalWater,
    required this.avgSteps,
    required this.avgCalories,
    required this.avgWater,
    required this.bestStepsDay,
    required this.bestCaloriesDay,
    required this.bestWaterDay,
  });
}