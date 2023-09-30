import 'package:bstable/sql/sql_helper.dart';
import 'package:bstable/ui/components/activity.dart';
import 'package:bstable/ui/components/appBar.dart';
import 'package:bstable/ui/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Transactions extends StatefulWidget {
  Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  List<Map<String, dynamic>> records = [];
  List<Map<String, dynamic>> persons = [];
  bool ready = false;
  void _refreshData() async {
    final rec = await SQLHelper.getAllActivities();
    final per = await SQLHelper.getPersonsTransactions();
    setState(() {
      records = rec;
      persons = per;
      ready = true;
    });
  }

  @override
  initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        MyAppBar(name: "Transactions", back: false),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: persons.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading:Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: Image.asset("lib/assets/images/profile.png").image),
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                title: Text(persons[index]['title']),
                trailing: Text(persons[index]['total'].toString()),

              );

              //Activity(
              //  title: persons[index]['title'],
              //  image: 
              //  amount: persons[index]['total'],
              //  category: "sent",
              //  date: " ",
              //  option: "Loan",
              //);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recent transactions".tr,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: MyColors.iconColor),
              ),
              Icon(Icons.arrow_right_alt_outlined, color: Colors.blue)
            ],
          ),
        ),
        //List of Activities
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: records.length,
            itemBuilder: (context, index) {
              return (records[index]['title'] == "Sent" ||
                      records[index]['title'] == "Received")
                  ? Activity(
                      title: "Bemba Mahmouden",
                      image: Image.asset("lib/assets/images/profile.png"),
                      amount: records[index]['amount'],
                      category: records[index]['category'],
                      date: DateFormat('dd.MM.yyyy | HH:mm')
                          .format(DateTime.parse(records[index]['time'])),
                      option: "Loan",
                    )
                  : SizedBox();
            },
          ),
        ),
      ],
    );
  }
}
