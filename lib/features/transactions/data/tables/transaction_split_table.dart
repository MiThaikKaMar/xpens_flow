class TransactionSplitTable {
  static const String tableName = "transaction_splits";

  static const String columnId = 'id';
  static const String columnTransactionId = 'transaction_id';
  static const String columnCategory = 'category';
  static const String columnAmount = 'amount';
  static const String columnNote = 'note';

  static const String createTableSQL =
      '''
CREATE TABLE $tableName(
  $columnId TEXT PRIMARY KEY,
  $columnTransactionId INTEGER NOT NULL,
  $columnCategory TEXT NOT NULL,
  $columnAmount REAL NOT NULL,
  $columnNote TEXT,
  FOREIGN KEY ($columnTransactionId) REFERENCES transactions(id) ON DELETE CASCADE
)
''';

  static const String dropTableSQL = 'DROP TABLE IF EXISTS $tableName';
}
