class TransactionTable {
  static const String tableName = "transactions";

  static const String columnId = 'id';
  static const String columnAmount = 'amount';
  static const String columnCategory = 'category';
  static const String columnType = 'type';
  static const String columnMerchantNote = 'merchant_note';
  static const String columnDateTime = 'date_time';

  // New Columns
  static const String columnAccount = 'account';
  static const String columnDescription = 'description';
  static const String columnTags = 'tags'; // JSON string
  static const String columnIsTransfer = 'is_transfer';
  static const String columnIsRecurring = 'is_recurring';
  static const String columnAttachments = 'attachments'; // JSON String
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';
  static const String columnAppliedRule = 'applied_rule';

  static const String createTableSQL =
      '''
CREATE TABLE $tableName(
  $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
  $columnAmount REAL NOT NULL,
  $columnCategory TEXT NOT NULL,
  $columnType TEXT NOT NULL,
  $columnMerchantNote TEXT,
  $columnDateTime INTEGER NOT NULL,
  $columnAccount TEXT,
  $columnDescription TEXT,
  $columnTags TEXT,
  $columnIsTransfer INTEGER DEFAULT 0,
  $columnIsRecurring INTEGER DEFAULT 0,
  $columnAttachments TEXT,
  $columnCreatedAt INTEGER,
  $columnUpdatedAt INTEGER,
  $columnAppliedRule TEXT
)
''';

  //This will:
  //Delete the existing table (if it exists).
  //Do nothing if the table doesn't exist (so no error).
  static const String dropTableSQL = 'DROP TABLE IF EXISTS $tableName';
}

// class TransactionTable {
//   static const String tableName = "transactions";

//   static const String columnId = 'id';
//   static const String columnAmount = 'amount';
//   static const String columnCategory = 'category';
//   static const String columnType = 'type';
//   static const String columnMerchantNote = 'merchant_note';
//   static const String columnDateTime = 'date_time';

//   static const String createTableSQL =
//       '''
// CREATE TABLE $tableName(
//   $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
//   $columnAmount REAL NOT NULL,
//   $columnCategory TEXT NOT NULL,
//   $columnType TEXT NOT NULL,
//   $columnMerchantNote TEXT,
//   $columnDateTime INTEGER NOT NULL
// )
// ''';

//   //This will:
//   //Delete the existing table (if it exists).
//   //Do nothing if the table doesn't exist (so no error).
//   static const String dropTableSQL = 'DROP TABLE IF EXISTS $tableName';
// }
