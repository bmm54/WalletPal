import 'package:bstable/sql/sql_helper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../ui/styles/colors.dart';
import '../../ui/styles/iconlist.dart';

class Stats extends StatefulWidget {
  const Stats({Key? key}) : super(key: key);

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  List<Map<String, dynamic>> expenses = [];
  List<Map<String, dynamic>> incomes = [];
  List<Map<String, dynamic>> queryResult = [];
  double debt = 0;
  double totalBalance = 0;
  List<FlSpot> chartData = [];
  void _refreshData() async {
    final exp = await SQLHelper.getExpenses();
    final inc = await SQLHelper.getIcomes();
    final chart = await SQLHelper.getItems();
    final debt=await SQLHelper.getDebt();
    final totalBalance = await SQLHelper.getTotalBalance();
    setState(() {
      this.expenses = exp;
      this.incomes = inc;
      this.queryResult = chart;
      this.debt=debt[0]['total']??0;
      this.totalBalance = totalBalance[0]['total']??0;
      chartData = queryResult.map((row) {
        String type = row['category'];
        DateTime date = DateTime.parse(row['time']);
        double value = type == 'expense'
            ? -1 * row['amount'].toDouble()
            : row['amount'].toDouble();
        print(date);
        print(value);
        return FlSpot(date.millisecondsSinceEpoch.toDouble(), value);
      }).toList();
      //lineChartData();
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
             Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Stack(
              alignment: AlignmentDirectional.centerStart,
              children: [
                const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Statistics",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: MyColors.iconColor,
                          fontSize: 16),
                    )),
              ],
            ),
          ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  ListTile(
                    title: Text('total balance',style: TextStyle(color: MyColors.iconColor,fontSize: 16),),
                    trailing: Text('\$ $totalBalance',style: TextStyle(color: MyColors.iconColor,fontSize: 16),),
                  ),
                  ListTile(
                    title: Text('total debt',style: TextStyle(color: MyColors.iconColor,fontSize: 16),),
                    trailing: Text('\$ $debt',style: TextStyle(color: MyColors.iconColor,fontSize: 16),),
                  ),
                ],
              ),
            ),
            Padding(
                      padding: const EdgeInsets.symmetric(vertical:10.0),
                      child: Container(
                          height: 1.0, // Adjust the height of the separator line as per your needs
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.transparent, // Start with transparent color
                                MyColors.buttonGrey, // Color of the line in the center
                                Colors.transparent, // End with transparent color
                              ],
                              stops: [0.2,0.8,0.8], // Adjust the stops to control the fading effect
                            ),
                          ),
                        ),
                    ),
            //////////////////////////
            //Line chart
            /*
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: MyColors.buttonGrey,
                border: Border.all(color: MyColors.borderColor, width: 3.0),
              ),
              width: Get.width * 0.9,
              height: Get.width * 0.8,
              child: AspectRatio(
                aspectRatio: 1.0,
                child: LineChart(
                  LineChartData(
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 22,
                          getTitlesWidget: (value, meta) {
                            // Generate dynamic bottom titles based on the chart data
                            int index = value.toInt();
                            if (index >= 0 && index < chartData.length) {
                              DateTime date =
                                  DateTime.fromMillisecondsSinceEpoch(
                                      chartData[index].x.toInt().round());
                              return Text(DateFormat('dd MMM').format(date));
                            }
                            return Text('');
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            // Generate dynamic left titles based on the chart data
                            if (value > -1000 && value < 1000) {
                              // Display numbers directly within the range -100000 to 100000
                              return Text(value.toInt().toString());
                            } else if (value.abs() >= 1000) {
                              // Convert numbers greater than 1000 to "k" format
                              int dividedValue =
                                  (value.abs() ~/ 1000); // Integer division
                              String prefix = value.isNegative
                                  ? ''
                                  : '-'; // Add '-' sign if value is negative
                              return Text('$prefix${dividedValue.toString()}k');
                            }
                            return Text('');
                          },
                        ),
                      ),
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(
                      show: true,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          strokeWidth: 1,
                        );
                      },
                    ),
                    borderData: FlBorderData(
                        show: true,
                        border: Border.all(
                            color: MyColors.borderColor, width: 3.0)),
                    lineBarsData: [
                      LineChartBarData(
                        spots: chartData,
                        isCurved: true,
                        color: MyColors.purpule,
                        barWidth: 3,
                        dotData: FlDotData(
                          show: true,
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          color: MyColors.lightPurpule.withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),*/
            Text(
              "Expenses",
              style: TextStyle(fontSize: 25, color: MyColors.red),
            ),

            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: MyColors.buttonGrey,
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(color: MyColors.borderColor, width: 3.0),
              ),
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
                        sections: _expensesSections(expenses),
                        centerSpaceRadius: Get.width * 0.25,
                      ))),
            ),
            ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(expenses[index]['title']),
                    leading: Icon(
                      Icons.circle,
                      color: IconsList.get_color(expenses[index]['title']),
                    ),
                    trailing: Text('\$ ' + expenses[index]['total'].toString()),
                  );
                }),

            ///////////////////////////////
            Text(
              "Incomes",
              style: TextStyle(fontSize: 25, color: MyColors.green),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: MyColors.buttonGrey,
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(color: MyColors.borderColor, width: 3.0),
              ),
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
                        sections: _incomesSections(incomes),
                        centerSpaceRadius: Get.width * 0.25,
                      ))),
            ),
            ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: incomes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(incomes[index]['title']),
                    leading: Icon(
                      Icons.circle,
                      color: IconsList.get_color(incomes[index]['title']),
                    ),
                    trailing: Text('\$ ' + incomes[index]['total'].toString()),
                  );
                }),
          ],
        ),
      ],
    );
  }

  List<PieChartSectionData> _expensesSections(List expenses) {
    final List<PieChartSectionData> list = [];
    for (var expense in expenses) {
      const double radius = 40.0;
      final data = PieChartSectionData(
        showTitle: false,
        color: IconsList.get_color(expense['title']),
        value: expense['total'],
        radius: radius,
        //title: expense['title'],
      );
      list.add(data);
    }
    return list;
  }

  List<PieChartSectionData> _incomesSections(List incomes) {
    final List<PieChartSectionData> list = [];
    for (var income in incomes) {
      const double radius = 40.0;
      final data = PieChartSectionData(
        showTitle: false,
        color: IconsList.get_color(income['title']),
        value: income['total'],
        radius: radius,
        //title: expense['title'],
      );
      list.add(data);
    }
    return list;
  }
}

SideTitles get _bottomTitles => SideTitles(
      showTitles: true,
      getTitlesWidget: (value, meta) {
        String text = '';
        switch (value.toInt()) {
          case 2:
            text = 'Mar';
          case 5:
            text = 'Jun';
          case 8:
            text = 'Sep';
        }

        return Text(text);
      },
    );
