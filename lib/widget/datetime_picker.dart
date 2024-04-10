import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:intl/intl.dart';
import 'package:weight_log/entity/weight_record.dart';

import '../dao/weight_record_dao.dart';
import '../db/database.dart';

// void main() => runApp(MyApp());

class CustomPicker extends picker.CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({DateTime? currentTime, picker.LocaleType? locale})
      : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    setLeftIndex(this.currentTime.hour);
    setMiddleIndex(this.currentTime.minute);
    setRightIndex(this.currentTime.second);
  }

  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return "|";
  }

  @override
  String rightDivider() {
    return "|";
  }

  @override
  List<int> layoutProportions() {
    return [1, 2, 1];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            currentLeftIndex(),
            currentMiddleIndex(),
            currentRightIndex())
        : DateTime(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            currentLeftIndex(),
            currentMiddleIndex(),
            currentRightIndex());
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const DatetimePicker(),
//     );
//   }
// }

class DatetimePicker extends StatefulWidget {
  final WeightRecord weightRecord;
  final WeightRecordDao dao;
  const DatetimePicker({super.key, required this.weightRecord, required this.dao});

  @override
  State<StatefulWidget> createState() {
    return DatetimePickerState();
  }
}

class DatetimePickerState extends State<DatetimePicker> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        picker.DatePicker.showDateTimePicker(context,
            showTitleActions: true,
            minTime: DateTime(1998, 1, 9, 5, 50),
            maxTime: DateTime.now(),
            onChanged: (date) {
              // print('change $date in time zone ${date.timeZoneOffset.inHours}');
            },
            onConfirm: (date) async {
              // print('confirm $date');
              final newWeightRecord = WeightRecord.optional(
                  id: widget.weightRecord.id,
                  weight: widget.weightRecord.weight,
                  createTimestamp: date,
                  updateTimestamp: widget.weightRecord.updateTimestamp);
              await widget.dao.updateWeightRecord(newWeightRecord);
            },
            locale: picker.LocaleType.zh);
      },
      child: Text(DateFormat('yyyy-MM-dd HH:mm:ss')
          .format(widget.weightRecord.createTimestamp),
          style: const TextStyle(fontSize: 13)
      ),
    );
  }
}
