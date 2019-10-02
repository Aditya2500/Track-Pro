import 'package:flutter/material.dart';

class HeroText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (
      Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Tracking',
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 24.0,
              color: Colors.black
            ),
          ),
        )
      )
    );
  }
}

class OrText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'or',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 14.0,
        color: Colors.black
      ),
    );
  }
}