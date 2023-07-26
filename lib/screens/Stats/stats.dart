import 'package:bstable/sql/sql_helper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../ui/components/appBar.dart';
import '../../ui/styles/colors.dart';
import '../../ui/styles/iconlist.dart';

class Stats extends StatefulWidget {
  const Stats({Key? key}) : super(key: key);

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  bool ready = false;
  List<Map<String, dynamic>> expenses = [];
  List<Map<String, dynamic>> incomes = [];
  List<Map<String, dynamic>> chartResult = [];
  String selectedFilter = 'This Week';
  double debt = 0;
  double totalBalance = 0;
  List<FlSpot> chartData = [];
  int? expTouchedIndex;
  int? incTouchedIndex;

  void _refreshData() async {
    final exp = await SQLHelper.getExpenses();
    final chart = await SQLHelper.getItems();
    final inc = await SQLHelper.getIcomes();
    final debt = await SQLHelper.getDebt();
    final totalBalance = await SQLHelper.getTotalBalance();

    setState(() {
      this.expenses = exp;
      this.incomes = inc;
      this.chartResult = chart;
      this.debt = debt[0]['total'] ?? 0;
      this.totalBalance = totalBalance[0]['total'] ?? 0;
      final now = DateTime.now();
      // Filter expenses based on the selected filter option
      switch (selectedFilter) {
        case 'This Week':
          final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          final endOfWeek =
              now.add(Duration(days: DateTime.daysPerWeek - now.weekday));
          print(endOfWeek.toString());
          chartResult = chartResult.where((expense) {
            DateTime date = DateTime.parse(expense['time']);
            return date.isAfter(startOfWeek) && date.isBefore(endOfWeek);
          }).toList();
          break;

        case 'This Month':
          final startOfMonth = DateTime(now.year, now.month, 1);
          final endOfMonth = DateTime(now.year, now.month + 1, 0);

          chartResult = chartResult.where((expense) {
            DateTime date = DateTime.parse(expense['time']);
            return date.isAfter(startOfMonth) && date.isBefore(endOfMonth);
          }).toList();
          break;

        case 'This Year':
          final startOfYear = DateTime(now.year, 1, 1);
          final endOfYear = DateTime(now.year + 1, 1, 0);

          chartResult = chartResult.where((expense) {
            DateTime date = DateTime.parse(expense['time']);
            return date.isAfter(startOfYear) && date.isBefore(endOfYear);
          }).toList();
          break;
      }

      chartData = List.generate(7, (index) {
        final dayOfWeek = now
            .subtract(Duration(days: now.weekday - 1))
            .add(Duration(days: index));
        double totalExpense = chartResult
            .where((expense) =>
                DateTime.parse(expense['time']).weekday == dayOfWeek.weekday)
            .fold(0.0, (sum, expense) => sum + expense['amount'].toDouble());
        return FlSpot(index.toDouble(), totalExpense);
      });

      ready = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return !ready
        ? Center(
            child: CircularProgressIndicator(
            color: MyColors.purpule,
          ))
        : ListView(
            children: [
              Column(
                children: [
                  MyAppBar(name: "Statistics", back: false),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            'total balance',
                            style: TextStyle(
                                color: MyColors.iconColor, fontSize: 16),
                          ),
                          trailing: Text(
                            '\$ $totalBalance',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .color),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'total debt',
                            style: TextStyle(
                                color: MyColors.iconColor, fontSize: 16),
                          ),
                          trailing: Text(
                            '\$ $debt',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .color),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      height:
                          1.0, // Adjust the height of the separator line as per your needs
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.transparent, // Start with transparent color
                            MyColors
                                .iconColor, // Color of the line in the center
                            Colors.transparent, // End with transparent color
                          ],
                          stops: [
                            0.1,
                            0.5,
                            0.9
                          ], // Adjust the stops to control the fading effect
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              border: Border.all(
                                  width: 3,
                                  color:
                                      Theme.of(context).secondaryHeaderColor),
                              borderRadius: BorderRadius.circular(15)),
                          child: DropdownButton<String>(
                            dropdownColor: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10),
                            underline: Container(
                              height: 0,
                            ),
                            value: selectedFilter,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .color,
                                fontWeight: FontWeight.bold),
                            alignment: Alignment.center,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedFilter = newValue!;
                                _refreshData();
                              });
                            },
                            items: <String>[
                              'This Week',
                              'This Month',
                              'This Year'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                    child: SizedBox(
                      height: 300,
                      child: BarChart(
                        BarChartData(
                          titlesData: FlTitlesData(
                            topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            rightTitles: AxisTitles(
                                sideTitles: SideTitles(
                              showTitles: false,
                            )),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (double value, meta) {
                                  switch (selectedFilter) {
                                    case 'This Week':
                                      {
                                        switch (value.toInt()) {
                                          case 0:
                                            return Text(
                                              'Mon',
                                              style: TextStyle(
                                                  color: MyColors.iconColor),
                                            );
                                          case 1:
                                            return Text('Tue',
                                                style: TextStyle(
                                                    color: MyColors.iconColor));
                                          case 2:
                                            return Text('Wed',
                                                style: TextStyle(
                                                    color: MyColors.iconColor));
                                          case 3:
                                            return Text('Thu',
                                                style: TextStyle(
                                                    color: MyColors.iconColor));
                                          case 4:
                                            return Text('Fri',
                                                style: TextStyle(
                                                    color: MyColors.iconColor));
                                          case 5:
                                            return Text('Sat',
                                                style: TextStyle(
                                                    color: MyColors.iconColor));
                                          case 6:
                                            return Text('Sun',
                                                style: TextStyle(
                                                    color: MyColors.iconColor));
                                          default:
                                            return Text('');
                                        }
                                      }
                                    default:
                                      return Text(value.toInt().toString(),
                                          style: TextStyle(
                                              color: MyColors.iconColor));
                                  }
                                },
                              ),
                            ),
                          ),
                          alignment: BarChartAlignment.spaceAround,
                          barTouchData: BarTouchData(
                              touchTooltipData: BarTouchTooltipData(
                                  tooltipBgColor: MyColors.lightPurpule)),
                          maxY: chartData
                              .reduce((value, element) =>
                                  value.y > element.y ? value : element)
                              .y,
                          gridData: FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          barGroups: List.generate(7, (index) {
                            return BarChartGroupData(x: index, barRods: [
                              BarChartRodData(
                                toY: chartData[index].y,
                                width: 20,
                                borderRadius: BorderRadius.circular(3),
                                color: MyColors.purpule,
                                backDrawRodData: BackgroundBarChartRodData(
                                  show: true,
                                ),
                              )
                            ]);
                          }),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              border: Border.all(
                                  width: 3,
                                  color:
                                      Theme.of(context).secondaryHeaderColor),
                              borderRadius: BorderRadius.circular(15)),
                          child: DropdownButton<String>(
                            dropdownColor: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10),
                            underline: Container(
                              height: 0,
                            ),
                            value: selectedFilter,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .color,
                                fontWeight: FontWeight.bold),
                            alignment: Alignment.center,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedFilter = newValue!;
                                _refreshData();
                              });
                            },
                            items: <String>[
                              'This Week',
                              'This Month',
                              'This Year'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Expenses",
                    style: TextStyle(
                        fontSize: 25,
                        color: MyColors.red,
                        fontWeight: FontWeight.bold),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(
                          color: Theme.of(context).secondaryHeaderColor,
                          width: 3.0),
                    ),
                    width: Get.width * 0.9,
                    height: Get.width * 0.9,
                    child: expenses.isEmpty
                        ? Center(
                            child: Text(
                            "There is no data yet",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .color,
                                fontSize: 20),
                          ))
                        : AspectRatio(
                            aspectRatio: 1.0,
                            child: PieChart(
                                swapAnimationDuration:
                                    Duration(milliseconds: 150), // Optional
                                swapAnimationCurve: Curves.linear,
                                PieChartData(
                                  pieTouchData: PieTouchData(
                                    touchCallback: (p0, p1) {
                                      setState(() {
                                        if (p1?.touchedSection
                                                is FlLongPressEnd ||
                                            p1?.touchedSection
                                                is FlPanEndEvent) {
                                          expTouchedIndex = -1;
                                        } else {
                                          expTouchedIndex = p1?.touchedSection!
                                              .touchedSectionIndex;
                                        }
                                      });
                                    },
                                  ),
                                  borderData: FlBorderData(show: false),
                                  sectionsSpace: 0,
                                  sections: _expensesSections(
                                      expenses, expTouchedIndex),
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
                            color:
                                IconsList.get_color(expenses[index]['title']),
                          ),
                          trailing: Text('\$ ' +
                              (expenses[index]['total'] ?? 0).toString()),
                        );
                      }),

                  ///////////////////////////////
                  Text(
                    "Incomes",
                    style: TextStyle(
                        fontSize: 25,
                        color: MyColors.green,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(
                          color: Theme.of(context).secondaryHeaderColor,
                          width: 3.0),
                    ),
                    width: Get.width * 0.9,
                    height: Get.width * 0.9,
                    child: incomes.isEmpty
                        ? Center(
                            child: Text(
                            "There is no data yet",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .color,
                                fontSize: 20),
                          ))
                        : AspectRatio(
                            aspectRatio: 1.0,
                            child: PieChart(
                                swapAnimationCurve: Curves.linear,
                                PieChartData(
                                  pieTouchData: PieTouchData(
                                    touchCallback: (p0, p1) {
                                      setState(() {
                                        if (p1?.touchedSection
                                                is FlLongPressEnd ||
                                            p1?.touchedSection
                                                is FlPanEndEvent) {
                                          incTouchedIndex = -1;
                                        } else {
                                          incTouchedIndex = p1?.touchedSection!
                                              .touchedSectionIndex;
                                        }
                                      });
                                    },
                                  ),
                                  borderData: FlBorderData(show: false),
                                  sectionsSpace: 0,
                                  sections: _incomesSections(incomes,incTouchedIndex),
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
                          trailing:
                              Text('\$ ' + incomes[index]['total'].toString()),
                        );
                      }),
                ],
              ),
            ],
          );
  }

  List<PieChartSectionData> _expensesSections(
      List expenses, int? touchedIndex) {
    final List<PieChartSectionData> list = [];
    double sum = 0;
    for (var expense in expenses) {
      sum += expense['total'];
    }
    for (var index = 0; index < expenses.length; index++) {
      final isTouched = index == touchedIndex;
      double fontSize = isTouched ? 20 : 14;
      double radius = isTouched ? 70.0 : 50.0;
      double pourc = (expenses[index]['total'] * 100) / sum;
      String title = pourc.toStringAsFixed(1)+'%';
      final data = PieChartSectionData(
          showTitle: true,
          title: title,
          color: IconsList.get_color(expenses[index]['title']),
          value: expenses[index]['total'],
          radius: radius,
          titleStyle: TextStyle(fontSize: fontSize,fontWeight: FontWeight.bold,color: Theme.of(context).textTheme.displayMedium!.color));
      list.add(data);
    }
    return list;
  }

  List<PieChartSectionData> _incomesSections(List incomes, int? touchedIndex) {
    final List<PieChartSectionData> list = [];
    double sum = 0;
    for (var income in incomes) {
      sum += income['total'];
    }
    for (var index = 0; index < incomes.length; index++) {
      final isTouched = index == touchedIndex;
      double fontSize = isTouched ? 20 : 14;
      double radius = isTouched ? 70.0 : 50.0;
      double pourc = (incomes[index]['total'] * 100) / sum;
      String title = pourc.toStringAsFixed(1)+'%';
      final data = PieChartSectionData(
          showTitle: true,
          title: title,
          color: IconsList.get_color(incomes[index]['title']),
          value: incomes[index]['total'],
          radius: radius,
          titleStyle: TextStyle(fontSize: fontSize,fontWeight: FontWeight.bold,color: Theme.of(context).textTheme.displayMedium!.color));
      list.add(data);
    }
    return list;
  }
}
