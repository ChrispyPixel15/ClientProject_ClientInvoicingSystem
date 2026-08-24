import 'package:customer_timesheet_and_invoicing/data/app_database.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
//Task list on timesheet that is attached to overall tasks

class PosCreationServices {
  Future<void> createPosItem(Map<String, dynamic> values, String appPassword) async {
    final db = await AppDatabase.instance.getDatabase(appPassword);
    await db.insert(
      'purchase_order_numbers',
      values,
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<List<Map<String, dynamic>>> getPosItems(String appPassword) async {
    final db = await AppDatabase.instance.getDatabase(appPassword);
    final result = await db.query('purchase_order_numbers');
    return result;
  }

  Future<int> deletePos(String pos, String appPassword) async {
    final db = await AppDatabase.instance.getDatabase(appPassword);
    return await db.delete(
      'purchase_order_numbers',
      where: 'pos = ?',
      whereArgs: [pos],  
    );
  }
}