import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final Widget? child;
  final Color? color;
  final Color borderColor;
  final double margin;
  final double padding;

  const Tile(
      {this.child,
      this.color,
      this.borderColor = Colors.black,
      super.key,
      this.margin = 4.0,
      this.padding = 8.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(margin),
      child: Container(
        //   decoration: BoxDecoration(),
        decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            color: color,
            borderRadius: BorderRadius.circular(4)),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: child,
        ),
      ),
    );
  }
}
