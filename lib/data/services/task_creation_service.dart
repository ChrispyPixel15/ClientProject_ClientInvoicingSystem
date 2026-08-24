import 'package:customer_timesheet_and_invoicing/data/app_database.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
//Task list on timesheet that is attached to overall tasks

class TaskCreationService {
  Future<void> createTaskItems(Map<String, dynamic> values, String appPassword) async {
    final db = await AppDatabase.instance.getDatabase(appPassword);
    await db.insert(
      'tasks',
      values,
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<List<Map<String, dynamic>>> getTaskItems(String appPassword) async {
    final db = await AppDatabase.instance.getDatabase(appPassword);
    final result = await db.query('tasks');
    return result;
  }

  Future<int> deleteTask(String task, String appPassword) async {
    final db = await AppDatabase.instance.getDatabase(appPassword);
    return await db.delete(
      'tasks',
      where: 'task = ?',
      whereArgs: [task],  
    );
  }
}