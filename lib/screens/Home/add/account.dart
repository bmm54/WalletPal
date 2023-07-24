import 'package:bstable/models/accounts_model.dart';
import 'package:bstable/sql/sql_helper.dart';
import 'package:bstable/ui/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../ui/components/appBar.dart';
import '../../../ui/styles/icons.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  List<Map<String, dynamic>> accounts = Accounts.getAccounts;
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
                            MyAppBar(name: "Accounts",back:true),

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
                        title: Text(accounts[index]['name'],style: TextStyle(fontWeight: FontWeight.bold),),
                        tileColor: Color(int.parse(accounts[index]['color'])),
                        trailing: Text(
                            "\$ ${accounts[index]['balance']!.toString()}",style: TextStyle(fontWeight: FontWeight.bold),),
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
 