import 'package:flutter/material.dart';
import 'package:weight_log/constant/db.dart';
import 'package:weight_log/page/layout.dart';

import 'db/database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = await $FloorWeightLogDatabase
      .databaseBuilder(dbName)
      .build();

  runApp(WeightLogApp(db));
}

class WeightLogApp extends StatelessWidget {
  final WeightLogDatabase db;

  const WeightLogApp(this.db, {super.key});

  @override
  Widget build(BuildContext context) {
    const String title = '体重记录';
    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      title: title,
      // // theme: ThemeData(primarySwatch: Colors.blueGrey),
      // theme: ThemeData(canvasColor: Colors.white,),
      home: Layout(key: super.key, title: title, db: db),
    );
  }
}