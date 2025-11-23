class TransactionTable {
  static const String tableName = "transactions";

  static const String columnId = 'id';
  static const String columnAmount = 'amount';
  static const String columnCategory = 'category';
  static const String columnType = 'type';
  static const String columnMerchantNote = 'merchant_note';
  static const String columnDateTime = 'date_time';

  static const String createTableSQL =
      '''
CREATE TABLE $tableName(
  $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
  $columnAmount REAL NOT NULL,
  $columnCategory TEXT NOT NULL,
  $columnType TEXT NOT NULL,
  $columnMerchantNote TEXT,
  $columnDateTime INTEGER NOT NULL
)
''';

  //This will:
  //Delete the existing table (if it exists).
  //Do nothing if the table doesn't exist (so no error).
  static const String dropTableSQL = 'DROP TABLE IF EXISTS $tableName';
}
