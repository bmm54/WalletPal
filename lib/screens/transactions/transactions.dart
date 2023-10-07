import 'package:bstable/services/currency.dart';
import 'package:bstable/sql/sql_helper.dart';
import 'package:bstable/ui/components/activity.dart';
import 'package:bstable/ui/components/appBar.dart';
import 'package:bstable/ui/components/image.dart';
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
    CurrencyController currencyController = Get.find();
    final currency = currencyController.getSelectedCurrency();
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
                leading:CustomCachedImage(imageUrl: persons[index]['image_url']),
                title: Text(persons[index]['name'],style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.displayMedium!.color),),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(currency+' '+persons[index]['owe'].toString(),style: TextStyle(color: MyColors.green,
                      fontWeight: FontWeight.bold,),),
                      Text(currency+' '+persons[index]['owe_to'].toString(),style: TextStyle(color: MyColors.red,
                      fontWeight: FontWeight.bold,),),
                  ],
                ),

              );
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
              return (records[index]['category'] == "Sent" ||
                      records[index]['category'] == "Received")
                  ? Activity(
                      title: records[index]['title'],
                      image: records[index]['image_url'],
                      amount: records[index]['amount'],
                      category: records[index]['category'],
                      date: DateFormat('dd.MM.yyyy | HH:mm')
                          .format(DateTime.parse(records[index]['time'])),
                      option: records[index]['status'],
                    )
                  : SizedBox();
            },
          ),
        ),
      ],
    );
  }
}
