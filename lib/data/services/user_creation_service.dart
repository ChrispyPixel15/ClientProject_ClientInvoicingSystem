import 'package:customer_timesheet_and_invoicing/data/app_database.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class UserProfileServices {
  Future<void> saveUserProfile(Map<String, dynamic> values) async {
    final db = await AppDatabase.instance.getDatabase();
    await db.insert(
      'user_profile',
      values,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    final db = await AppDatabase.instance.getDatabase();
    final result = await db.query('user_profile', where: 'id = ?', whereArgs: [1]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateUser(Map<String, dynamic> values) async {
    final db = await AppDatabase.instance.getDatabase();
    return await db.update(
      'user_profile',
      values,
      where: 'id = ?',
      whereArgs: [1],
    );
  }
}