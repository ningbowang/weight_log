import 'package:floor/floor.dart';

import '../entity/weight_record.dart';

@dao
abstract class WeightRecordDao {
  @Query('SELECT * FROM WeightRecord WHERE id = :id')
  Future<WeightRecord?> findWeightRecordById(int id);

  @Query('SELECT * FROM WeightRecord')
  Future<List<WeightRecord>> findAllWeightRecords();

  @Query('SELECT * FROM WeightRecord')
  Stream<List<WeightRecord>> findAllWeightRecordsAsStream();

  @insert
  Future<void> insertWeightRecord(WeightRecord weightRecord);

  @insert
  Future<void> insertWeightRecords(List<WeightRecord> weightRecords);

  @update
  Future<void> updateWeightRecord(WeightRecord weightRecord);

  @update
  Future<void> updateWeightRecords(List<WeightRecord> weightRecord);

  @delete
  Future<void> deleteWeightRecord(WeightRecord weightRecord);

  @delete
  Future<void> deleteWeightRecords(List<WeightRecord> weightRecords);
}