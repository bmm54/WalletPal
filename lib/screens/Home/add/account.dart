import 'package:bstable/sql/sql_helper.dart';
import 'package:flutter/material.dart';
import '../../../ui/components/appBar.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  List<Map<String, dynamic>> accounts = [];
  _refresh() {
    SQLHelper.getAccounts().then((rows) {
      setState(() {
        accounts = rows;
      });
    });
  }

  @override
  initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              MyAppBar(name: "Accounts", back: true),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: accounts.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: InkWell(
                        onTap: () {
                          final name = accounts[index]['name'];
                          final id = accounts[index]['id'];
                          Navigator.pop(context, [name, id]);
                        },
                        child: Container(
                          height: 80,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Color(int.parse(accounts[index]['color'])),
                            borderRadius: BorderRadius.circular(
                                15.0), // Specify the border radius
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                accounts[index]['name'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.grey[300]),
                              ),
                              Text(
                                  '\$ ${accounts[index]['balance']}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.grey[300])),
                            ],
                          ),
                        ),
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
