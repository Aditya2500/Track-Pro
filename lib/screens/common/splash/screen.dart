import 'package:flutter/material.dart';
import 'package:tracking06/services/PermissionsService%20.dart';
import 'package:tracking06/services/firebase_auth_service.dart';
import 'package:tracking06/utils/sharedUtils.dart';

import '../../../services/auth_service.dart';
import '../../../utils/router.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    //checkAuth();
    checkUser();
  }

  void checkAuth() async {
    if (!await AuthService.isAuthenticated()) {
      Router.goToAuth(this.context);
      return;
    }
    Router.goToHome(this.context);
  }
  FirebaseAuthService service = FirebaseAuthService();

   void checkUser() async {
     //var user = await service.getCurrentUser();
     var email = await SessionStorage.getCurrentUser('user_email');
    if (email ==null) {
      Router.goToAuth(this.context);
      return;
    }
    else if (email.toString().indexOf('@') == -1){
      Router.goToAuth(this.context);
    }
    final PermissionsService permissionsService = PermissionsService();
   await permissionsService.requestPermissionLocation(
                  onPermissionDenied: () {
                print('Permission has been denied');
                return false;
              }
              );
              await permissionsService.requestPermissionlocAtionAlways(
                  onPermissionDenied: () {
                print('Permission has been denied');
                return false;
              }
              );
              await permissionsService.requestPermissionlocLocationWhenInUse(
                  onPermissionDenied: () {
                print('Permission has been denied');
                return false;
              }
              );
              Router.goToHome(this.context);
   // Router.goToHome(this.context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment(0.0, 0.0),
          constraints: BoxConstraints.expand(),
          // BACKGROUND
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage("images/loginscreen.jpg"),
          //     fit: BoxFit.cover,
          //   )
          // ),
          child: Column(
            children: <Widget>[
              // LOGO
              Expanded(
                flex: 1,
                child: FractionallySizedBox(
                  widthFactor: 0.6,
                  heightFactor: 0.6,
                  alignment: FractionalOffset.center,
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    // body: Image(
                    //   image: AssetImage("images/logo.jpeg"),
                    //   fit: BoxFit.contain,
                    //   width: 256.0,
                    //   height: 256.0
                    // ),
                  ),
                )
              ),

              // APP NAME & LOADING SPINNER
              Expanded(
                flex: 1,
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Text(
                            "Loading.....",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        CircularProgressIndicator()
                      ],
                    ),
                  ),
                )
              )
            ],
          )
        ),
      )
    );
  }
}