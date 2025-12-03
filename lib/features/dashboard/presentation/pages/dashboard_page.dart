import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthmate/core/theme/app_theme.dart';
import 'package:healthmate/features/dashboard/presentation/widgets/activity_card.dart';
import 'package:healthmate/features/dashboard/presentation/widgets/calories_burned_card.dart';
import 'package:healthmate/features/dashboard/presentation/widgets/daily_stats_card.dart';
import 'package:healthmate/features/dashboard/presentation/widgets/header_widget.dart';
import 'package:healthmate/features/dashboard/presentation/widgets/water_intake_card.dart';
import 'package:healthmate/features/health_records/presentation/pages/add_record_page.dart';
import 'package:healthmate/features/health_records/presentation/providers/health_record_provider.dart';
import 'package:healthmate/features/health_records/presentation/pages/record_list_page.dart';
import 'package:healthmate/features/reports/presentation/pages/generate_report_page.dart';
import 'package:healthmate/features/settings/data/models/settings_model.dart';
import 'package:healthmate/features/settings/presentation/providers/settings_provider.dart';
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
  void initState() {
    super.initState();
   
    Future.microtask(() {
      Provider.of<HealthRecordProvider>(context, listen: false).loadRecords();
      Provider.of<SettingsProvider>(context, listen: false).loadSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(
            
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(), 
        actions: [
          IconButton(
            icon: Icon(Icons.assessment, color: AppTheme.primaryColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GenerateReportPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const HeaderWidget(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Consumer2<HealthRecordProvider, SettingsProvider>(
                      builder:
                          (context, healthProvider, settingsProvider, child) {
                            final todaySummary = healthProvider
                                .getTodaySummary();
                            return DailyStatsCard(
                              todaySummary: todaySummary,
                              settings: settingsProvider.settings,
                            );
                          },
                    ),
                    const SizedBox(height: 20),
                    _buildActivityGrid(context),
                    const SizedBox(height: 20),
                    Consumer2<HealthRecordProvider, SettingsProvider>(
                      builder:
                          (context, healthProvider, settingsProvider, child) {
                            final todaySummary = healthProvider
                                .getTodaySummary();
                            return CaloriesBurnedCard(
                              todaySummary: todaySummary,
                              dailyCaloriesGoal: settingsProvider
                                  .dailyCaloriesGoal
                                  .toInt(), 
                            );
                          },
                    ),
                    const SizedBox(height: 20),
                    Consumer2<HealthRecordProvider, SettingsProvider>(
                      builder:
                          (context, healthProvider, settingsProvider, child) {
                            final todaySummary = healthProvider
                                .getTodaySummary();
                            return WaterIntakeCard(
                              todaySummary: todaySummary,
                              dailyWaterGoal: settingsProvider.dailyWaterGoal
                                  .toInt(), 
                            );
                          },
                    ),
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
        index: _currentIndex,
        items: const [
          Icon(Icons.dashboard, color: Colors.white, size: 30),
          Icon(Icons.list, color: Colors.white, size: 30),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RecordListPage()),
            ).then((_) {
             
              setState(() {
                _currentIndex = 0;
              });
            });
          }
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRecordPage()),
          ).then((_) {
            
            Provider.of<HealthRecordProvider>(
              context,
              listen: false,
            ).loadRecords();
          });
        },
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildActivityGrid(BuildContext context) {
    return Consumer2<HealthRecordProvider, SettingsProvider>(
      builder: (context, healthProvider, settingsProvider, child) {
        final todaySummary = healthProvider.getTodaySummary();

       
        if (todaySummary == null) {
          return Column(
            children: [
              Container(
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
                    Icon(
                      Icons.assignment_outlined,
                      size: 60,
                      color: AppTheme.textLight,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No data recorded for today',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add your health data to track your progress',
                      style: TextStyle(color: AppTheme.textLight, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddRecordPage(),
                          ),
                        ).then((_) {
                          
                          Provider.of<HealthRecordProvider>(
                            context,
                            listen: false,
                          ).loadRecords();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('Add Today\'s Data'),
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            ActivityCard(
              title: "Steps",
              currentValue: todaySummary.steps,
              targetValue: settingsProvider.dailyStepsGoal,
              unit: "steps",
              icon: Icons.directions_walk,
              color: AppTheme.stepsColor,
              gradient: AppTheme.primaryGradient,
            ),
            ActivityCard(
              title: "Calories",
              currentValue: todaySummary.calories,
              targetValue: settingsProvider.dailyCaloriesGoal
                  .toInt(),
              unit: "cal",
              icon: Icons.local_fire_department,
              color: AppTheme.caloriesColor,
              gradient: AppTheme.secondaryGradient,
            ),
            ActivityCard(
              title: "Water",
              currentValue: todaySummary.water,
              targetValue: settingsProvider.dailyWaterGoal
                  .toInt(),
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
              targetValue: settingsProvider.dailyActiveTimeGoal
                  .toInt(), 
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
