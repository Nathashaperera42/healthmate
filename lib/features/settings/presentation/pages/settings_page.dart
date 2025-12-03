import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthmate/features/settings/presentation/providers/settings_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          final settings = settingsProvider.settings;
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildSectionHeader('Health Goals'),
              _buildNumberSetting(
                context,
                'Daily Steps Goal',
                '${settings.dailyStepsGoal} steps',
                Icons.directions_walk,
                (value) => settingsProvider.updateDailyStepsGoal(value.toInt()),
                initialValue: settings.dailyStepsGoal.toDouble(),
                min: 1000,
                max: 50000,
                step: 1000,
              ),
              _buildDivider(),
              _buildNumberSetting(
                context,
                'Daily Calories Goal',
                '${settings.dailyCaloriesGoal} cal',
                Icons.restaurant,
                (value) => settingsProvider.updateDailyCaloriesGoal(value),
                initialValue: settings.dailyCaloriesGoal,
                min: 500,
                max: 5000,
                step: 100,
              ),
              _buildDivider(),
              _buildNumberSetting(
                context,
                'Daily Water Goal',
                '${settings.dailyWaterGoal} glasses',
                Icons.water_drop,
                (value) => settingsProvider.updateDailyWaterGoal(value),
                initialValue: settings.dailyWaterGoal,
                min: 1,
                max: 20,
                step: 0.5,
              ),
              _buildDivider(),
              _buildNumberSetting(
                context,
                'Daily Active Time',
                '${settings.dailyActiveTimeGoal} minutes',
                Icons.timer,
                (value) => settingsProvider.updateDailyActiveTimeGoal(value),
                initialValue: settings.dailyActiveTimeGoal,
                min: 5,
                max: 240,
                step: 5,
              ),
              
              const SizedBox(height: 24),
              _buildSectionHeader('Units'),
              _buildSegmentedSetting(
                context,
                'Measurement Unit',
                settings.measurementUnit,
                const {
                  0: 'Metric',
                  1: 'Imperial',
                },
                Icons.straighten,
                (value) {
                  final unit = value == 0 ? 'metric' : 'imperial';
                  settingsProvider.updateMeasurementUnit(unit);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildNumberSetting(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Function(double) onChanged, {
    required double initialValue,
    required double min,
    required double max,
    required double step,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(value),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () async {
          final newValue = await showDialog<double>(
            context: context,
            builder: (context) {
              double tempValue = initialValue;
              return AlertDialog(
                title: Text('Edit $title'),
                content: StatefulBuilder(
                  builder: (context, setState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Current: $value',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        Slider(
                          value: tempValue,
                          min: min,
                          max: max,
                          divisions: ((max - min) / step).round(),
                          label: tempValue.toStringAsFixed(step < 1 ? 1 : 0),
                          onChanged: (value) {
                            setState(() => tempValue = value);
                          },
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Selected: ${tempValue.toStringAsFixed(step < 1 ? 1 : 0)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(tempValue),
                    child: const Text('Save'),
                  ),
                ],
              );
            },
          );
          if (newValue != null) {
            onChanged(newValue);
          }
        },
      ),
    );
  }

  Widget _buildSegmentedSetting(
    BuildContext context,
    String title,
    String currentValue,
    Map<int, String> options,
    IconData icon,
    Function(int) onChanged,
  ) {
    final selectedIndex = currentValue == 'metric' ? 0 : 1;
    
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(options[selectedIndex]!),
      trailing: DropdownButton<int>(
        value: selectedIndex,
        items: options.entries.map((entry) {
          return DropdownMenuItem<int>(
            value: entry.key,
            child: Text(entry.value),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            onChanged(value);
          }
        },
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 0.5);
  }
}