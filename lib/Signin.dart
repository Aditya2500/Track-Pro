import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracking06/services/firebase_auth_service.dart';
import 'utils/router.dart';

class UserSignin extends StatefulWidget {
  @override
  _UserSigninState createState() => _UserSigninState();
}

class _UserSigninState extends State<UserSignin> {
  FirebaseAuthService service = FirebaseAuthService();

  void signIn() async {
    try {
      final FormState form = _formKey.currentState;
      form.save();
      if (emails.isNotEmpty && passwords.isNotEmpty) {
        if (!form.validate()) {
          alertMessage('Email or password is not valid!');
        } else {
         _submitDialog(context);        
          var user = await service.signinFirebase(emails, passwords);
          if (user == null) {            
            Navigator.of(context).pop();
            alertMessage('Email or password is not correct!');             
            return;
          }
          if (user.email.isEmpty) {
            Navigator.of(context).pop();
            alertMessage('Email or password is not correct!');
            return;
          } else {            
            Router.goToHome(this.context);
          }
        }
      } else {
        Navigator.of(context).pop();
        alertMessage('Email or password is not valid!');
      }
    } catch (e) {
      Navigator.of(context).pop();
      alertMessage('Something went wrong!');
    }
  }
Future<Null> _submitDialog(BuildContext context) async {
  return await showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          children: <Widget>[
            Center(
              child: CircularProgressIndicator(),
            )
          ],
        );
      });
}
  void alertMessage(String message) {
    AlertDialog dialog = new AlertDialog(
      content: new Text(
        message,
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: new Text("OK")),
      ],
    );
    showDialog(context: context, child: dialog);
  }

  Future<void> signInGoogle() async {
    _submitDialog(context);
    var user = await service.googleSignIn();
    if (user != null) {
      Router.goToHome(this.context);
    }else{
      Navigator.of(context).pop();
    }
  }

  String emails = '';
  String passwords = '';
  bool _obscureText = true;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _key = new GlobalKey<FormFieldState>();

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
        body: new Container(
            //              decoration: BoxDecoration(
            //   image: DecorationImage(
            //     image: AssetImage("images/loginscreen1.png"),
            //     fit: BoxFit.cover,
            //   ),
            // ),
            child: new Form(
                key: _formKey,
                autovalidate: true,
                child: new ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: ScreenUtil.instance.setHeight(50.0)),
                      child: new Center(
                        child: new Text('Track-Pro',
                            style: TextStyle(fontSize: 30)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: ScreenUtil.instance.setHeight(10.0)),
                      child: new Center(
                        child: new Text('Safety on fingertips',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontFamily: "Open Sans",
                                fontSize: 15)),
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(
                          left: ScreenUtil.instance.setHeight(8.0),
                          right: ScreenUtil.instance.setHeight(8.0),
                          top: ScreenUtil.instance.setHeight(120.0)),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          new Row(
                            children: <Widget>[
                              Expanded(
                                child: new ListTile(
                                  leading: const Icon(
                                    Icons.email,
                                  ),
                                  title: new TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (val) =>
                                        !EmailValidator.validate(val)
                                            ? ''
                                            : null,
                                    onSaved: (val) => emails = val,
                                    decoration: new InputDecoration(
                                      hintText: "Email",
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          new Row(
                            children: <Widget>[
                              Expanded(
                                child: new ListTile(
                                  leading: const Icon(
                                    Icons.lock,
                                  ),
                                  title: new TextFormField(
                                    validator: (val) => val.isEmpty ? '' : null,
                                    onSaved: (val) => passwords = val,
                                    obscureText: _obscureText,
                                    decoration: new InputDecoration(
                                        hintText: "Password",
                                        suffixIcon: GestureDetector(
                                          child: Icon(
                                            Icons.remove_red_eye,
                                          ),
                                          onTap: () {
                                            setState(() {
                                              _obscureText = !_obscureText;
                                            });
                                          },
                                        )),
                                  ),
                                ),
                              )
                            ],
                          ),
                          new Padding(
                            padding: EdgeInsets.all(
                                ScreenUtil.instance.setHeight(15.0)),
                            child: new Container(
                              width: 30.0,
                              height: 50.0,
                              child: new RaisedButton(
                                onPressed: signIn,
                                child: new Text("Sign In",
                                    style: new TextStyle(
                                        color: Colors.white, fontSize: 15.0)),
                                color: Colors.green[600],
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0)),
                              ),
                            ),
                          ),
                          new Padding(
                            padding: EdgeInsets.only(
                                left: ScreenUtil.instance.setHeight(20.0)),
                            child: Center(
                                child: new FlatButton(
                                    child: Text('Forgot Password?',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          decoration: TextDecoration.underline,
                                        )),
                                    onPressed: () {
                                      Router.goToForgotPassword(this.context);
                                    })),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                child: new Text('Don\'t have an account?',
                                    style: new TextStyle(
                                        color: Color(0xFF2E3233))),
                                onTap: () {},
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Router.goToRegister(this.context);
                                  },
                                  child: new Text(
                                    'Register.',
                                    style: new TextStyle(
                                        color: Colors.red[300],
                                        fontWeight: FontWeight.bold),
                                  ))
                            ],
                          ),
                          new Padding(
                              padding: EdgeInsets.only(
                                  left: ScreenUtil.instance.setHeight(20.0),
                                  top: ScreenUtil.instance.setHeight(175.0)),
                              child: Center(
                                child: Text('Or sign in with',
                                    style: TextStyle(color: Color(0xFF2E3233))),
                              )),
                          new Padding(
                            padding: EdgeInsets.only(
                                left: ScreenUtil.instance.setHeight(20.0),
                                top: ScreenUtil.instance.setHeight(10.0)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                  child: GestureDetector(
                                onTap: () {
                                  signInGoogle();
                                },
                                child: ClipOval(
                                  child: Container(
                                    color: Colors.white,

                                    height: 50.0, // height of the button
                                    width: 50.0, // width of the button
                                    child: Center(
                                      child: Image(
                                        image: AssetImage(
                                          "graphics/google-logo.png",
                                          package: "flutter_auth_buttons",
                                        ),
                                        height: 25.0,
                                        width: 25.0,
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left:
                                          ScreenUtil.instance.setHeight(30.0)),
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: ClipOval(
                                      child: Container(
                                        color: Colors.blue[500],
                                        height: 50.0, // height of the button
                                        width: 50.0, // width of the button
                                        child: Center(
                                          child: Image(
                                            image: AssetImage(
                                              "graphics/flogo-HexRBG-Wht-100.png",
                                              package: "flutter_auth_buttons",
                                            ),
                                            height: 25.0,
                                            width: 25.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ))));
  }
}
