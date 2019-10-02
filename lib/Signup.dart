import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:tracking06/services/firebase_auth_service.dart';
import 'utils/router.dart';

class UserSignup extends StatefulWidget {
  @override
  _UserSignupState createState() => _UserSignupState();
}

class _UserSignupState extends State<UserSignup> {
  FirebaseAuthService service = FirebaseAuthService();

  void signUp() async {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      alertMessage('Email or password is not valid!');
    } else {
      form.save();
      var user = await service.createAccountFirebase(emails, passwords);
      print(user);
      if (user.email.isEmpty) {
        alertMessage('Something went wrong!');
      } else {      
        Router.goToHome(this.context);
      }
    }
  }

  String emails = '';
  String passwords = '';
  String confirmPassword = '';

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _key = new GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: true,
            //`true` if you want Flutter to automatically add Back Button when needed,
            //or `false` if you want to force your own back button every where

            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            )),
        backgroundColor: Colors.lightBlue[900],
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
                    new Padding(padding: const EdgeInsets.only(top: 200.0)),
                    new Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          new Container(
                            child: new DecoratedBox(
                              decoration: new BoxDecoration(
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(30.0)),
                                color: Colors.cyan[800],
                              ),
                              child: new ListTile(
                                leading: const Icon(Icons.email,
                                    color: Colors.white),
                                title: new TextFormField(
                                  style: new TextStyle(
                                      color: Colors.white, fontSize: 18.0),
                                  validator: (val) => !EmailValidator.validate(
                                          val)
                                      ? 'Please enter a valid email address!'
                                      : null,
                                  onSaved: (val) => emails = val,
                                  decoration: new InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Email",
                                    hintStyle:
                                        new TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          new Padding(
                            padding: const EdgeInsets.all(10.0),
                          ),
                          new Container(
                            child: new DecoratedBox(
                              decoration: new BoxDecoration(
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(30.0)),
                                color: Colors.cyan[800],
                              ),
                              child: new ListTile(
                                leading: const Icon(
                                  Icons.lock,
                                  color: Colors.white,
                                ),
                                title: new TextFormField(
                                  style: new TextStyle(
                                      color: Colors.white, fontSize: 18.0),
                                  onSaved: (val) => passwords = val,
                                  validator: (val) {
                                    var mediumRegex = new RegExp(
                                        "^(((?=.*[a-z])(?=.*[A-Z]))|((?=.*[a-z])(?=.*[0-9]))|((?=.*[A-Z])(?=.*[0-9])))(?=.{6,})");
                                    if (val.isEmpty) {
                                      return 'Password is required!';
                                    } else if (!mediumRegex.hasMatch(val)) {
                                      return 'Password is weak!';
                                    } else {
                                      return null;
                                    }
                                  },
                                  key: _key,
                                  decoration: new InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    hintStyle:
                                        new TextStyle(color: Colors.white),
                                  ),
                                  obscureText: false,
                                ),
                              ),
                            ),
                          ),
                          new Padding(
                            padding: const EdgeInsets.all(10.0),
                          ),
                          new Container(
                            child: new DecoratedBox(
                              decoration: new BoxDecoration(
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(30.0)),
                                color: Colors.cyan[800],
                              ),
                              child: new ListTile(
                                leading: const Icon(
                                  Icons.lock,
                                  color: Colors.white,
                                ),
                                title: new TextFormField(
                                  style: new TextStyle(
                                      color: Colors.white, fontSize: 18.0),
                                  onSaved: (val) => confirmPassword = val,
                                  validator: (val) =>
                                      _key.currentState.value != val
                                          ? 'Password does not match'
                                          : null,
                                  decoration: new InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Confirm Password",
                                    hintStyle:
                                        new TextStyle(color: Colors.white),
                                  ),
                                  obscureText: false,
                                ),
                              ),
                            ),
                          ),
                          new Padding(
                            padding: const EdgeInsets.all(10.0),
                          ),
                          new Container(
                            width: 100.0,
                            height: 50.0,
                            child: new RaisedButton(
                              onPressed: signUp,
                              child: new Text("Create Account",
                                  style: new TextStyle(
                                      color: Colors.white, fontSize: 15.0)),
                              color: Colors.green[600],
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(30.0)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ))));
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
}
