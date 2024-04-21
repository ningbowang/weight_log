import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../constant/db.dart';
import '../db/database.dart';
import '../entity/weight_record.dart';

class PersonalInfo extends StatefulWidget {
  final WeightLogDatabase db;

  const PersonalInfo({super.key, required this.db});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final _dialogTitleController = TextEditingController();
  final _initialDirectoryController = TextEditingController();
  bool _isLoading = false;
  String? _directoryPath;
  String? _fileName;
  List<PlatformFile>? _paths;
  String? _saveAsFileName;
  bool _userAborted = false;
  final bool _lockParentWindow = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
          future: weightRecordListFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            List<WeightRecord> records = snapshot.requireData;
            return Column(
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(width: 1.0, color: Color(0xFFced0d6)),
                      ),
                      child: const Text('导出数据'),
                      onPressed: () async {
                        await _selectFolder();
                        await exportTableToCsv(dbTableWeightRecord)
                            .then((value) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Center(
                                    child: Text('导出成功!'),
                                  ),
                                  duration: Duration(milliseconds: 2000),
                                  backgroundColor: Colors.green,
                                )))
                            .catchError((err) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Center(child: Text('导出失败!')), duration: Duration(milliseconds: 3000), backgroundColor: Colors.red));
                          return err;
                        });
                      },
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(width: 1.0, color: Color(0xFFced0d6)),
                      ),
                      child: const Text('导入数据'),
                      //导入数据库
                      onPressed: () async {
                        // String latestExportedFile = await getLatestExportedFile();
                        String exportToFile = await pickBackupFilePath();
                        await importTableFromCsv(dbTableWeightRecord, exportToFile)
                            .then((value) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Center(
                                    child: Text('导入成功!'),
                                  ),
                                  duration: Duration(milliseconds: 2000),
                                  backgroundColor: Colors.green,
                                )))
                            .catchError((err) {
                          if (kDebugMode) {
                            print(err);
                          }
                          if (exportToFile == '不存在已导出的数据') {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Center(child: Text('导入失败, 请先导出数据')), duration: Duration(milliseconds: 5000), backgroundColor: Colors.red));
                            return err;
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Center(child: Text('导入失败')), duration: Duration(milliseconds: 5000), backgroundColor: Colors.red));
                            return err;
                          }
                        });
                      },
                    )
                  ],
                )
              ],
            );
          },
        ),
      ],
    );
  }

  Future<List<WeightRecord>> get weightRecordListFuture async {
    return widget.db.weightRecordDao.findAllWeightRecords();
  }

  // 导出数据库
  Future<void> exportTableToCsv(String tableName) async {
    // 获取数据库路径
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, dbName);

    // 打开数据库
    Database database = await openDatabase(dbPath);

    // 查询表数据
    List<Map<String, dynamic>> rows = await database.query(tableName);

    // 创建CSV文件
    File file = File(join(_directoryPath!, '${tableName}_export_${DateTime.now().microsecondsSinceEpoch}.csv'));
    if (await file.exists()) {
      await file.delete();
    }
    await file.create();

    // 写入数据到CSV文件
    String csv = '';
    if (rows.isEmpty) {
      await file.writeAsString(csv);
      return;
    }
    csv += '${rows[0].keys.join(',')}\n';
    for (int i = 0; i < rows.length - 1; i++) {
      csv += '${rows[i].values.join(',')}\n';
    }
    csv += rows.last.values.join(',');
    await file.writeAsString(csv);

    // 关闭数据库; 别关, 关了程序的数据就断了
    // await database.close();
  }

  // 导入数据库
  Future<void> importTableFromCsv(String tableName, String csvFilePath) async {
    // 获取数据库路径
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, dbName);

    // 打开数据库
    Database database = await openDatabase(dbPath);

    // 删除原先的表
    await database.execute('DROP TABLE IF EXISTS $tableName');

    // 创建新表, 变动字段这里也要改
    await database.execute(dbTableWeightRecordTemplate);

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

    // // 关闭数据库
    // await database.close();
  }

  // 获取最新的数据库导出文件
  // Future<String> getLatestExportedFile() async {
  //   DateTime latest = DateTime(1970, 1, 1, 0, 0, 0, 0, 0);
  //   String latestFile = '不存在已导出的数据';
  //   Directory dir = Directory(dbExportPath);
  //   List<FileSystemEntity> files = dir.listSync();
  //   for (FileSystemEntity file in files) {
  //     String curTimestamp = file.path.split('_export_')[1].split('.')[0];
  //     DateTime curPath = DateTime.fromMicrosecondsSinceEpoch(int.parse(curTimestamp));
  //     if (curPath.isAfter(latest)) {
  //       latest = curPath;
  //       latestFile = file.path;
  //     }
  //   }
  //   ;
  //   return latestFile;
  // }

  Future<String> pickBackupFilePath() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      return file.path;
    } else {
      // User canceled the picker
      throw '文件选择失败';
    }
  }

  Future<void> _selectFolder() async {
    _resetState();
    try {
      String? path = await FilePicker.platform.getDirectoryPath(
        dialogTitle: _dialogTitleController.text,
        initialDirectory: _initialDirectoryController.text,
        lockParentWindow: _lockParentWindow,
      );
      setState(() {
        _directoryPath = path;
        _userAborted = path == null;
      });
    } on PlatformException catch (e) {
      _logException('Unsupported operation$e');
    } catch (e) {
      _logException(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _logException(String message) {
    if (kDebugMode) {
      print(message);
    }
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      _directoryPath = null;
      _fileName = null;
      _paths = null;
      _saveAsFileName = null;
      _userAborted = false;
    });
  }
}
