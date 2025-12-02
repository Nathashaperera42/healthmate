import 'package:flutter/material.dart';
import 'package:healthmate/core/theme/app_theme.dart';

class CaloriesBurnedCard extends StatelessWidget {
  const CaloriesBurnedCard({super.key});

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
                    '1,650',
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
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      value: 0.75,
                      strokeWidth: 8,
                      backgroundColor: AppTheme.textLight.withOpacity(0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.caloriesColor),
                    ),
                  ),
                  Text(
                    '75%',
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
          
          // Activity Breakdown
          _buildActivityItem('Walking', '450 cal', 0.3, AppTheme.stepsColor),
          _buildActivityItem('Running', '800 cal', 0.5, AppTheme.caloriesColor),
          _buildActivityItem('Cycling', '400 cal', 0.2, AppTheme.waterColor),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String activity, String calories, double width, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              activity,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.textLight.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  height: 8,
                  width: MediaQuery.of(activity.indexOf(activity).toString() as BuildContext).size.width * width * 0.3,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              calories,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}