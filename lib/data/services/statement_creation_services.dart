import 'package:customer_timesheet_and_invoicing/data/app_database.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
//Task list on timesheet that is attached to overall tasks

class StatementCreationServices {
  Future<void> createClientStatement(Map<String, dynamic> values, String appPassword) async {
    final db = await AppDatabase.instance.getDatabase(appPassword);
    await db.insert(
      'client_statements',
      values,
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<void> createPersonalStatement(Map<String, dynamic> values, String appPassword) async {
    final db = await AppDatabase.instance.getDatabase(appPassword);
    await db.insert(
      'personal_statements',
      values,
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<List<Map<String, dynamic>>> getClientStatements(String appPassword) async {
    final db = await AppDatabase.instance.getDatabase(appPassword);
    final result = await db.query('client_statements');
    return result;
  }

  Future<List<Map<String, dynamic>>> getPersonalStatements(String appPassword) async {
    final db = await AppDatabase.instance.getDatabase(appPassword);
    final result = await db.query('personal_statements');
    return result;
  }

  Future<int> deleteClientStatement(int statementNum, String appPassword) async {
    final db = await AppDatabase.instance.getDatabase(appPassword);
    return await db.delete(
      'client_statements',
      where: 'statement_number = ?',
      whereArgs: [statementNum],  
    );
  }

  Future<int> deletePersonalStatement(int statementNum, String appPassword) async {
    final db = await AppDatabase.instance.getDatabase(appPassword);
    return await db.delete(
      'personal_statements',
      where: 'statement_number = ?',
      whereArgs: [statementNum],  
    );
  }
}