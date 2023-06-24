import 'package:bstable/sql/sql_helper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ui/styles/iconlist.dart';

class Stats extends StatefulWidget {
  const Stats({Key? key}) : super(key: key);

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  List<Map<String, dynamic>> activities = [];
  void _refreshData() async {
    final rec = await SQLHelper.getRecords();
    setState(() {
      activities = rec;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: [
            SizedBox(height: 200),
            Container(
              color: Colors.blue,
              width: Get.width * 0.8,
              height: Get.width * 0.8,
              child: AspectRatio(
                  aspectRatio: 1.0,
                  child: PieChart(
                      swapAnimationDuration:
                          Duration(milliseconds: 150), // Optional
                      swapAnimationCurve: Curves.linear,
                      PieChartData(
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 0,
                        sections: _chartSections(activities),
                        centerSpaceRadius: Get.width * 0.25,
                      ))),
            ),
            ListView.builder(
              shrinkWrap: true,
              primary: false,
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(activities[index]['title']),
                    leading: Icon(Icons.circle,color: IconsList.get_color(activities[index]['title']),),
                    trailing: Text('\$ '+activities[index]['total'].toString()),
                  );
                })
          ],
        ),
      ],
    );
  }

  List<PieChartSectionData> _chartSections(List activities) {
    final List<PieChartSectionData> list = [];
    for (var activity in activities) {
      const double radius = 40.0;
      final data = PieChartSectionData(
        showTitle: false,
        color: IconsList.get_color(activity['title']),
        value: activity['total'],
        radius: radius,
        //title: activity['title'],
        /*title: records[index]['title'],
                          amount: records[index]['amount'],
                          color: IconsList.get_color(title),
                          icon: IconsList.get_icon(title),
                          category: records[index]['category'],
                          date: records[index]['time'], */
      );
      list.add(data);
    }
    return list;
  }
}
