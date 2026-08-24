import 'package:customer_timesheet_and_invoicing/core/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:customer_timesheet_and_invoicing/features/CTI app/cti_app.dart';
import 'data/app_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final ThemeController themeController = ThemeController();

  bool isSetupComplete = false;

  final exists = await doesDatabaseExist();
  if (exists) {
    isSetupComplete = true;
  }

  runApp(CTIApp(isSetupComplete: isSetupComplete, themeController: themeController,));
} 

Future<bool> doesDatabaseExist() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'cti_data.db');
  return await databaseExists(path);
}