import 'package:flutter/material.dart';

import '../../../services/auth_service.dart';
import '../../../utils/router.dart';

import '../../wigets/page_app_bar.dart';

import 'elements/texts.dart';

class DiaryScreen extends StatefulWidget {
  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  void backToHome() async {
    Router.backToHome(this.context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          PageAppBar(
            "SMLS",
            backMethod: this.backToHome
          ),

          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white70,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView(
                    children: <Widget>[
                      PlainText('Дневник')
                    ],
                  ),
                ),
              ),
            )
          )
        ],
      )
    );
  }
}