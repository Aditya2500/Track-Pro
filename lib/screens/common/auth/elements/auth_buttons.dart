import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final Function onTap;

  AuthButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return (
      Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24.0),
          child: InkWell(
            onTap: () { onTap(); },
            child: Container(
              height: 40.0,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: new BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        )
      )
    );
  }
}

class GoogleAuthButton extends StatelessWidget {
  final Function onTap;

  GoogleAuthButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return (
      Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: InkWell(
            onTap: () { onTap(); },
            child: new Container(
              padding: EdgeInsets.all(10.0),
              height: 60.0,
              decoration: BoxDecoration(
                color: Colors.primaries[0],
                borderRadius: new BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Text(
                  'Signin with Google',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        )
      )
    );
  }
}

class SignOutButton extends StatelessWidget {
  final Function onTap;

  SignOutButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return (
      Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: InkWell(
            onTap: () { onTap(); },
            child: new Container(
              height: 40.0,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: new BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Text(
                  'Sign Out',
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
              ),
            ),
          )
        )
      )
    );
  }
}