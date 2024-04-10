import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dao/weight_record_dao.dart';
import '../entity/weight_record.dart';

class WeightRecordTextFieldAdd extends StatelessWidget {
  final TextEditingController _textEditingController;
  final WeightRecordDao dao;
  WeightRecordTextFieldAdd({
    super.key,
    required this.dao,
  }) : _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.black12,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textEditingController,
              keyboardType: TextInputType.number,
              //设置键盘为数字
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9\\.]'))
                //设置只允许输入数字
              ],
              decoration: const InputDecoration(
                fillColor: Colors.transparent,
                filled: true,
                contentPadding: EdgeInsets.all(16),
                border: InputBorder.none,
                hintText: '请输入体重: ',
              ),
              onSubmitted: (_) async {
                await _persistMessage();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: OutlinedButton(
              child: const Text('保存'),
              onPressed: () async {
                await _persistMessage();
                FocusScope.of(context).requestFocus(FocusNode()); //保存后自动收起键盘
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _persistMessage() async {
    final message = _textEditingController.text;
    if (message.trim().isEmpty) {
      _textEditingController.clear();
    } else if (double.tryParse(message.trim()) == null) {
      _textEditingController.clear();
    } else {
      final weightRecord = WeightRecord.optional(
          weight: double.parse(message),
          createTimestamp: DateTime.now(),
          updateTimestamp: DateTime.now());
      await dao.insertWeightRecord(weightRecord);
      _textEditingController.clear();
    }
  }
}
