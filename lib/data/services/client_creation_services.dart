import 'package:customer_timesheet_and_invoicing/data/app_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class ClientCreationServices {
  Future<void> createClient(Map<String, dynamic> values) async {
    final db = await AppDatabase.instance.getDatabase();
    await db.insert(
      'clients',
      values,
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<List<Map<String, dynamic>>> getClients() async {
    final db = await AppDatabase.instance.getDatabase();
    final result = await db.query('clients');
    debugPrint(result.toString());
    return result;
  }

  Future<int> deleteClient(String? id) async {
    final db = await AppDatabase.instance.getDatabase();
    return await db.delete(
      'clients',
      where: 'id = ?',
      whereArgs: [id],
    );
  } 

  Future<int> updateClient(String? id, Map<String, dynamic> values) async {
    final db = await AppDatabase.instance.getDatabase();
    return await db.update(
      'clients',
      values,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Map<String, dynamic>?> getClient(String id) async {
    final db = await AppDatabase.instance.getDatabase();
    final result = await db.query(
      'clients',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }
}