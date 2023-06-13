import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final double sold;
  final String title;
  final Color color;
  final Color light_color;
  const MyCard(
      {super.key,
      required this.sold,
      required this.title,
      required this.color,
      required this.light_color});
  //return a card widget
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10),
      child: Container(
        width: screenWidth,
        height: 160,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(40.0),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              spreadRadius: 0.3,
              blurRadius: 10,
              offset: Offset(7, 7), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0, top: 25.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "$title",
              style: TextStyle(
                color: light_color,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              "\$ ${sold.toStringAsFixed(2)}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
