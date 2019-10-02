import 'package:flutter/material.dart';

class PlainText extends StatelessWidget {
  final String value;
  final double fontSize;
  final TextAlign textAlign;
  final FontWeight fontWeight;

  PlainText(this.value, {this.fontSize, this.textAlign, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      textAlign: this.textAlign != null ? this.textAlign : TextAlign.center,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: this.fontWeight != null ? this.fontWeight : FontWeight.normal,
        fontSize: this.fontSize != null ? this.fontSize : 14.0,
        color: Colors.black
      ),
    );
  }
}