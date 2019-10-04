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
   
    return new Scaffold(
       
        body: new Container(
          child:Center(child: Text('Under Development')),
    ));
  }
}
