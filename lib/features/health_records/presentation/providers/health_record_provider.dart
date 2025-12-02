import 'package:flutter/foundation.dart';
import 'package:healthmate/data/models/health_record.dart';
import 'package:healthmate/data/database/health_database.dart';

class HealthRecordProvider with ChangeNotifier {
  final HealthDatabase _database = HealthDatabase();
  List<HealthRecord> _records = [];
  List<HealthRecord> _filteredRecords = [];
  String _searchDate = '';

  List<HealthRecord> get records => _filteredRecords.isEmpty && _searchDate.isEmpty ? _records : _filteredRecords;
  String get searchDate => _searchDate;

  Future<void> loadRecords() async {
    _records = await _database.getAllRecords();
    _filteredRecords = [];
    notifyListeners();
  }

  Future<void> addRecord(HealthRecord record) async {
    await _database.insertRecord(record);
    await loadRecords();
  }

  Future<void> updateRecord(HealthRecord record) async {
    await _database.updateRecord(record);
    await loadRecords();
  }

  Future<void> deleteRecord(int id) async {
    await _database.deleteRecord(id);
    await loadRecords();
  }

  Future<void> searchByDate(String date) async {
    _searchDate = date;
    if (date.isEmpty) {
      _filteredRecords = [];
    } else {
      _filteredRecords = await _database.getRecordsByDate(date);
    }
    notifyListeners();
  }

  void clearSearch() {
    _searchDate = '';
    _filteredRecords = [];
    notifyListeners();
  }

  // Get today's summary
  HealthRecord? getTodaySummary() {
    final today = DateTime.now().toString().split(' ')[0];
    try {
      return _records.firstWhere((record) => record.date == today);
    } catch (e) {
      return null;
    }
  }
}