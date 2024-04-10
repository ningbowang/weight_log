import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dao/weight_record_dao.dart';
import '../entity/weight_record.dart';

class WeightRecordTextFieldDel extends StatefulWidget {
  final WeightRecordDao dao;
  //要删除的体重记录
  final WeightRecord weightRecord;

  const WeightRecordTextFieldDel({
    super.key,
    required this.dao,
    required this.weightRecord,
  });

  @override
  State<StatefulWidget> createState() {
    return WeightRecordTextFieldDelState();
  }
}

class WeightRecordTextFieldDelState extends State<WeightRecordTextFieldDel> {
  late WeightRecordDao dao;
  late WeightRecord weightRecord;//要修改的体重记录

  @override
  void initState() {
    dao = widget.dao;
    weightRecord = widget.weightRecord;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          height: 30,
          width: 130,
          margin: const EdgeInsets.all(8),
          child: OutlinedButton(
            child: const Text('删除本条记录'),
            onPressed: () async {
              await _del(weightRecord);
              Navigator.pop(context);
              FocusScope.of(context).requestFocus(FocusNode()); //保存后自动收起键盘
            },
          ),
        ),
      ],
    );
  }

  Future<void> _del(WeightRecord weightRecord) async {
    final newWeightRecord = WeightRecord.optional(
        id: weightRecord.id,
        weight: weightRecord.weight,
        createTimestamp: weightRecord.createTimestamp,
        updateTimestamp: weightRecord.updateTimestamp);
    await dao.deleteWeightRecord(newWeightRecord);
  }

}
