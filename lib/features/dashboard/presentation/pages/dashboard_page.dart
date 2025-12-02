import 'package:flutter/material.dart';
import 'package:healthmate/core/theme/app_theme.dart';
import 'package:healthmate/features/dashboard/presentation/widgets/activity_card.dart';
import 'package:healthmate/features/dashboard/presentation/widgets/calories_burned_card.dart';
import 'package:healthmate/features/dashboard/presentation/widgets/daily_stats_card.dart';
import 'package:healthmate/features/dashboard/presentation/widgets/header_widget.dart';
import 'package:healthmate/features/dashboard/presentation/widgets/water_intake_card.dart';
import 'package:healthmate/features/health_records/presentation/pages/add_record_page.dart';
import 'package:healthmate/features/health_records/presentation/providers/health_record_provider.dart';
import 'package:healthmate/features/health_records/presentation/pages/record_list_page.dart';
import 'package:provider/provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            const HeaderWidget(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const DailyStatsCard(),
                    const SizedBox(height: 20),
                    _buildActivityGrid(context),
                    const SizedBox(height: 20),
                    const CaloriesBurnedCard(),
                    const SizedBox(height: 20),
                    const WaterIntakeCard(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: AppTheme.backgroundLight,
        color: AppTheme.primaryColor,
        animationDuration: const Duration(milliseconds: 300),
        items: const [
          Icon(Icons.dashboard, color: Colors.white, size: 30),
          Icon(Icons.add_chart, color: Colors.white, size: 30),
          Icon(Icons.list, color: Colors.white, size: 30),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddRecordPage(),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RecordListPage(),
              ),
            );
          }
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddRecordPage(),
            ),
          );
        },
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.add, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildActivityGrid(BuildContext context) {
    return Consumer<HealthRecordProvider>(
      builder: (context, provider, child) {
        final todaySummary = provider.getTodaySummary();

        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            ActivityCard(
              title: "Steps",
              currentValue: todaySummary?.steps ?? 0,
              targetValue: 10000,
              unit: "steps",
              icon: Icons.directions_walk,
              color: AppTheme.stepsColor,
              gradient: AppTheme.primaryGradient,
            ),
            ActivityCard(
              title: "Calories",
              currentValue: todaySummary?.calories ?? 0,
              targetValue: 2000,
              unit: "cal",
              icon: Icons.local_fire_department,
              color: AppTheme.caloriesColor,
              gradient: AppTheme.secondaryGradient,
            ),
            ActivityCard(
              title: "Water",
              currentValue: todaySummary?.water ?? 0,
              targetValue: 2000,
              unit: "ml",
              icon: Icons.water_drop,
              color: AppTheme.waterColor,
              gradient: LinearGradient(
                colors: [AppTheme.waterColor, AppTheme.secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            ActivityCard(
              title: "Active Time",
              currentValue: 45,
              targetValue: 60,
              unit: "min",
              icon: Icons.timer,
              color: AppTheme.sleepColor,
              gradient: LinearGradient(
                colors: [AppTheme.sleepColor, AppTheme.primaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ],
        );
      },
    );
  }
}