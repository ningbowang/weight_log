import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dao/weight_record_dao.dart';
import '../entity/weight_record.dart';

class WeightRecordTextFieldUpdate extends StatefulWidget {
  final WeightRecordDao dao;
  //要修改的体重记录
  final WeightRecord weightRecord;

  const WeightRecordTextFieldUpdate({
    super.key,
    required this.dao,
    required this.weightRecord,
  });

  @override
  State<StatefulWidget> createState() {
    return WeightRecordTextFieldUpdateState();
  }
}

class WeightRecordTextFieldUpdateState extends State<WeightRecordTextFieldUpdate> {
  late WeightRecordDao dao;
  late WeightRecord weightRecord;//要修改的体重记录
  late TextEditingController _textEditingController;
  late String _hintText;

  @override
  void initState() {
    dao = widget.dao;
    weightRecord = widget.weightRecord;
    _textEditingController = TextEditingController();
    _hintText = '${weightRecord.weight}';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: _textEditingController,
            keyboardType: TextInputType.number,
            autofocus: true,
            //设置键盘为数字
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9\\.]'))
              //设置只允许输入数字
            ],
            decoration: InputDecoration(
              fillColor: Colors.transparent,
              filled: true,
              contentPadding: const EdgeInsets.all(16),
              border: InputBorder.none,
              hintText: _hintText,
            ),
            onSubmitted: (_) async {
              String newHintText = '';
              await _persistMessage(weightRecord);

            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: OutlinedButton(
            child: const Text('保存'),
            onPressed: () async {
              await _persistMessage(weightRecord);

            },
          ),
        ),
      ],
    );
  }

  Future<void> _persistMessage(WeightRecord weightRecord) async {
    final message = _textEditingController.text;
    if (message.trim().isEmpty) {
      _textEditingController.clear();
    } else if (double.tryParse(message.trim()) == null) {
      _textEditingController.clear();
    } else {
      final newWeightRecord = WeightRecord.optional(
          id: weightRecord.id,
          weight: double.parse(message),
          createTimestamp: weightRecord.createTimestamp,
          updateTimestamp: weightRecord.updateTimestamp);
      await dao.updateWeightRecord(newWeightRecord);
      setState((){//设置
        _hintText = message;
      });
      _textEditingController.clear();
      Navigator.pop(context); // 退出弹窗
      FocusScope.of(context).requestFocus(FocusNode()); //保存后自动收起键盘
    }
  }

}
