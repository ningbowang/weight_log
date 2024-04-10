import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../db/database.dart';
import '../entity/weight_record.dart';

class PersonalInfo extends StatefulWidget {
  final WeightLogDatabase db;

  const PersonalInfo({super.key, required this.db});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  // @override
  // void initState() {
  //   Permission.storage.request();
  //   // requestPermission();
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        FutureBuilder(
          future: weightRecordListFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            List<WeightRecord> records = snapshot.requireData;

            return Text(records.toString()); // todo 做两个按钮, 一个导出一个导入
          },
        ),
      ],
    ));
  }

  Future<List<WeightRecord>> get weightRecordListFuture async {
    return widget.db.weightRecordDao.findAllWeightRecords();
  }

  // 导出数据库
  Future<void> exportTableToCsv(String tableName) async {
    // 获取数据库路径
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'weight_log_database.db');

    print(await getExternalStorageDirectory());
    print(await getExternalCacheDirectories());
    print(await getExternalStorageDirectories());
    print(await getDownloadsDirectory());
    // // 打开数据库
    // Database database = await openDatabase(dbPath);
    //
    // // 查询表数据
    // List<Map<String, dynamic>> rows = await database.query(tableName);
    //
    // // 创建CSV文件
    // File file = File(join(databasesPath, '${tableName}_export.csv'));
    // if (await file.exists()) {
    //   await file.delete();
    // }
    // await file.create();
    //
    // // 写入数据到CSV文件
    // String csv = '';
    // csv += rows[0].keys.join(',') + '\n';
    // for (var row in rows) {
    //   csv += row.values.join(',') + '\n';
    // }
    // await file.writeAsString(csv);
    //
    // // 关闭数据库
    // await database.close();
  }


  // 导入数据库
  Future<void> importTableFromCsv(String tableName, String csvFilePath) async {
    // 获取数据库路径
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'your_database.db');

    // 打开数据库
    Database database = await openDatabase(dbPath);

    // 删除原先的表
    await database.execute('DROP TABLE IF EXISTS $tableName');

    // 创建新表
    await database.execute('CREATE TABLE $tableName (...)'); // 请根据需要替换...

    // 读取CSV文件内容
    File file = File(csvFilePath);
    String csv = await file.readAsString();

    // 解析CSV文件内容
    List<String> lines = csv.split('\n');
    List<String> columnNames = lines[0].split(',');

    // 插入数据到表
    for (int i = 1; i < lines.length; i++) {
      List<String> row = lines[i].split(',');
      Map<String, dynamic> rowData = {};
      for (int j = 0; j < columnNames.length; j++) {
        rowData[columnNames[j]] = row[j];
      }
      await database.insert(tableName, rowData);
    }

    // 关闭数据库
    await database.close();
  }
}
