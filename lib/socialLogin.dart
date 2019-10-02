import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracking06/buttons/mail.dart';
import 'package:tracking06/services/firebase_auth_service.dart';
import 'package:tracking06/utils/router.dart';
import 'package:tracking06/utils/sharedUtils.dart';

class SocialSignin extends StatefulWidget {
  @override
  _SocialSigninState createState() => _SocialSigninState();
}

class _SocialSigninState extends State<SocialSignin> {
  FirebaseAuthService service = FirebaseAuthService();
  void signInGoogle() async {
    var user = await service.googleSignIn();
    if (user.id.isNotEmpty) {      
      Router.goToHome(this.context);
    }
  }

  @override
  Widget build(BuildContext context) {

 double defaultScreenWidth = 400.0;
  double defaultScreenHeight = 810.0;
  ScreenUtil.instance = ScreenUtil(
    width: defaultScreenWidth,
    height: defaultScreenHeight,
    allowFontScaling: true,
  )..init(context);
    return new Scaffold(
        // backgroundColor: Colors.blueGrey[100],
        body: new ListView(
      children: <Widget>[        
        new Padding(padding: EdgeInsets.only(top:ScreenUtil.instance.setHeight(100.0))),
         new Center(
          child: new Text('Track-Pro'),
        ),
         new Padding(padding: EdgeInsets.only(top:ScreenUtil.instance.setHeight(250.0))),
        // new Image(image: new AssetImage('images/loginscreen1.png'),width: 228.0,height: 328.0),
        new Padding(padding: const EdgeInsets.only(top: 10.0)),
       
        new Padding(
          padding: EdgeInsets.all(ScreenUtil.instance.setHeight(10.0)),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              GoogleSignInButton(onPressed: () {
                signInGoogle();
              },text: 'Continue with Google',borderRadius: 50.5,darkMode: true,),
          
              MailSignInButton(onPressed: () {
               Router.goToUserSignIn(context);
              },borderRadius: 50.5,darkMode: true,),  
              new Padding(padding: EdgeInsets.only(top:ScreenUtil.instance.setHeight(100.0)),),            
              new Center(
                child: new Text('By logging in you agree to Tracking-pro Terms of Service, Privacy Policy and Content Policy.',textAlign: TextAlign.center,
                softWrap: true,
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
