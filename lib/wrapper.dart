import 'package:bstable/screens/Home/home.dart';
import 'package:bstable/screens/Stats/stats.dart';
import 'package:bstable/screens/Wallet/wallet.dart';
import 'package:bstable/screens/authentification/authenticate.dart';
import 'package:bstable/screens/transactions/transactions.dart';
import 'package:bstable/services/auth.dart';
import 'package:bstable/ui/styles/colors.dart';
import 'package:bstable/ui/styles/icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: AuthService().authStateChanges(),
        builder: (buildContext, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data == null) {
              return Authenticate();
            } else {
              return Screens();
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

class Screens extends StatefulWidget {
  const Screens({super.key});

  @override
  State<Screens> createState() => _ScreensState();
}

class _ScreensState extends State<Screens> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final _controller = TabController(vsync: this, length: 4);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _controller,
                  children: [
                    Home(),
                    Wallet(),
                    Stats(),
                    Transactions(),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                child: TabBar(
                    splashBorderRadius: BorderRadius.circular(20.0),
                    indicatorColor: Colors.transparent,
                    labelColor: MyColors.blue,
                    unselectedLabelColor: MyColors.iconGrey,
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    controller: _controller,
                    tabs: [
                      Tab(
                        icon: Icon(MyIcons.home, size: 30),
                        iconMargin: EdgeInsets.only(bottom: 5),
                      ),
                      Tab(
                        icon: Icon(
                          MyIcons.wallet,
                          size: 30,
                        ),
                        iconMargin: EdgeInsets.only(bottom: 5),
                      ),
                      Tab(
                        icon: Icon(
                          MyIcons.stats,
                          size: 30,
                        ),
                        iconMargin: EdgeInsets.only(bottom: 5),
                      ),
                      Tab(
                        icon: Icon(
                          MyIcons.trans,
                          size: 30,
                        ),
                        iconMargin: EdgeInsets.only(bottom: 5),
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
