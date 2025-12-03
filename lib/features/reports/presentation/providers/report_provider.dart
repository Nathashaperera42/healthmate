import 'package:flutter/foundation.dart';
import 'package:healthmate/features/reports/data/services/report_service.dart';

class ReportProvider with ChangeNotifier {
  final ReportService _reportService = ReportService();
  
  DateTime? _selectedFromDate;
  DateTime? _selectedToDate;
  Map<String, dynamic>? _generatedReport;
  bool _isGenerating = false;

  DateTime? get selectedFromDate => _selectedFromDate;
  DateTime? get selectedToDate => _selectedToDate;
  Map<String, dynamic>? get generatedReport => _generatedReport;
  bool get isGenerating => _isGenerating;

  void setFromDate(DateTime date) {
    _selectedFromDate = date;
    notifyListeners();
  }

  void setToDate(DateTime date) {
    _selectedToDate = date;
    notifyListeners();
  }

  Future<Map<String, dynamic>> generateReport(List<Map<String, dynamic>> records) async {
    if (_selectedFromDate == null || _selectedToDate == null) {
      throw Exception('Please select both from and to dates');
    }

    if (_selectedFromDate!.isAfter(_selectedToDate!)) {
      throw Exception('From date cannot be after to date');
    }

    _isGenerating = true;
    notifyListeners();

    try {
      _generatedReport = _reportService.generateReport(
        records,
        _selectedFromDate!,
        _selectedToDate!,
      );
      return _generatedReport!;
    } finally {
      _isGenerating = false;
      notifyListeners();
    }
  }

  void clearReport() {
    _generatedReport = null;
    notifyListeners();
  }
}