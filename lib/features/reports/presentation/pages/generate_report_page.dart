import 'package:flutter/material.dart';
import 'package:healthmate/core/theme/app_theme.dart';
import 'package:healthmate/features/reports/data/services/report_service.dart';
import 'package:healthmate/features/reports/presentation/providers/report_provider.dart';
import 'package:healthmate/features/health_records/presentation/providers/health_record_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class GenerateReportPage extends StatefulWidget {
  const GenerateReportPage({super.key});

  @override
  State<GenerateReportPage> createState() => _GenerateReportPageState();
}

class _GenerateReportPageState extends State<GenerateReportPage> {
  final ReportService _reportService = ReportService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'Generate Report',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer2<HealthRecordProvider, ReportProvider>(
        builder: (context, healthProvider, reportProvider, child) {
        
          final records = healthProvider.records.map((record) => {
            'id': record.id,
            'date': record.date,
            'steps': record.steps,
            'calories': record.calories,
            'water': record.water,
          }).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                _buildDateSelectionCard(reportProvider),
                
                const SizedBox(height: 20),
                
               
                if (reportProvider.selectedFromDate != null && 
                    reportProvider.selectedToDate != null)
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: reportProvider.isGenerating ? null : () => _generateReport(records, reportProvider),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: reportProvider.isGenerating
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Generate Report',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                
                const SizedBox(height: 20),
                
                
                if (reportProvider.generatedReport != null)
                  _buildReportPreview(reportProvider.generatedReport!),
                
                const SizedBox(height: 20),
                
              
                if (reportProvider.generatedReport != null)
                  _buildActionButtons(reportProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateSelectionCard(ReportProvider provider) {
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
          const Text(
            'Select Date Range',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppTheme.textPrimary,
            ),
          ),
          
          const SizedBox(height: 20),
          
        
          _buildDateField(
            'From Date',
            provider.selectedFromDate,
            () => _selectDate(context, provider, isFromDate: true),
          ),
          
          const SizedBox(height: 16),
          
          _buildDateField(
            'To Date',
            provider.selectedToDate,
            () => _selectDate(context, provider, isFromDate: false),
          ),
          
          const SizedBox(height: 10),
          
         
          if (provider.selectedFromDate != null && provider.selectedToDate != null)
            Text(
              'Selected: ${DateFormat('dd MMM yyyy').format(provider.selectedFromDate!)} - ${DateFormat('dd MMM yyyy').format(provider.selectedToDate!)}',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDateField(String label, DateTime? date, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.backgroundLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.textLight.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: AppTheme.primaryColor,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    date != null 
                        ? DateFormat('dd MMMM yyyy').format(date)
                        : 'Select date',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: date != null ? AppTheme.textPrimary : AppTheme.textLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportPreview(Map<String, dynamic> report) {
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
          const Text(
            'Report Preview',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppTheme.textPrimary,
            ),
          ),
          
          const SizedBox(height: 20),
          
          _buildSummaryItem('Total Days', report['records'].length.toString()),
          const SizedBox(height: 12),
          _buildSummaryItem('Total Steps', _formatNumber(report['totalSteps'])),
          const SizedBox(height: 12),
          _buildSummaryItem('Total Calories', _formatNumber(report['totalCalories'])),
          const SizedBox(height: 12),
          _buildSummaryItem('Total Water', '${(report['totalWater'] / 1000).toStringAsFixed(1)} L'),
          const SizedBox(height: 12),
          _buildSummaryItem('Avg Steps/Day', report['avgSteps'].toStringAsFixed(0)),
          const SizedBox(height: 12),
          _buildSummaryItem('Avg Calories/Day', report['avgCalories'].toStringAsFixed(0)),
          const SizedBox(height: 12),
          _buildSummaryItem('Avg Water/Day', '${(report['avgWater'] / 1000).toStringAsFixed(1)} L'),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(ReportProvider provider) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => _downloadReport(provider),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.download, size: 20),
                SizedBox(width: 8),
                Text('Download TXT'),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () => _shareReport(provider),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.secondaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.share, size: 20),
                SizedBox(width: 8),
                Text('Share'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, ReportProvider provider, {required bool isFromDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    
    if (picked != null) {
      if (isFromDate) {
        provider.setFromDate(picked);
      } else {
        provider.setToDate(picked);
      }
    }
  }

  Future<void> _generateReport(List<Map<String, dynamic>> records, ReportProvider reportProvider) async {
    try {
      await reportProvider.generateReport(records);
      
      // Show success message
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Report generated successfully!'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppTheme.caloriesColor,
        ),
      );
    }
  }

  Future<void> _downloadReport(ReportProvider provider) async {
    try {
      final file = await _reportService.saveReport(provider.generatedReport!);
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Report saved to: ${file.path}'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating report: $e'),
          backgroundColor: AppTheme.caloriesColor,
        ),
      );
    }
  }

  Future<void> _shareReport(ReportProvider provider) async {
    try {
      final file = await _reportService.saveReport(provider.generatedReport!);
      await _reportService.shareReport(file);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sharing report: $e'),
          backgroundColor: AppTheme.caloriesColor,
        ),
      );
    }
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }
}