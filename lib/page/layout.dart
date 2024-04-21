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

    return Scaffold(
      // backgroundColor: Colors.red,
      bottomNavigationBar: NavigationBar(
        height: 70,
        // backgroundColor: Colors.white,
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
          NavigationDestination(
            icon: Icon(Icons.person),
            label: '我的',
          ),
        ],
      ),
      body: <Widget>[
        /// 记录 page
        Card(
            child: WeightRecordsWidget(db: db)
        ),
        /// 趋势 page
        Card(
          child: WeightTrendsWidget(db: db)
        ),
        /// 用户信息 page
        Card(
          // color: Colors.white,
          child: PersonalInfo(db: db,),
        )
      ][currentPageIndex],
    );
  }
}
