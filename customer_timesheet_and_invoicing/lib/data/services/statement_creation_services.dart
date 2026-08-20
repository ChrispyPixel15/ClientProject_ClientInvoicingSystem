import 'package:customer_timesheet_and_invoicing/data/app_database.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

//Task list on timesheet that is attached to overall tasks

class StatementCreationServices {
  Future<void> createClientStatement(Map<String, dynamic> values) async {
    final db = await AppDatabase.instance.database;
    await db.insert(
      'client_statements',
      values,
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<void> createPersonalStatement(Map<String, dynamic> values) async {
    final db = await AppDatabase.instance.database;
    await db.insert(
      'personal_statements',
      values,
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<List<Map<String, dynamic>>> getClientStatements() async {
    final db = await AppDatabase.instance.database;
    final result = await db.query('client_statements');
    return result;
  }

  Future<List<Map<String, dynamic>>> getPersonalStatements() async {
    final db = await AppDatabase.instance.database;
    final result = await db.query('personal_statements');
    return result;
  }

  Future<int> deleteClientStatement(int statementNum) async {
    final db = await AppDatabase.instance.database;
    return await db.delete(
      'client_statements',
      where: 'statement_number = ?',
      whereArgs: [statementNum],  
    );
  }

  Future<int> deletePersonalStatement(int statementNum) async {
    final db = await AppDatabase.instance.database;
    return await db.delete(
      'personal_statements',
      where: 'statement_number = ?',
      whereArgs: [statementNum],  
    );
  }
}