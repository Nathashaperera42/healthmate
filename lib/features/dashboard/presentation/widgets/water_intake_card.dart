import 'package:flutter/material.dart';
import 'package:healthmate/core/theme/app_theme.dart';
import 'package:healthmate/data/models/health_record.dart';
import 'package:percent_indicator/percent_indicator.dart';

class WaterIntakeCard extends StatelessWidget {
  final HealthRecord? todaySummary;
  final int dailyWaterGoal;
  
  const WaterIntakeCard({super.key, this.todaySummary, this.dailyWaterGoal = 2000});

  @override
  Widget build(BuildContext context) {
    
    final waterProgress = todaySummary != null 
        ? (todaySummary!.water / dailyWaterGoal).clamp(0.0, 1.0) 
        : 0.0;
    final waterInLiters = todaySummary != null ? todaySummary!.water / 1000.0 : 0.0;
    
    // Calculate how many cups are filled (8 cups = 2000ml, each cup = 250ml)
    final filledCups = todaySummary != null 
        ? (todaySummary!.water / 250).clamp(0, (dailyWaterGoal / 250).ceil()).toInt() 
        : 0;

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
                  color: AppTheme.waterColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.water_drop,
                  color: AppTheme.waterColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Water Intake',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Water Progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${waterInLiters.toStringAsFixed(1)}',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.waterColor,
                    ),
                  ),
                  Text(
                    'liters today',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${todaySummary?.water ?? 0} ml / $dailyWaterGoal ml',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              CircularPercentIndicator(
                radius: 40,
                lineWidth: 8,
                animation: true,
                percent: waterProgress,
                center: Text(
                  '${(waterProgress * 100).toInt()}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.waterColor,
                  ),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: AppTheme.waterColor,
                backgroundColor: AppTheme.textLight.withOpacity(0.3),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Water Cups
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int i = 0; i < (dailyWaterGoal / 250).ceil(); i++)
                _buildWaterCup('250ml', i < filledCups),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWaterCup(String size, bool filled) {
    return Column(
      children: [
        Container(
          width: 30,
          height: 40,
          decoration: BoxDecoration(
            color: filled ? AppTheme.waterColor : AppTheme.textLight.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          size,
          style: TextStyle(
            fontSize: 10,
            color: filled ? AppTheme.waterColor : AppTheme.textLight,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}