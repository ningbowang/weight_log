// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorWeightLogDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$WeightLogDatabaseBuilder databaseBuilder(String name) =>
      _$WeightLogDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$WeightLogDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$WeightLogDatabaseBuilder(null);
}

class _$WeightLogDatabaseBuilder {
  _$WeightLogDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$WeightLogDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$WeightLogDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<WeightLogDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$WeightLogDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$WeightLogDatabase extends WeightLogDatabase {
  _$WeightLogDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  WeightRecordDao? _weightRecordDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `WeightRecord` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `weight` REAL NOT NULL, `create_timestamp` INTEGER NOT NULL, `update_timestamp` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  WeightRecordDao get weightRecordDao {
    return _weightRecordDaoInstance ??=
        _$WeightRecordDao(database, changeListener);
  }
}

class _$WeightRecordDao extends WeightRecordDao {
  _$WeightRecordDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _weightRecordInsertionAdapter = InsertionAdapter(
            database,
            'WeightRecord',
            (WeightRecord item) => <String, Object?>{
                  'id': item.id,
                  'weight': item.weight,
                  'create_timestamp':
                      _dateTimeConverter.encode(item.createTimestamp),
                  'update_timestamp':
                      _dateTimeConverter.encode(item.updateTimestamp)
                },
            changeListener),
        _weightRecordUpdateAdapter = UpdateAdapter(
            database,
            'WeightRecord',
            ['id'],
            (WeightRecord item) => <String, Object?>{
                  'id': item.id,
                  'weight': item.weight,
                  'create_timestamp':
                      _dateTimeConverter.encode(item.createTimestamp),
                  'update_timestamp':
                      _dateTimeConverter.encode(item.updateTimestamp)
                },
            changeListener),
        _weightRecordDeletionAdapter = DeletionAdapter(
            database,
            'WeightRecord',
            ['id'],
            (WeightRecord item) => <String, Object?>{
                  'id': item.id,
                  'weight': item.weight,
                  'create_timestamp':
                      _dateTimeConverter.encode(item.createTimestamp),
                  'update_timestamp':
                      _dateTimeConverter.encode(item.updateTimestamp)
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<WeightRecord> _weightRecordInsertionAdapter;

  final UpdateAdapter<WeightRecord> _weightRecordUpdateAdapter;

  final DeletionAdapter<WeightRecord> _weightRecordDeletionAdapter;

  @override
  Future<WeightRecord?> findWeightRecordById(int id) async {
    return _queryAdapter.query('SELECT * FROM WeightRecord WHERE id = ?1',
        mapper: (Map<String, Object?> row) => WeightRecord(
            id: row['id'] as int?,
            weight: row['weight'] as double,
            createTimestamp:
                _dateTimeConverter.decode(row['create_timestamp'] as int),
            updateTimestamp:
                _dateTimeConverter.decode(row['update_timestamp'] as int)),
        arguments: [id]);
  }

  @override
  Future<List<WeightRecord>> findAllWeightRecords() async {
    return _queryAdapter.queryList('SELECT * FROM WeightRecord',
        mapper: (Map<String, Object?> row) => WeightRecord(
            id: row['id'] as int?,
            weight: row['weight'] as double,
            createTimestamp:
                _dateTimeConverter.decode(row['create_timestamp'] as int),
            updateTimestamp:
                _dateTimeConverter.decode(row['update_timestamp'] as int)));
  }

  @override
  Stream<List<WeightRecord>> findAllWeightRecordsAsStream() {
    return _queryAdapter.queryListStream('SELECT * FROM WeightRecord',
        mapper: (Map<String, Object?> row) => WeightRecord(
            id: row['id'] as int?,
            weight: row['weight'] as double,
            createTimestamp:
                _dateTimeConverter.decode(row['create_timestamp'] as int),
            updateTimestamp:
                _dateTimeConverter.decode(row['update_timestamp'] as int)),
        queryableName: 'WeightRecord',
        isView: false);
  }

  @override
  Future<void> insertWeightRecord(WeightRecord weightRecord) async {
    await _weightRecordInsertionAdapter.insert(
        weightRecord, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertWeightRecords(List<WeightRecord> weightRecords) async {
    await _weightRecordInsertionAdapter.insertList(
        weightRecords, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateWeightRecord(WeightRecord weightRecord) async {
    await _weightRecordUpdateAdapter.update(
        weightRecord, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateWeightRecords(List<WeightRecord> weightRecord) async {
    await _weightRecordUpdateAdapter.updateList(
        weightRecord, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteWeightRecord(WeightRecord weightRecord) async {
    await _weightRecordDeletionAdapter.delete(weightRecord);
  }

  @override
  Future<void> deleteWeightRecords(List<WeightRecord> weightRecords) async {
    await _weightRecordDeletionAdapter.deleteList(weightRecords);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
