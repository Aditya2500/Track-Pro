import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracking06/services/firebase_auth_service.dart';
import 'package:tracking06/services/http_request.dart';
import 'package:tracking06/utils/router.dart';
import 'package:tracking06/utils/sharedUtils.dart';

class ListDevices extends StatefulWidget {
  @override
  _ListDevicesState createState() => _ListDevicesState();
}

class _ListDevicesState extends State<ListDevices> {
  FirebaseAuthService service = FirebaseAuthService();
  String email = '';
  String deviceId = '';
  String firebaseId = '';
  List<Map> devices = [];
  @override
  void initState() {
   SessionStorage.getCurrentUser('user_email').then((value){
     setState(() {
       this.email = value;
      
     });         
   });
   SessionStorage.getCurrentUser('uid').then((value){
     setState(() {
        this.firebaseId = value;
        TrackerApiService.listDevices(this.firebaseId, this.email).then((value){
     setState(() {
        print('list ');
       print(value);
       devices = value;
     });        
   });
     });        
   });
   
   
    
    
    super.initState();
  }


  // @override
  // void initState() async {
  //   try {
  //     this.email = await SessionStorage.getCurrentUser('user_email');
  //     this.firebaseId = await SessionStorage.getCurrentUser('uid');
  //     await this.getDevices();
  //   }
  //   catch (error) {}
  //   super.initState();
  // }

  Future<void> getDevices() async {
    try {
      dynamic deviceListing =
          await TrackerApiService.listDevices(this.firebaseId, this.email);
         setState(() {
        devices = deviceListing.items;
      
      });
    } catch (error) {}
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
        body: new Container(
            child: new ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: ScreenUtil.instance.setHeight(50.0)),
          child: new Center(
            child: new Text('Track-Pro', style: TextStyle(fontSize: 30)),
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
              new Padding(
                padding: EdgeInsets.all(ScreenUtil.instance.setHeight(15.0)),
                child: new Container(
                  width: 30.0,
                  height: 50.0,
                  child: new RaisedButton(
                    onPressed: () {
                      Router.goToAddDevice(this.context);
                    },
                    child: new Text("AddDevice",
                        style:
                            new TextStyle(color: Colors.white, fontSize: 15.0)),
                    color: Colors.green[600],
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    )));
  }
}
