import 'package:flutter/material.dart';
import 'package:healthmate/core/theme/app_theme.dart';
import 'package:healthmate/data/models/health_record.dart';
import 'package:healthmate/features/settings/data/models/settings_model.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DailyStatsCard extends StatelessWidget {
  final HealthRecord? todaySummary;
  final AppSettings? settings;
  
  const DailyStatsCard({super.key, this.todaySummary, this.settings});

  @override
  Widget build(BuildContext context) {
   
    final stepsGoal = settings?.dailyStepsGoal ?? 10000;
    final caloriesGoal = settings?.dailyCaloriesGoal?.toInt() ?? 2000; // Convert to int
    final waterGoal = settings?.dailyWaterGoal?.toInt() ?? 2000; // Convert to int
    
  
    final stepsProgress = todaySummary != null 
        ? (todaySummary!.steps / stepsGoal).clamp(0.0, 1.0) 
        : 0.0;
    final caloriesProgress = todaySummary != null 
        ? (todaySummary!.calories / caloriesGoal).clamp(0.0, 1.0) 
        : 0.0;
    final waterProgress = todaySummary != null 
        ? (todaySummary!.water / waterGoal).clamp(0.0, 1.0) 
        : 0.0;
    
    // Calculate overall progress
    final overallProgress = todaySummary != null 
        ? ((stepsProgress + caloriesProgress + waterProgress) / 3).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Daily Progress',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppTheme.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${(overallProgress * 100).toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Progress Bars
          _buildProgressItem('Steps', stepsProgress, AppTheme.stepsColor, todaySummary?.steps ?? 0, stepsGoal),
          const SizedBox(height: 12),
          _buildProgressItem('Calories', caloriesProgress, AppTheme.caloriesColor, todaySummary?.calories ?? 0, caloriesGoal),
          const SizedBox(height: 12),
          _buildProgressItem('Water', waterProgress, AppTheme.waterColor, todaySummary?.water ?? 0, waterGoal),
        ],
      ),
    );
  }

  Widget _buildProgressItem(String label, double progress, Color color, int currentValue, int targetValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearPercentIndicator(
          animation: true,
          lineHeight: 8,
          animationDuration: 1000,
          percent: progress,
          barRadius: const Radius.circular(10),
          progressColor: color,
          backgroundColor: AppTheme.textLight.withOpacity(0.3),
        ),
        const SizedBox(height: 4),
        Text(
          '$currentValue / $targetValue',
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}