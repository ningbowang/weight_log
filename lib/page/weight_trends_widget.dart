import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../db/database.dart';
import '../entity/weight_record.dart';

class WeightTrendsWidget extends StatelessWidget {
  final WeightLogDatabase db;

  const WeightTrendsWidget({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _WeightTrendsWidgetPage(db: db),
      ),
    );
  }
}

class _WeightTrendsWidgetPage extends StatefulWidget {
  final WeightLogDatabase db;

  const _WeightTrendsWidgetPage({super.key, required this.db});

  @override
  State<StatefulWidget> createState() {
    return _WeightTrendsWidgetPageState();
  }
}

class _WeightTrendsWidgetPageState extends State<_WeightTrendsWidgetPage> {
  List<WeightRecord> axisX = [];
  List<WeightRecord> amRecords = [];
  List<WeightRecord> pmRecords = [];

  late TooltipBehavior _tooltipBehavior;
  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      zoomMode: ZoomMode.x,
      enablePanning: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: weightRecordList,
        builder: (BuildContext context, AsyncSnapshot<List<WeightRecord>> snapshot) {
          if (!snapshot.hasData) return Container();
          List<WeightRecord> records = snapshot.requireData;
          separationOfAmAndPm(records);
          // sortRecords();
          sortDate(amRecords);
          sortDate(pmRecords);
          return SfCartesianChart(
            // title: const ChartTitle(text: '趋势'),
            //图例: 线的样式是什么样的
            legend: const Legend(isVisible: true),
            tooltipBehavior: _tooltipBehavior,
            zoomPanBehavior: _zoomPanBehavior,
            primaryXAxis: CategoryAxis(//x轴缩放
                // initialZoomFactor: 0.9, //初始缩放, 越小,放大越大
                // initialZoomPosition: 1,//初始缩放
                // interval: 10,  //x轴坐标点间隔
                // initialVisibleMinimum 和 initialVisibleMaximum 控制一屏显示多少个点, 是用数据数组的索引控制的
                initialVisibleMinimum: amRecords.length > pmRecords.length ? amRecords.length.toDouble()-10 : pmRecords.length.toDouble()-10, //数据数组, 可见点的起始索引
                initialVisibleMaximum: amRecords.length > pmRecords.length ? amRecords.length.toDouble()-1 : pmRecords.length.toDouble()-1, //数据数组, 可见点的末尾索引
            ),
            primaryYAxis: NumericAxis(   //y轴固定高度
              minimum: getAxisYRange(records)[0],
              maximum: getAxisYRange(records)[1],
            ),
            series: <CartesianSeries>[
              LineSeries<WeightRecord, String>( //重要: 该组坐标是构造出来的, 控制产生有序x轴
                dataSource: toGenerateAxisX(records),
                xValueMapper: (WeightRecord weightRecord, _) => '${weightRecord.createTimestamp.month}-${weightRecord.createTimestamp.day}',
                yValueMapper: (WeightRecord weightRecord, _) => weightRecord.weight,
                dataLabelSettings: const DataLabelSettings(isVisible: false),
                isVisibleInLegend: false, //禁止显示该数据的Legend
              ),
              LineSeries<WeightRecord, String>(
                dataSource: amRecords,
                xValueMapper: (WeightRecord weightRecord, _) => '${weightRecord.createTimestamp.month}-${weightRecord.createTimestamp.day}',
                yValueMapper: (WeightRecord weightRecord, _) => weightRecord.weight,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                markerSettings: const MarkerSettings(
                  isVisible: true, // 启用数据点标记
                  shape: DataMarkerType.circle, // 设置标记形状为圆圈
                  width: 5, // 设置标记宽度
                  height: 5, // 设置标记高度
                ),
                name: '上午', // 配合 图例 使用
              ),
              LineSeries<WeightRecord, String>(
                dataSource: pmRecords,
                xValueMapper: (WeightRecord weightRecord, _) => '${weightRecord.createTimestamp.month}-${weightRecord.createTimestamp.day}',
                yValueMapper: (WeightRecord weightRecord, _) => weightRecord.weight,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                markerSettings: const MarkerSettings(
                  isVisible: true, // 启用数据点标记
                  shape: DataMarkerType.circle, // 设置标记形状为圆圈
                  width: 5, // 设置标记宽度
                  height: 5, // 设置标记高度
                ),
                name: '下午', // 配合 图例 使用
              )
            ],
          );
        }
    );
  }

  Future<List<WeightRecord>> get weightRecordList async {
    return widget.db.weightRecordDao.findAllWeightRecords();
  }

  // 分离上午 和 下午的体重数据
  void separationOfAmAndPm(List<WeightRecord> weightRecords) {
    for (var value in weightRecords) {
      DateTime moment = value.createTimestamp;
      String date = '${moment.year.toString().padLeft(2, '0')}-${moment.month.toString().padLeft(2, '0')}-${moment.day.toString().padLeft(2, '0')}';
      DateTime date000000 = DateTime.parse('$date 00:00:00');
      DateTime date120000 = DateTime.parse('$date 12:00:00');
      DateTime date235959 = DateTime.parse('$date 23:59:59');

      // 上午: 00:00:00 <= 该时间点 < 12:00:00
      if ((moment.isAtSameMomentAs(date000000) || moment.isAfter(date000000)) && moment.isBefore(date120000)) {
        amRecords.add(value);
        // 下午: 12:00:00 <= 该时间点 <= 23:59:59
      } else if ((moment.isAtSameMomentAs(date120000) || moment.isAfter(date120000)) && (moment.isAtSameMomentAs(date235959) || moment.isBefore(date235959))) {
        pmRecords.add(value);
      } else {
        if (kDebugMode) {
          print(Error());
        }
      }
    }
  }

  void sortDate(List<WeightRecord> weightRecords) {
    weightRecords.sort((a, b) => a.createTimestamp.compareTo(b.createTimestamp));
  }

  // 构造一组空数据, 用来渲染横坐标, 避免坐标轴时间乱序. 坐标轴按时间升序
  List<WeightRecord> toGenerateAxisX(List<WeightRecord> weightRecords) {
    List<WeightRecord> lists = [];
    for (var weightRecord in weightRecords) {
      DateTime dateForAxis = getDate(weightRecord.createTimestamp);
      lists.add(WeightRecord(id: null, weight: double.nan, createTimestamp: dateForAxis, updateTimestamp: dateForAxis));
    }
    sortDate(lists);
    // axisX =
    return lists.toSet().toList();
  }

  DateTime getDate(DateTime dateTime) {
    String dataStr = '${dateTime.year.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    return DateTime.parse(dataStr);
  }

  // 获取体重最小值和最大值
  List<double> getAxisYRange(List<WeightRecord> records) {
    List<double> minAndMax = [];
    if(records.isEmpty) { //未记录体重时
      minAndMax..add(0)..add(0);
      return minAndMax;
    }
    double min = records.first.weight;
    double max = records.first.weight;
    for (var record in records) {
      var weight = record.weight;
      if(weight < min) {
        min = weight;
      }
      if(weight > max) {
        max = weight;
      }
    }
    minAndMax.add(min-5);//Y轴最小值
    minAndMax.add(max+3);//Y轴最大值
    return minAndMax;
  }
}
