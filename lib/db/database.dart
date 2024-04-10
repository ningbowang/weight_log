import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:weight_log/converter/type_converter.dart';
import 'package:weight_log/dao/weight_record_dao.dart';

import '../entity/weight_record.dart';

part 'database.g.dart';

@Database(version: 1, entities: [WeightRecord])
@TypeConverters([DateTimeConverter, ])
abstract class WeightLogDatabase extends FloorDatabase {
  WeightRecordDao get weightRecordDao;
}
