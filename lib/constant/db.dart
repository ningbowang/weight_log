const String dbName = 'weight_log_database.db';
const String dbTableWeightRecord = 'WeightRecord';
const String dbTableWeightRecordTemplate = 'CREATE TABLE IF NOT EXISTS `WeightRecord` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `weight` REAL NOT NULL, `create_timestamp` INTEGER NOT NULL, `update_timestamp` INTEGER NOT NULL)';
// const String dbExportPath = '/storage/emulated/0/Download';
