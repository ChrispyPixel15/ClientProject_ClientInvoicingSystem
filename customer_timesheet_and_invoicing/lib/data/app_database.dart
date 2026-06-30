import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class AppDatabase {
  static const _dbName = 'cti_data.db';
  static const _dbVersion = 1;

  static final AppDatabase instance = AppDatabase._internal();
  static Database? _database;

  AppDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _openDatabase();
    return _database!;
  }

  Future<Database> _openDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE user_profile (
        id INTEGER PRIMARY KEY,
        name TEXT,
        business_name TEXT,
        number STRING,
        email TEXT,
        recent_invoice INTEGER,
        vat_registered TEXT,
        vat_number INTEGER,
        vat_percentage INTEGER,
        street_address TEXT,
        city TEXT,
        suburb TEXT,
        postal_code INTEGER,
        bank TEXT,
        branch_code INTEGER,
        bic INTEGER,
        account_number INTEGER,
        theme TEXT,
        password TEXT,
        default_email TEXT
      )
      '''
    );

    await db.execute(
      '''
      CREATE TABLE tasks (
        task TEXT PRIMARY KEY
      )
      '''
    );

    await db.execute(
      '''
      CREATE TABLE purchase_order_numbers (
        pos TEXT PRIMARY KEY
      )
      '''
    );

    await db.execute(
      '''
      CREATE TABLE clients (
        id TEXT PRIMARY KEY,
        client_bus_name TEXT,
        client_contact_person TEXT,
        client_contact_number TEXT,
        client_email TEXT,
        client_vatNumber INTEGER,
        client_street_address TEXT,
        client_suburb TEXT,
        client_city TEXT,
        client_postal_code INTEGER,
        client_price_ph FLOAT,
        client_payment_term INTEGER,
        notes TEXT,
        status TEXT,
        unpaid_invoices INTEGER
      )
      '''
    );

    await db.execute(
      '''
      CREATE TABLE tasks_completed (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        task_fk TEXT,
        pos_fk TEXT,
        client_fk TEXT,
        date TEXT,
        hours INTEGER,
        invoiced TEXT,
        FOREIGN KEY (task_fk) REFERENCES tasks(task),
        FOREIGN KEY (pos_fk) REFERENCES purchase_order_numbers(pos),
        FOREIGN KEY (client_fk) REFERENCES clients(client_bus_name)
      )
      '''
    );

    await db.execute(
      '''
      CREATE TABLE invoices (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        client_fk TEXT,
        invoice_number INTEGER,
        date TEXT,
        paid TEXT,
        dir TEXT,
        FOREIGN KEY (client_fk) REFERENCES clients(client_bus_name)
      )
      '''
    );

    await db.execute(
      '''
      CREATE TABLE meta (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
      '''
    );
  }
}