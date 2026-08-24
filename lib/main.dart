import 'package:customer_timesheet_and_invoicing/core/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:ffi'; 
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:customer_timesheet_and_invoicing/features/CTI app/cti_app.dart';
import 'data/app_database.dart';
import 'package:sqlite3/open.dart' as sqlite3;
import 'package:sqlite3/sqlite3.dart';

void initSqlCipher() {
  // Tell sqlite3 to use your SQLCipher DLL instead of the default SQLite
  sqlite3.open.overrideFor(sqlite3.OperatingSystem.windows, () {
    return DynamicLibrary.open("windows/sqlite3.dll"); // adjust path to your DLL
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  initSqlCipher();

  databaseFactory = databaseFactoryFfi;

  bool isSetupComplete = false;

  final exists = await doesDatabaseExist();
  if (exists) {
    isSetupComplete = true;
  }

  final ThemeController themeController = ThemeController(isSetupComplete);

  runApp(CTIApp(isSetupComplete: isSetupComplete, themeController: themeController,));
} 

Future<bool> doesDatabaseExist() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'cti_data.db');
  return await databaseExists(path);
}