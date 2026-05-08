import 'package:customer_timesheet_and_invoicing/data/app_database.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

//Task list on timesheet that is attached to overall tasks

class PosCreationServices {
  Future<void> createPosItem(Map<String, dynamic> values) async {
    final db = await AppDatabase.instance.database;
    await db.insert(
      'purchase_order_numbers',
      values,
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<List<Map<String, dynamic>>> getPosItems() async {
    final db = await AppDatabase.instance.database;
    final result = await db.query('purchase_order_numbers');
    return result;
  }

  Future<int> deletePos(String pos) async {
    final db = await AppDatabase.instance.database;
    return await db.delete(
      'purchase_order_numbers',
      where: 'pos = ?',
      whereArgs: [pos],  
    );
  }
}