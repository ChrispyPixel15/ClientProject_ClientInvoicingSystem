import 'package:customer_timesheet_and_invoicing/data/app_database.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
class TimesheetTaskCreationServices {
  Future<void> createTimesheetTask(Map<String, dynamic> values, String appPassword) async {
    final db = await AppDatabase.instance.getDatabase(appPassword);
    await db.insert(
      'tasks_completed',
      values,
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<List<Map<String, dynamic>>> getTimesheetTasks(String appPassword) async {
    final db = await AppDatabase.instance.getDatabase(appPassword);
    final result = await db.query('tasks_completed');
    return result;
  }

  Future<int> deleteTimehseetTask(int? id, String appPassword) async {
    final db = await AppDatabase.instance.getDatabase(appPassword);
    return await db.delete(
      'tasks_completed',
      where: 'id = ?',
      whereArgs: [id],  
    );
  }

  Future<int> updateTimesheetTask(int? id, Map<String, dynamic> values, String appPassword) async {
    final db = await AppDatabase.instance.getDatabase(appPassword);
    return await db.update(
      'tasks_completed',
      values,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}