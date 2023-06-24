import 'package:flutter/material.dart';

import '../styles/colors.dart';

class TileButton extends StatelessWidget {
  final IconData icon;
  final String name;
  final void Function()? ontap;
  const TileButton({super.key, required this.icon, required this.name,required this.ontap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListTile(
        onTap: ontap,
        title: Text(
          name,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: MyColors.iconColor),
        ),
        leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: MyColors.borderColor, width: 3.0),
          ),
          child: Icon(
            icon,
            color: MyColors.iconColor,
          ),
        ),
      ),
    );
  }
}
