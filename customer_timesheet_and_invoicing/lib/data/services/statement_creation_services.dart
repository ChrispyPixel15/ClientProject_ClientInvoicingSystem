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

  Future<void> createClientStatementDB(int statementNum) async {
    final db = await AppDatabase.instance.database;
    await db.execute(
      '''
      CREATE TABLE client_statement$statementNum (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        client_fk TEXT,
        invoice_number_fk TEXT,
        paid TEXT,
        date_start TEXT,
        date_end TEXT,
        FOREIGN KEY (client_fk) REFERENCES clients(client_bus_name),
        FOREIGN KEY (invoice_number_fk) REFERENCES invoices(invoice_number)
      )
      '''
    );
  }

   Future<void> createPersonalStatementDB(int statementNum) async {
    final db = await AppDatabase.instance.database;
    await db.execute(
      '''
      CREATE TABLE personal_statement$statementNum (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        invoice_number_fk TEXT,
        paid TEXT,
        date_start TEXT,
        date_end TEXT,
        FOREIGN KEY (invoice_number_fk) REFERENCES invoices(invoice_number)
      )
      '''
    );
  }

  Future<void> deleteClientStatementDB(int statementNum) async {
    final db = await AppDatabase.instance.database;
    await db.execute('DROP TABLE IF EXISTS client_statement$statementNum');
  }

  Future<void> deletePersonalStatementDB(int statementNum) async {
    final db = await AppDatabase.instance.database;
    await db.execute('DROP TABLE IF EXISTS personal_statement$statementNum');
  }

  Future<List<Map<String, dynamic>>> getClientStatementData(int statementNum) async {
    final db = await AppDatabase.instance.database;
    final result = await db.query('client_statement$statementNum');
    return result;
  }

  Future<List<Map<String, dynamic>>> getPersonalStatementData(int statementNum) async {
    final db = await AppDatabase.instance.database;
    final result = await db.query('personal_statement$statementNum');
    return result;
  }
}