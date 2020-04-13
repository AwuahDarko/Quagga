import 'package:flutter/material.dart';


class CircularContainer extends StatelessWidget{
  CircularContainer( this.height, this.color,  {this.borderColor = Colors.transparent, this.borderWidth = 2});

  final double height;
  final Color color;
  final Color borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: borderColor, width: borderWidth),
      ),
    );
  }
}

