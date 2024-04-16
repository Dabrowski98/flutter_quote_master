import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final Widget? child;
  final Color? color;
  final Color borderColor;

  const Tile(
      {this.child,
      this.color = const Color(0xffe6e6e6),
      this.borderColor = Colors.black,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          color: color,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: child,
        ),
      ),
    );
  }
}
