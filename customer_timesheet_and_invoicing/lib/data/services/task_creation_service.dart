import 'package:customer_timesheet_and_invoicing/data/app_database.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

//Task list on timesheet that is attached to overall tasks

class TaskCreationService {
  Future<void> createTaskItems(Map<String, dynamic> values) async {
    final db = await AppDatabase.instance.database;
    await db.insert(
      'tasks',
      values,
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<List<Map<String, dynamic>>> getTaskItems() async {
    final db = await AppDatabase.instance.database;
    final result = await db.query('tasks');
    return result;
  }

  Future<int> deleteTask(String task) async {
    final db = await AppDatabase.instance.database;
    return await db.delete(
      'tasks',
      where: 'task = ?',
      whereArgs: [task],  
    );
  }
}