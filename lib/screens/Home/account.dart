import 'package:bstable/sql/sql_helper.dart';
import 'package:bstable/ui/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ui/styles/icons.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  List<Map<String, dynamic>> accounts = [];
  @override
  initState() {
    super.initState();
    SQLHelper.getAccounts().then((rows) {
      setState(() {
        accounts = rows;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Stack(
                  alignment: AlignmentDirectional.centerStart,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                              color: MyColors.borderColor, width: 3.0),
                        ),
                        child: const Icon(MyIcons.back),
                      ),
                    ),
                    const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Account",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: MyColors.iconColor,
                              fontSize: 16),
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: accounts.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        
                        contentPadding: EdgeInsets.all(8),
                        onTap: () {
                          final name = accounts[index]['name'];
                          final id = accounts[index]['id'];
                          Navigator.pop(context, [name, id]);
                        },
                        title: Text(accounts[index]['name']),
                        tileColor: Color(int.parse(accounts[index]['color'])),
                        trailing: Text(
                            "\$ ${accounts[index]['balance']!.toString()}"),
                        textColor: Colors.grey[300],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
 