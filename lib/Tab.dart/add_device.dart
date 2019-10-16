import 'package:flutter/material.dart';

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
  TextEditingController _textFieldController = TextEditingController();
  String email = '';
  String devicesId = '';
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
         TrackerApiService.listDevices(firebaseId, email).then((value) {
      setState(() {      
        devicesId = value['items'][0]['deviceId'];
      });
    });
      });
    });
    
    super.initState();
  }

  void addDevice(String deviceId) async {
    try {
     // String deviceId = "027022310239";
      var device =
          await TrackerApiService.addDevice(deviceId, firebaseId, email);
          
     if(device){
       devicesId = deviceId;
     }else{
        alertMessage('Wrong Device Number');
     }
    } catch (e) {}
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

   
  @override
  Widget build(BuildContext context) {   
    return new Scaffold(
        floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
         addDeviceDialog('deviceId');
        },
        label: Text('Add Device'),
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.green,
      ),
      body: ListView.separated(
        itemCount: 1,
        shrinkWrap: true,
        separatorBuilder: (context, index) => Divider(
          color:Colors.black,
        ),
        itemBuilder: (context, index) {
          return new Container(
            child: Padding(
                padding: EdgeInsets.all(5),
                child: new Row(
                  children: <Widget>[
                    Icon(
                      Icons.devices,
                      color:Colors.black,
                    ),
                  SizedBox(width: 20),
                    new Text(
                      devicesId,
                     
                    ),
                  
                  ],
                )),
          );
        },
      ),
    );


    
  }
  addDeviceDialog(String deviceId) {
    _textFieldController.text = '';
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add new device'),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Enter deviceID"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('Add Device'),
                onPressed: () async{               

                  Navigator.of(context).pop();
                  addDevice(_textFieldController.text);
                },
              )
            ],
          );
        });
  }
}
