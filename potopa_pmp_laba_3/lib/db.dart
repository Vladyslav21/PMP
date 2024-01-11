import 'dart:developer';

import 'package:potopa_pmp_laba_3/weather.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';

Future<Database> getDb() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = openDatabase(
    join(await getDatabasesPath(), 'lab3.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE weather(id STRING PRIMARY KEY, temperature TEXT, wind TEXT)',
      );
    },
    version: 1,
  );

  return database;
}

Future<void> insertWeather(WeatherInfo weather) async {
  final db = await getDb();

  await db.insert(
    'weather',
    weather.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<WeatherInfo> getWeather(String id) async {
  final db = await getDb();
  List<Map<String, dynamic>> list = await db.rawQuery('SELECT * FROM weather WHERE id=? LIMIT 1', [id]);

  return WeatherInfo.fromDb(list[0]);

}