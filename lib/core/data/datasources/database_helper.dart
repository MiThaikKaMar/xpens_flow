import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:xpens_flow/features/transactions/data/tables/transaction_split_table.dart';
import 'package:xpens_flow/features/transactions/data/tables/transaction_table.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;
  // final int _databaseVersion = 3;
  final int _databaseVersion = 5; // add split table

  DatabaseHelper._();

  factory DatabaseHelper() => _instance ??= DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'xpens_flow.db');

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: _onConfigure,
    );
  }

  // Enable foreign keys
  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    debugPrint('Creating database tables...');

    //Create transactions table
    await db.execute(TransactionTable.createTableSQL);

    // Create Transaction splits table
    await db.execute(TransactionSplitTable.createTableSQL);

    debugPrint('Database tables created.');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    debugPrint('Upgrading database from version $oldVersion to $newVersion...');

    if (oldVersion < 3) {
      debugPrint("Migrating to version 3...");

      // add new columns to existing transactions table
      await db.execute(
        'ALTER TABLE ${TransactionTable.tableName} ADD COLUMN ${TransactionTable.columnAccount} TEXT',
      );
      await db.execute(
        'ALTER TABLE ${TransactionTable.tableName} ADD COLUMN ${TransactionTable.columnDescription} TEXT',
      );
      await db.execute(
        'ALTER TABLE ${TransactionTable.tableName} ADD COLUMN ${TransactionTable.columnTags} TEXT',
      );
      await db.execute(
        'ALTER TABLE ${TransactionTable.tableName} ADD COLUMN ${TransactionTable.columnIsTransfer} INTEGER DEFAULT 0',
      );
      await db.execute(
        'ALTER TABLE ${TransactionTable.tableName} ADD COLUMN ${TransactionTable.columnIsRecurring} INTEGER DEFAULT 0',
      );
      await db.execute(
        'ALTER TABLE ${TransactionTable.tableName} ADD COLUMN ${TransactionTable.columnAttachments} TEXT',
      );
      await db.execute(
        'ALTER TABLE ${TransactionTable.tableName} ADD COLUMN ${TransactionTable.columnCreatedAt} INTEGER',
      );
      await db.execute(
        'ALTER TABLE ${TransactionTable.tableName} ADD COLUMN ${TransactionTable.columnUpdatedAt} INTEGER',
      );
      await db.execute(
        'ALTER TABLE ${TransactionTable.tableName} ADD COLUMN ${TransactionTable.columnAppliedRule} TEXT',
      );

      // Create transaction splits table
      await db.execute(TransactionSplitTable.createTableSQL);

      // Update existing records with default values
      await db.execute('''
UPDATE ${TransactionTable.tableName}
SET
${TransactionTable.columnCreatedAt} = ${TransactionTable.columnDateTime},
${TransactionTable.columnUpdatedAt} = ${TransactionTable.columnDateTime}
WHERE ${TransactionTable.columnCreatedAt} IS NULL
''');

      debugPrint('Migration to version 3 complete.');
    }

    if (oldVersion < 4) {
      debugPrint('Recreating transaction_splits table (empty table)');
      await db.execute(TransactionSplitTable.dropTableSQL);
      await db.execute(TransactionSplitTable.createTableSQL);
    }

    debugPrint('Database upgrade complete.');
  }
}
