import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// Flutter code sample for [Dialog].

void main() => runApp(const PanningExampleApp());

class PanningExampleApp extends StatelessWidget {
  const PanningExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Dialog Sample')),
        body: const Center(
          child: PanningExample(),
        ),
      ),
    );
  }
}

class PanningExample extends StatefulWidget {
  const PanningExample({super.key});

  @override
  State<PanningExample> createState() => _PanningExampleState();
}

class _PanningExampleState extends State<PanningExample> {
  late ZoomPanBehavior _zoomPanBehavior;
  List<ChartData> datasource = [
    // Bind data source
    // ChartData(DateTime.parse('20240101'), 35),
    // ChartData(DateTime.parse('20240102'), 28),
    // ChartData(DateTime.parse('20240103'), 34),
    // ChartData(DateTime.parse('20240104'), 32),
    // ChartData(DateTime.parse('20240105'), 40),
    // ChartData(DateTime.parse('20240106'), 35),
    // ChartData(DateTime.parse('20240107'), 28),
    ChartData(1, 35),
    ChartData(2, 28),
    ChartData(3, 34),
    ChartData(4, 32),
    ChartData(5, 40),
    ChartData(6, 35),
    ChartData(7, 28),
  ];

  @override
  void initState() {
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      zoomMode: ZoomMode.x,
      enablePanning: true,
    );
    super.initState();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       body: SafeArea(
  //           child: Center(
  //               child: Container(
  //                   child: SfCartesianChart(
  //                       zoomPanBehavior: _zoomPanBehavior,
  //                       // Initialize category axis
  //                       primaryXAxis: const DateTimeAxis(
  //                           enableAutoIntervalOnZooming: false
  //                       ),
  //                       series: <CartesianSeries>[
  //                         // Initialize line series
  //                         LineSeries<ChartData, DateTime>(
  //                             dataSource: datasource,
  //                             xValueMapper: (ChartData data, _) => data.x,
  //                             yValueMapper: (ChartData data, _) => data.y
  //                         )
  //                       ]
  //                   )
  //               )
  //           )
  //       )
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Container(
        child: SfCartesianChart(
      loadMoreIndicatorBuilder: (BuildContext context, ChartSwipeDirection direction) => getLoadMoreViewBuilder(context, direction),
      series: <CartesianSeries<ChartData, num>>[
        LineSeries<ChartData, num>(dataSource: datasource, xValueMapper: (ChartData data, _) => data.x, yValueMapper: (ChartData data, _) => data.y),
      ],
    ));
  }

  Future<List<ChartData>> _updateData() {
    // return [
    //   ChartData(DateTime.parse('20240108'), 34),
    //   ChartData(DateTime.parse('20240109'), 32),
    //   ChartData(DateTime.parse('20240110'), 40),
    //   ChartData(DateTime.parse('20240111'), 35),
    //   ChartData(DateTime.parse('20240112'), 28),
    //   ChartData(DateTime.parse('20240113'), 34),
    //   ChartData(DateTime.parse('20240114'), 32),
    //   ChartData(DateTime.parse('20240115'), 40),
    // ];
    datasource.addAll([
      ChartData(8, 34),
      ChartData(9, 32),
      ChartData(10, 40),
      ChartData(11, 35),
      ChartData(12, 28),
      ChartData(13, 34),
      ChartData(14, 32),
      ChartData(15, 40),
    ]);
    return Future.value([
      ChartData(8, 34),
      ChartData(9, 32),
      ChartData(10, 40),
      ChartData(11, 35),
      ChartData(12, 28),
      ChartData(13, 34),
      ChartData(14, 32),
      ChartData(15, 40),
    ]);
  }

  Widget getLoadMoreViewBuilder(BuildContext context, ChartSwipeDirection direction) {
    if (direction == ChartSwipeDirection.end) {
      return FutureBuilder<List<ChartData>>(
        future: _updateData(),

        /// Adding data by updateDataSource method
        builder: (BuildContext futureContext, AsyncSnapshot<List<ChartData>> snapShot) {
          return snapShot.connectionState != ConnectionState.done ? const CircularProgressIndicator() : SizedBox.fromSize(size: Size.zero);
        },
      );
    } else {
      return SizedBox.fromSize(size: Size.zero);
    }
  }
}

class ChartData {
  ChartData(this.x, this.y);

  final double x;
  final double? y;
}
