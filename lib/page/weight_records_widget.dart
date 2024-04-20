import 'package:flutter/material.dart';
import 'package:weight_log/widget/weight_record_text_field_del.dart';
import 'package:weight_log/widget/weight_record_text_field_update.dart';

import '../dao/weight_record_dao.dart';
import '../db/database.dart';
import '../entity/weight_record.dart';
import '../widget/datetime_picker.dart';
import '../widget/weight_record_text_field_add.dart';

class WeightRecordsWidget extends StatefulWidget {
  final WeightLogDatabase db;

  const WeightRecordsWidget({super.key, required this.db});

  @override
  State<StatefulWidget> createState() {
    return WeightRecordsWidgetState();
  }
}

class WeightRecordsWidgetState extends State<WeightRecordsWidget> {
  @override
  Widget build(BuildContext context) {
    WeightRecordDao weightRecordDao = widget.db.weightRecordDao;
    return Container(
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.all(0),
      child: Scaffold(
        // appBar: AppBar(
        //   // title: const Text('体重记录'),
        //   centerTitle: true,
        // ),

        body: SafeArea(
          child: Column(
            children: <Widget>[
              WeightRecordListView(dao: weightRecordDao), //体重列表
              WeightRecordTextFieldAdd(dao: weightRecordDao) //体重输入框
            ],
          ),
        ),
      ),
    );
  }
}

class WeightRecordListView extends StatelessWidget {
  final WeightRecordDao dao;

  const WeightRecordListView({super.key, required this.dao});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: StreamBuilder<List<WeightRecord>>(
        stream: dao.findAllWeightRecordsAsStream(),
        builder: (BuildContext context, AsyncSnapshot<List<WeightRecord>> snapshot) {
          if (!snapshot.hasData) return Container();
          final weightRecords = snapshot.requireData;
          weightRecords.sort((a, b) => b.createTimestamp.compareTo(a.createTimestamp)); //按时间倒序
          return ListView.builder(
              itemCount: weightRecords.length,
              itemBuilder: (_, index) {
                return WeightRecordCell(
                    weightRecord: weightRecords[index], dao: dao);
              });
        },
    ));
  }
}

class WeightRecordCell extends StatelessWidget {
  final WeightRecord weightRecord;
  final WeightRecordDao dao;

  const WeightRecordCell({
    super.key,
    required this.weightRecord,
    required this.dao,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 1, 0, 1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFd5dced), // 边框颜色
          width: 0.5, // 边框宽度
        ),
      ),
      child: Row(
        children: [
          Expanded(
              child: GestureDetector(
                onTap: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => Dialog(
                    // backgroundColor: Colors.white,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            WeightRecordTextFieldUpdate(dao: dao, weightRecord: weightRecord),
                            const SizedBox(height: 100,),
                            WeightRecordTextFieldDel(dao: dao, weightRecord: weightRecord),
                            // TextButton(
                            //   onPressed: () {
                            //     Navigator.pop(context);
                            //   },
                            //   child: const Text('Close'),
                            // ),
                          ],
                        ),
                      )),
                  child: Container(
                      // margin: const EdgeInsets.fromLTRB(0, 1, 0, 1),
                      // color: Colors.green[100],
                      alignment: Alignment.centerLeft,
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 2, 0, 2),
                        child: Text(
                          '${weightRecord.weight.toStringAsFixed(2)} kg',
                          style: const TextStyle(fontSize: 13),
                        ),
                      )),
            )),
          Expanded(
              child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 1, 0, 1),
                  // color: Colors.green[100],
                  alignment: Alignment.centerRight,
                  height: 40,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 2, 16, 2),
                    child:
                      DatetimePicker(weightRecord: weightRecord, dao: dao)
                  )
              )
          )
        ],
      ),
    );
  }
}
