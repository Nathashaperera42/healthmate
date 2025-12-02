import 'package:flutter/material.dart';
import 'package:healthmate/core/theme/app_theme.dart';
import 'package:percent_indicator/percent_indicator.dart';

class WaterIntakeCard extends StatelessWidget {
  const WaterIntakeCard({super.key});

  @override
  Widget build(BuildContext context) {
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
                    '1.8',
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
                ],
              ),
              CircularPercentIndicator(
                radius: 40,
                lineWidth: 8,
                animation: true,
                percent: 0.9,
                center: const Text(
                  '90%',
                  style: TextStyle(
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
              _buildWaterCup('250ml', true),
              _buildWaterCup('250ml', true),
              _buildWaterCup('250ml', true),
              _buildWaterCup('250ml', true),
              _buildWaterCup('250ml', true),
              _buildWaterCup('250ml', true),
              _buildWaterCup('250ml', false),
              _buildWaterCup('250ml', false),
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