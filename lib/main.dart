import 'package:flutter/material.dart';
import 'package:healthmate/core/theme/app_theme.dart';
import 'package:healthmate/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:healthmate/data/database/health_database.dart';
import 'package:healthmate/features/health_records/presentation/providers/health_record_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HealthDatabase().initDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HealthRecordProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'HealthMate',
        theme: AppTheme.lightTheme,
        home: const DashboardPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}