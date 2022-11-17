import 'package:flutter/material.dart';

class RButton extends StatelessWidget {
  final String str;
  final VoidCallback press;
  final Color bColor;
  final Color tColor;
  const RButton(
      {Key? key,
      required this.str,
      required this.press,
      required this.bColor,
      required this.tColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: FlatButton(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        color: bColor,
        onPressed: press,
        child: Text(
          str,
          style: TextStyle(
            color: tColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class RButtonIcon extends StatelessWidget {
  final String str;
  final VoidCallback press;
  final Color bColor;
  final Color tColor;
  final IconData bIcon;
  final Color iColor;
  const RButtonIcon(
      {Key? key,
      required this.str,
      required this.press,
      required this.bColor,
      required this.tColor,
      required this.bIcon,
      required this.iColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: FlatButton.icon(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        color: bColor,
        onPressed: press,
        label: Text(
          str,
          style: TextStyle(
            color: tColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        icon: Icon(
          bIcon,
          color: iColor,
        ),
      ),
    );
  }
}
