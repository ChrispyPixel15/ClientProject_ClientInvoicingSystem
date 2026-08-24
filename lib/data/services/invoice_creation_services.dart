import 'package:customer_timesheet_and_invoicing/data/app_database.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
//Task list on timesheet that is attached to overall tasks

class InvoiceCreationServices {
  Future<void> createInvoice(Map<String, dynamic> values, String appPassword) async {
    final db = await AppDatabase.instance.getDatabase(appPassword);
    await db.insert(
      'invoices',
      values,
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<List<Map<String, dynamic>>> getInvoices(String appPassword) async {
    final db = await AppDatabase.instance.getDatabase(appPassword);
    final result = await db.query('invoices');
    return result;
  }

  Future<int> deleteInvoice(int invoiceNum, String appPassword) async {
    final db = await AppDatabase.instance.getDatabase(appPassword);
    return await db.delete(
      'invoices',
      where: 'invoice_number = ?',
      whereArgs: [invoiceNum],  
    );
  }

  Future<int> updateInvoice(int? id, Map<String, dynamic> values, String appPassword) async {
    final db = await AppDatabase.instance.getDatabase(appPassword);
    return await db.update(
      'invoices',
      values,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> createInvoiceDB(int invoiceNum, String appPassword) async {
    final db = await AppDatabase.instance.getDatabase(appPassword);
    await db.execute(
      '''
      CREATE TABLE invoice$invoiceNum (
        id INTEGER,
        client_fk TEXT,
        pos_fk TEXT,
        task_name TEXT,
        hours INTEGER,
        price_ph FLOAT,
        FOREIGN KEY (client_fk) REFERENCES clients(client_bus_name),
        FOREIGN KEY (pos_fk) REFERENCES purchase_order_numbers(pos)
      )
      '''
    );
  }

  Future<void> deleteInvoiceDB(int invoiceNum, String appPassword) async {
    final db = await AppDatabase.instance.getDatabase(appPassword);
    await db.execute('DROP TABLE IF EXISTS invoice$invoiceNum');
  }

  Future<List<Map<String, dynamic>>> getInvoiceData(int invoiceNum, String appPassword) async {
    final db = await AppDatabase.instance.getDatabase(appPassword);
    final result = await db.query('invoice$invoiceNum');
    return result;
  }

  Future<void> addInvoiceItem(Map<String, dynamic> values, int invoiceNum, String appPassword) async {
    final db = await AppDatabase.instance.getDatabase(appPassword);
    await db.insert(
      "invoice$invoiceNum",
      values,
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<int> deleteInvoiceItem(String task, int invoiceNum, String appPassword) async {
    final db = await AppDatabase.instance.getDatabase(appPassword);
    return await db.delete(
      "invoice$invoiceNum",
      where: 'task_name = ?',
      whereArgs: [task],  
    );
  }
}