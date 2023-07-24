import 'package:flutter/material.dart';

import '../styles/colors.dart';

class TileButton extends StatelessWidget {
  final IconData icon;
  final String name;
  final void Function()? ontap;
  final Widget? option;
  final Color? color;
  const TileButton(
      {super.key,
      required this.icon,
      required this.name,
      required this.ontap,
      this.color,
      this.option});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListTile(
        onTap: ontap,
        title: Text(
          name,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color == null ? Theme.of(context).textTheme.displayMedium!.color: color),
        ),
        leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
                color: color == null
                    ? Theme.of(context).secondaryHeaderColor
                    : color!.withOpacity(0.3),
                width: 3.0),
          ),
          child: Icon(
            icon,
            color: color == null ? Theme.of(context).iconTheme.color : color,
          ),
        ),
        trailing: option??SizedBox(),
      ),
    );
  }
}
