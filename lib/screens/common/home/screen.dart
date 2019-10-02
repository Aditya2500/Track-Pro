import 'package:flutter/material.dart';

import '../../../services/auth_service.dart';
import '../../../utils/router.dart';

import '../../wigets/home_app_bar.dart';

import 'elements/texts.dart';
import 'elements/tapable.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class UserCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return Card(
      color: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ClipOval(
              child:
                Image(
                  image: AssetImage("assets/logos/auth.png"),
                  fit: BoxFit.cover,
                  width: 200.0,
                  height: 200.0
                )
            ),
            Text("TEST", style: textStyle),
          ],
        ),
      ),
    );
  }
}


class _HomeScreenState extends State<HomeScreen> {
  void signOut() async {
    await AuthService.destroySession();
    Router.goToAuth(this.context);
  }

  void goToDiary() async {
    if (await AuthService.isAuthenticated()) {
      Router.goToDiary(this.context);
      return;
    }
    this.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white70
        ),
        child: Column(
          children: <Widget>[
            HomeAppBar("SMLS", exitMethod: this.signOut),

            UserCard(),

            Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 0.0, top: 0.0),
                      child: GridView.count(
                          crossAxisCount: 3,
                          childAspectRatio: 0.7,
                          scrollDirection: Axis.vertical,
                          mainAxisSpacing: 14.0,
                          crossAxisSpacing: 14.0,
                          children: <Widget>[
                            Tapable(
                              'Дневник',
                              assetImage: "assets/icons/menu/diary.png",
                              onTap: () { this.goToDiary(); }
                            ),
                            Tapable(
                              'Показатели',
                              assetImage: "assets/icons/menu/performance.png",
                                onTap: () { this.goToDiary(); }
                            ),
                            Tapable(
                              'Задания',
                              assetImage: "assets/icons/menu/tasks.png",
                              onTap: () { this.goToDiary(); }
                            ),
                            Tapable(
                              'Библиотека',
                              assetImage: "assets/icons/menu/library.png",
                              onTap: () { this.goToDiary(); }
                            ),
                            Tapable(
                              'Меню еды',
                              assetImage: "assets/icons/menu/food-menu.png",
                              onTap: () { this.goToDiary(); }
                            ),
                            Tapable(
                              'Обьявления',
                              assetImage: "assets/icons/menu/anouncements.png",
                              onTap: () { this.goToDiary(); }
                            ),
                            Tapable(
                              'Приемные дни',
                              assetImage: "assets/icons/menu/receptiondays.png",
                              onTap: () { this.goToDiary(); }
                            ),
                            Tapable(
                              'Медицинская карта',
                              assetImage: "assets/icons/menu/medical-card.png",
                              onTap: () { this.goToDiary(); }
                            ),
                            Tapable(
                              'Школьный автобус',
                              assetImage: "assets/icons/menu/schoolbus.png",
                              onTap: () { this.goToDiary(); }
                            ),
                          ]
                      ),
                    ),
                  ),
                )
            )
          ],
        )
      )
    );
  }
}