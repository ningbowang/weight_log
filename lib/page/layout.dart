import 'package:flutter/material.dart';
import 'package:weight_log/page/personal_info_widget.dart';
import 'package:weight_log/page/weight_records_widget.dart';
import 'package:weight_log/page/weight_trends_widget.dart';

import '../db/database.dart';

class Layout extends StatefulWidget {
  final String title;
  final WeightLogDatabase db;

  const Layout({super.key, required this.title, required this.db});

  @override
  State<Layout> createState() => _NavigationState();
}

class _NavigationState extends State<Layout> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    WeightLogDatabase db = widget.db;

    final ThemeData theme = Theme.of(context);
    return Scaffold(
      // backgroundColor: Colors.red,
      bottomNavigationBar: NavigationBar(
        height: 70,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            // selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.history),
            label: '记录',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_graph_rounded),
            label: '趋势',
          ),
          // NavigationDestination(
          //   icon: Icon(Icons.person),
          //   label: '个人数据',
          // ),
        ],
      ),
      body: <Widget>[
        /// 记录 page
        Card(
          child: Center(
              child: WeightRecordsWidget(db: db)
          ),
        ),
        /// 趋势 page
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(
                child: WeightTrendsWidget(db: db),
                // child: WeightTrendsWidgetCopy(db: db),
            ),
          ),
        ),


        // todo 用户信息 page
        // Card(
        //   child: PersonalInfo(db: db,),
        // )
      ][currentPageIndex],
    );
  }
}
