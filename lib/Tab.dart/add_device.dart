import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracking06/services/firebase_auth_service.dart';
import 'package:tracking06/services/http_request.dart';
import 'package:tracking06/utils/router.dart';
import 'package:tracking06/utils/sharedUtils.dart';

class AddDevice extends StatefulWidget {
  @override
  _AddDeviceState createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> {
  FirebaseAuthService service = FirebaseAuthService();
  String email = '';
  String deviceId = '';
  String firebaseId = '';

  @override
  void initState() {
    SessionStorage.getCurrentUser('user_email').then((value) {
      setState(() {
        email = value;
      });
    });
    SessionStorage.getCurrentUser('uid').then((value) {
      setState(() {
        firebaseId = value;
      });
    });
    super.initState();
  }

  void addDevice() async {
    try {
      print('emails -' + email);
      String deviceId = "027022310239";
      var device =
          await TrackerApiService.addDevice(deviceId, firebaseId, email);
      print(device);
      Router.goToHome(this.context);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    if (email == '') {
      return Text("loading...");
    }
    double defaultScreenWidth = 400.0;
    double defaultScreenHeight = 810.0;
    ScreenUtil.instance = ScreenUtil(
      width: defaultScreenWidth,
      height: defaultScreenHeight,
      allowFontScaling: true,
    )..init(context);
    return new Scaffold(
       appBar: AppBar(
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            )),
        body: new Container(
            child: new Form(
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
                                    onSaved: (val) => deviceId = val,
                                    decoration: new InputDecoration(
                                      hintText: "Device Id",
                                    ),
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
                                onPressed: addDevice,
                                child: new Text("Add Device",
                                    style: new TextStyle(
                                        color: Colors.white, fontSize: 15.0)),
                                color: Colors.green[600],
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ))));
  }
}
