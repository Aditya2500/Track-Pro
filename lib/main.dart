import 'package:flutter/material.dart';

import 'routes.dart';

class AppMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Track-Pro',
      theme: ThemeData(
        primaryColor: Colors.blue,
        accentColor: Colors.blueGrey
      ),
      routes: routes,
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
    );
  }
}

void main() => runApp(AppMain());