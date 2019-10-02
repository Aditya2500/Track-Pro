import 'package:flutter/material.dart';

class PageTransition extends PageRouteBuilder {
  final Widget widget;
  PageTransition({this.widget})
    : super(
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
      return widget;
    },
    transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
      return new FadeTransition(
        opacity: animation,
        child: child
      );
    }
  );
}