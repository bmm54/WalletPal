// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers

import 'package:bstable/ui/components/activity.dart';
import 'package:bstable/ui/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../ui/styles/icons.dart';

import '../../ui/components/card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final _controller = PageController(viewportFraction: 0.8);
    final screenWidth = MediaQuery.of(context).size.width;
    final double buttonRadius = 15;
    return Scaffold(
      //////////////////////////
      body: ListView(children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      border:
                          Border.all(color: MyColors.borderColor, width: 3.0),
                    ),
                  ),
                  Text(
                    "20 Jul 2023",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    radius: buttonRadius,
                    onTap: () {},
                    child: Container(
                      height: 60,
                      width: 60,
                      child: Icon(
                        MyIcons.settings,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(buttonRadius),
                        border:
                            Border.all(color: MyColors.borderColor, width: 3.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //Cards
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: SizedBox(
                height: 200,
                child: PageView.builder(
                    onPageChanged: (value) => {print(value)},
                    scrollDirection: Axis.horizontal,
                    controller: _controller,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return MyCard(
                        sold: 30000,
                        title: "bamba",
                        color: MyColors.lightBlue,
                        light_color: MyColors.lightestBlue,
                      );
                    }),
              ),
            ),
            //Scroll indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                    effect: ExpandingDotsEffect(
                      activeDotColor: MyColors.darkBorder,
                      dotColor: MyColors.lightGrey,
                      dotHeight: 8.0,
                      dotWidth: 8.0,
                      expansionFactor: 4,
                    ),
                  ),
                ],
              ),
            ),
            //Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {},
                    radius: buttonRadius,
                    child: SizedBox(
                      width: 60,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            child: Icon(
                              MyIcons.cashin,
                            ),
                            decoration: BoxDecoration(
                              color: MyColors.buttonGrey,
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(
                                  color: MyColors.borderColor, width: 1.0),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Receive Money",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: MyColors.iconColor),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    radius: buttonRadius,
                    child: SizedBox(
                      width: 60,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            child: Icon(
                              MyIcons.cashout,
                            ),
                            decoration: BoxDecoration(
                              color: MyColors.buttonGrey,
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(
                                  color: MyColors.borderColor, width: 1.0),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Send Money",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: MyColors.iconColor),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      print("add");
                    },
                    radius: buttonRadius,
                    child: SizedBox(
                      width: 60,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            child: Icon(
                              MyIcons.add,
                            ),
                            decoration: BoxDecoration(
                              color: MyColors.buttonGrey,
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(
                                  color: MyColors.borderColor, width: 1.0),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Add",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: MyColors.iconColor),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //Recent Activities
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent Acitivities",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: MyColors.iconColor),
                  ),
                  Icon(Icons.arrow_right_alt_outlined, color: Colors.blue)
                ],
              ),
            ),
            //List of Activities
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Activity();
                  },
                ))
          ],
        ),
      ]),
    );
  }
}
