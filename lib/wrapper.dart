import 'package:bstable/screens/Home/Home.dart';
import 'package:bstable/screens/Stats/stats.dart';
import 'package:bstable/ui/styles/colors.dart';
import 'package:bstable/ui/styles/icons.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> with TickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    final _controller = TabController(vsync: this, length: 4);
    return  Scaffold(
      body: Column(
          children: [
            Expanded(
              child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _controller,
                  children: [
                    Home(),
                    Placeholder(),
                    Stats(),
                    Placeholder(),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                child: TabBar(
                  splashBorderRadius: BorderRadius.circular(20.0),
                  indicatorColor: Colors.white,
                      labelColor: MyColors.blue,
                        unselectedLabelColor: MyColors.iconGrey,
                        labelStyle:
                            TextStyle( fontWeight: FontWeight.bold),
                      controller: _controller,
                      tabs: [
                        Tab(icon:Icon(MyIcons.home, size: 30),iconMargin: EdgeInsets.only(bottom:5),),
                        Tab(icon:Icon(MyIcons.wallet, size: 30,),iconMargin: EdgeInsets.only(bottom:5),),
                        Tab(icon:Icon(MyIcons.stats, size: 30,),iconMargin: EdgeInsets.only(bottom:5),),
                        Tab(icon:Icon(MyIcons.profile, size: 30,),iconMargin: EdgeInsets.only(bottom:5),),
                      ]),
              ),
            ),
          ],
      ),
    );
  }
}