import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:healthmate/data/models/health_record.dart';

class HealthDatabase {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'healthmate.db');
    return await openDatabase(
      path,
      version: 3, 
      onCreate: (Database db, int version) async {
        //  health_records table
        await db.execute('''
          CREATE TABLE health_records(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT NOT NULL,
            steps INTEGER NOT NULL,
            calories INTEGER NOT NULL,
            water INTEGER NOT NULL
          )
        ''');
        
        //settings table
        await db.execute('''
          CREATE TABLE settings(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            dailyStepsGoal INTEGER DEFAULT 10000,
            dailyCaloriesGoal REAL DEFAULT 2000.0,
            dailyWaterGoal REAL DEFAULT 8.0,
            dailyActiveTimeGoal REAL DEFAULT 60.0,
            measurementUnit TEXT DEFAULT 'metric',
            notificationsEnabled INTEGER DEFAULT 1,
            darkMode INTEGER DEFAULT 0
          )
        ''');
        
        //  dummy health records
        await _insertDummyRecords(db);
        
        
        await db.insert('settings', {
          'dailyStepsGoal': 10000,
          'dailyCaloriesGoal': 2000.0,
          'dailyWaterGoal': 8.0,
          'dailyActiveTimeGoal': 60.0,
          'measurementUnit': 'metric',
          'notificationsEnabled': 1,
          'darkMode': 0,
        });
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
         
          
        }
        if (oldVersion < 3) {
          
          await db.execute('''
            CREATE TABLE settings(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              dailyStepsGoal INTEGER DEFAULT 10000,
              dailyCaloriesGoal REAL DEFAULT 2000.0,
              dailyWaterGoal REAL DEFAULT 8.0,
              dailyActiveTimeGoal REAL DEFAULT 60.0,
              measurementUnit TEXT DEFAULT 'metric',
              notificationsEnabled INTEGER DEFAULT 1,
              darkMode INTEGER DEFAULT 0
            )
          ''');
          
       
          await db.insert('settings', {
            'dailyStepsGoal': 10000,
            'dailyCaloriesGoal': 2000.0,
            'dailyWaterGoal': 8.0,
            'dailyActiveTimeGoal': 60.0,
            'measurementUnit': 'metric',
            'notificationsEnabled': 1,
            'darkMode': 0,
          });
        }
      },
    );
  }

  Future<void> _insertDummyRecords(Database db) async {
    final dummyRecords = [
      HealthRecord(
        date: '2024-01-15',
        steps: 8234,
        calories: 1850,
        water: 2000,
      ),
      HealthRecord(
        date: '2024-01-16',
        steps: 7567,
        calories: 1920,
        water: 1800,
      ),
      HealthRecord(
        date: '2024-01-17',
        steps: 10234,
        calories: 2100,
        water: 2200,
      ),
    ];

    for (var record in dummyRecords) {
      await db.insert('health_records', record.toMap());
    }
  }

  // Create Health Records 
  Future<int> insertRecord(HealthRecord record) async {
    final db = await database;
    return await db.insert('health_records', record.toMap());
  }

  Future<void> insertOrAccumulateRecord(HealthRecord record) async {
    final db = await database;
    
   
    final existingRecords = await getRecordsByDate(record.date);
    
    if (existingRecords.isNotEmpty) {
     
      final existingRecord = existingRecords.first;
      final accumulatedRecord = HealthRecord(
        id: existingRecord.id,
        date: record.date,
        steps: existingRecord.steps + record.steps,
        calories: existingRecord.calories + record.calories,
        water: existingRecord.water + record.water,
      );
      await updateRecord(accumulatedRecord);
    } else {
      
      await insertRecord(record);
    }
  }

  //Get All Records
  Future<List<HealthRecord>> getAllRecords() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'health_records',
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) {
      return HealthRecord.fromMap(maps[i]);
    });
  }

  //Get All Record by date 
  Future<List<HealthRecord>> getRecordsByDate(String date) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'health_records',
      where: 'date = ?',
      whereArgs: [date],
    );
    return List.generate(maps.length, (i) {
      return HealthRecord.fromMap(maps[i]);
    });
  }

  //Update Record 
  Future<int> updateRecord(HealthRecord record) async {
    final db = await database;
    return await db.update(
      'health_records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  //Delete Record 
  Future<int> deleteRecord(int id) async {
    final db = await database;
    return await db.delete(
      'health_records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Settings Methods
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    final db = await database;
    
  
    final existingSettings = await db.query('settings');
    
    if (existingSettings.isNotEmpty) {
      // Update 
      await db.update(
        'settings',
        settings,
        where: 'id = ?',
        whereArgs: [existingSettings.first['id']],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
     
      await db.insert(
        'settings',
        settings,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<Map<String, dynamic>> getSettings() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('settings');
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return {};
  }


  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('health_records');
    await db.delete('settings');
  }

  // Utility method 
  Future<void> resetSettings() async {
    final defaultSettings = {
      'dailyStepsGoal': 10000,
      'dailyCaloriesGoal': 2000.0,
      'dailyWaterGoal': 8.0,
      'dailyActiveTimeGoal': 60.0,
      'measurementUnit': 'metric',
      'notificationsEnabled': 1,
      'darkMode': 0,
    };
    await saveSettings(defaultSettings);
  }

  
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}