import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ActivityCard extends StatelessWidget {
  final String title;
  final int currentValue;
  final int targetValue;
  final String unit;
  final IconData icon;
  final Color color;
  final Gradient gradient;

  const ActivityCard({
    super.key,
    required this.title,
    required this.currentValue,
    required this.targetValue,
    required this.unit,
    required this.icon,
    required this.color,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = currentValue / targetValue;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon and Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              Text(
                '${(percentage * 100).toInt()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Values
          Text(
            _formatValue(currentValue),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          
          const SizedBox(height: 10),
          
          // Progress Bar
          LinearPercentIndicator(
            animation: true,
            lineHeight: 4,
            animationDuration: 1000,
            percent: percentage > 1 ? 1.0 : percentage,
            barRadius: const Radius.circular(10),
            progressColor: Colors.white,
            backgroundColor: Colors.white.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  String _formatValue(int value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    }
    return value.toString();
  }
}