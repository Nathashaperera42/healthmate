import 'package:flutter/material.dart';
import 'package:healthmate/core/theme/app_theme.dart';
import 'package:healthmate/data/models/health_record.dart';

class CaloriesBurnedCard extends StatelessWidget {
  final HealthRecord? todaySummary;
  final int dailyCaloriesGoal;
  
  const CaloriesBurnedCard({super.key, this.todaySummary, this.dailyCaloriesGoal = 2000});

  @override
  Widget build(BuildContext context) {
    // Calculate calories 
    final caloriesProgress = todaySummary != null 
        ? (todaySummary!.calories / dailyCaloriesGoal).clamp(0.0, 1.0) 
        : 0.0;

    // Calculate percentage of goal 
    final percentageAchieved = caloriesProgress * 100;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.caloriesColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.local_fire_department,
                  color: AppTheme.caloriesColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Calories Burned',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Calories Progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${todaySummary?.calories ?? 0}',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.caloriesColor,
                    ),
                  ),
                  Text(
                    'cal burned today',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Goal: $dailyCaloriesGoal cal',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      value: caloriesProgress,
                      strokeWidth: 8,
                      backgroundColor: AppTheme.textLight.withOpacity(0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.caloriesColor),
                    ),
                  ),
                  Text(
                    '${percentageAchieved.toInt()}%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.caloriesColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Single Progress Bar
          if (todaySummary != null && todaySummary!.calories > 0) ...[
            _buildOverallProgressBar(percentageAchieved, context),
          ] else ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Add calories data to track your progress',
                style: TextStyle(
                  color: AppTheme.textLight,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOverallProgressBar(double percentage, BuildContext context) {
    final progressValue = (percentage / 100).clamp(0.0, 1.0);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Daily Goal Progress',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
                fontSize: 14,
              ),
            ),
            Text(
              '${percentage.toInt()}%',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.caloriesColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.textLight.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Container(
              height: 8,
              width: MediaQuery.of(context).size.width * progressValue * 0.85,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.caloriesColor.withOpacity(0.8),
                    AppTheme.caloriesColor,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '0 cal',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
            Text(
              '$dailyCaloriesGoal cal',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}