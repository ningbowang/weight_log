import 'package:floor/floor.dart';
// @Entity(tableName: 'weight_record')
@entity
class WeightRecord {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final double weight;

  //体重属于哪一天
  @ColumnInfo(name: 'create_timestamp')
  final DateTime createTimestamp;

  @ColumnInfo(name: 'update_timestamp')
  final DateTime updateTimestamp;

  WeightRecord({
    required this.id,
    required this.weight,
    required this.createTimestamp,
    required this.updateTimestamp

  });

  factory WeightRecord.optional({
    int? id,
    required double weight,
    required DateTime createTimestamp,
    DateTime? updateTimestamp,
  }) =>
      WeightRecord(
          id: id,
          weight: weight,
          createTimestamp: createTimestamp,
          updateTimestamp: updateTimestamp ?? DateTime.now()
      );

  @override
  String toString() {
    return 'WeightLog{id: $id, weight: $weight, createTimestamp: $createTimestamp, updateTimestamp: $updateTimestamp}';
  }
}