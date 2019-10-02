import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tracking06/services/firebase_auth_service.dart';
import 'package:tracking06/utils/router.dart';
import 'package:tracking06/utils/sharedUtils.dart';

class AddDrawer extends StatefulWidget {
  @override
  _AddDrawerState createState() => _AddDrawerState();
}

class _AddDrawerState extends State<AddDrawer> {
  FirebaseAuthService service = FirebaseAuthService();
  String userName = '';
  String userEmail = '';
  String firstLetter = '';
  String email = '';
  String name = '';
  String displayName = '';
  String firstName = '';
  String lastName = '';

  void initState() {
     SessionStorage.getCurrentUser('user_email').then((value) {
      setState(() {
        email = value;
      });
    });
    SessionStorage.getCurrentUser('displayName').then((value) {
      setState(() {
        if (value != 'NotFound') {
          displayName = value;
        }
      });
    });
    SessionStorage.getCurrentUser('firstName').then((value) {
      setState(() {
        if (value != 'NotFound') {
          firstName = value;
        }
      });
    });
    SessionStorage.getCurrentUser('lastName').then((value) {
      setState(() {
        if (value != 'NotFound') {
          lastName = value;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (email == '') {
      return Text("loading...");
    }

if (displayName == 'NotFound') {
      displayName = '';
    }
   

    if (email != null || email != '') {
      userEmail = email;
      if (userEmail != '') {
        firstLetter = userEmail.split('')[0].toUpperCase();
      }
    }

    if (displayName != '') {
      userName = displayName;
    }
    if (firstName != '') {
      userName = firstName;
      if (lastName != '') {
        userName = userName + ' ' + lastName;
      }
    }

    return new Drawer(
        child: new ListView(
            padding: const EdgeInsets.only(top: 0.0),
            children: <Widget>[
          new UserAccountsDrawerHeader(
              accountName: Text(userName),
              accountEmail: Text(userEmail),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.brown,
              ),
              otherAccountsPictures: <Widget>[
                new GestureDetector(
                  onTap: () => _onTapOtherAccounts(context),
                  child: new Semantics(
                    label: 'Switch Account',
                    child: new CircleAvatar(
                      backgroundColor: Colors.brown,
                      child: new Text(firstLetter),
                    ),
                  ),
                )
              ]),
          new ListTile(
            leading: new Icon(Icons.photo),
            title: new Text('Profile'),
            onTap: () {
              Router.goToProfile(context);
            },
          ),
          new Divider(),
          // new ListTile(
          //   leading: new Text('Label'),
          //   trailing: new Text('Edit'),
          //   onTap: () => _onListTileTap(context),
          // ),
          new ListTile(
            leading: new Icon(Icons.calendar_view_day),
            title: new Text('View Attendance'),
            onTap: () => _onListTileTap(context),
          ),
          new ListTile(
            leading: new Icon(Icons.shutter_speed),
            title: new Text('Speed Limit'),
            onTap: () => _onListTileTap(context),
          ),
          new ListTile(
            leading: new Icon(Icons.payment),
            title: new Text('Manage Payment'),
            onTap: () => _onListTileTap(context),
          ),

          new ListTile(
            leading: new Icon(Icons.offline_pin),
            title: new Text('Logout'),
            onTap: logout,
          ),
          new ListTile(
            leading: new Icon(Icons.supervised_user_circle),
            title: new Text('Support'),
            onTap: () => _onListTileTap(context),
          ),
          new ListTile(
            leading: new Icon(Icons.rate_review),
            title: new Text('Rate Us'),
            onTap: () => _onListTileTap(context),
          ),
        ]));
  }

  void logout() async {
    var isLoggedOut = await service.signoutFirebase();
    print(isLoggedOut);
    if (isLoggedOut != null) {
      print(isLoggedOut);
      await SessionStorage.removeCurrentUser('user_email');
      await SessionStorage.removeCurrentUser('displayName');
      await SessionStorage.removeCurrentUser('photoUrl');
      await SessionStorage.removeCurrentUser('uid');
      await SessionStorage.removeCurrentUser('firstName');
      await SessionStorage.removeCurrentUser('lastName');
      await SessionStorage.removeCurrentUser('phoneNumber');
      await SessionStorage.removeCurrentUser('gender');
      await SessionStorage.removeCurrentUser('dateOfBirth');
      Router.goToAuth(this.context);
    }
  }
}

_onTapOtherAccounts(BuildContext context) {
  Navigator.of(context).pop();
  showDialog<Null>(
    context: context,
    child: new AlertDialog(
      title: const Text('Account switching not implemented.'),
      actions: <Widget>[
        new FlatButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}

_onListTileTap(BuildContext context) {
  Navigator.of(context).pop();
  showDialog<Null>(
    context: context,
    child: new AlertDialog(
      title: const Text('Not Implemented'),
      actions: <Widget>[
        new FlatButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}
