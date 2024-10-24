import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart'; 


Future<Database> initializeDB() async {
  return openDatabase(
    join(await getDatabasesPath(), 'aquarium.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE settings(id INTEGER PRIMARY KEY, color INTEGER, speed REAL, fish_count INTEGER)',
      );
    },
    version: 1,
  );
}

Future<void> saveSettings(int fishCount, Color color, double speed) async {
  final db = await initializeDB();
  
  await db.insert(
    'settings',
    {
      'color': color.value,
      'speed': speed,
      'fish_count': fishCount,
    },
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<Map<String, dynamic>?> loadSettings() async {
  final db = await initializeDB();

  final List<Map<String, dynamic>> settings = await db.query('settings', limit: 1);

  if (settings.isNotEmpty) {
    return {
      'color': settings.first['color'],
      'speed': settings.first['speed'],
      'fish_count': settings.first['fish_count'],
    };
  }
  return null;
}
