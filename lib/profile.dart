import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracking06/services/firebase_auth_service.dart';
import 'package:tracking06/services/firebase_database.dart';
import 'package:tracking06/utils/sharedUtils.dart';
import 'utils/router.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class ShowProfile extends StatefulWidget {
  @override
  __ShowProfileState createState() => __ShowProfileState();
}

class __ShowProfileState extends State<ShowProfile> {
  FirebaseAuthService service = FirebaseAuthService();

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _key = new GlobalKey<FormFieldState>();

  List<DropdownMenuItem<String>> gList = [
    DropdownMenuItem(
        child: Text(
          'Select',
          textAlign: TextAlign.center,
        ),
        value: 'Select'),
    DropdownMenuItem(
        child: Text(
          'Male',
          textAlign: TextAlign.center,
        ),
        value: 'Male'),
    DropdownMenuItem(
        child: Text(
          'Female',
          textAlign: TextAlign.center,
        ),
        value: 'Female'),
    DropdownMenuItem(
        child: Text(
          'Other',
          textAlign: TextAlign.center,
        ),
        value: 'Other')
  ];
  UserFirebase database = new UserFirebase();
  Future<void> updateProfile() async {
    try {
      final FormState form = _formKey.currentState;
      form.save();
      if (!form.validate()) {
       return false;
      } else if (dateOfBirth == 'null' || dateOfBirth == '') {
        return false;
      } else if (gender == 'Select') {
        return false;
      } else {
        _submitDialog(context);
        bool exists = await database.isUserExists(email);
        if (!exists) {
          Navigator.of(context).pop();
          alertMessage('User does not exists!');
          return false;
        }
        var posted = await database.updateUserInfo(
          firstName,
          lastName,
          email,
          phoneNumber,
          dateOfBirth,
          gender,
          '',
          email,
        );
        if (posted) {
          Router.goToHome(this.context);
        } else {
          Navigator.of(context).pop();
          alertMessage('Something went wrong!');
        }
      }
    } catch (e) {
      Navigator.of(context).pop();
      alertMessage('Something went wrong!');
    }
  }

  String firstName = '';
  String lastName = '';
  String phoneNumber = '';
  String gender = 'Select';
  String dateOfBirth = '';
  String email = '';
  String uid = '';
  String displayName = '';

  @override
  void initState() {
    SessionStorage.getCurrentUser('user_email').then((value) {
      setState(() {
        email = value;
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
    SessionStorage.getCurrentUser('phoneNumber').then((value) {
      setState(() {
        if (value != 'NotFound') {
          phoneNumber = value;
        }
      });
    });
    SessionStorage.getCurrentUser('gender').then((value) {
      setState(() {
        if (value != 'NotFound') {
          gender = value;
        }
      });
    });
    SessionStorage.getCurrentUser('dateOfBirth').then((value) {
      setState(() {
        if (value != 'NotFound') {
          dateOfBirth = value;
        }
      });
    });
    SessionStorage.getCurrentUser('uid').then((value) {
      setState(() {
        uid = value;
      });
    });
    SessionStorage.getCurrentUser('displayName').then((value) {
      setState(() {
        if (value != 'NotFound') {
          displayName = value;
        }
      });
    });
    super.initState();
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

  int year = 2000;
  int month = 6;
  int day = 23;

  @override
  Widget build(BuildContext context) {
    if (email == '') {
      return Text("loading...");
    }
    if (displayName == 'NotFound') {
      displayName = '';
    }
    if (dateOfBirth == 'NotFound') {
      dateOfBirth = '';
    }
    if (dateOfBirth == 'null') {
      dateOfBirth = '';
    }
    if (displayName != '' && displayName != null) {
      var name = displayName.split(' ');
      if (firstName == '') {
        if (name.length > 0) {
          firstName = name[0];
        }
        if (name.length > 1) {
          lastName = name[1];
        }
      }
    }

    if (dateOfBirth != '') {
      var dob = dateOfBirth.split(' ')[0];
      var date = dob.split('-');
      if (date.length > 0) {
        year = int.tryParse(date[0]);
      }
      if (date.length > 1) {
        month = int.tryParse(date[1]);
      }
      if (date.length > 2) {
        day = int.tryParse(date[2]);
      }
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
            //`true` if you want Flutter to automatically add Back Button when needed,
            //or `false` if you want to force your own back button every where
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            )),
        //backgroundColor: Colors.lightBlue[900],
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
                    new Padding(
                      padding: EdgeInsets.only(
                          left: ScreenUtil.instance.setHeight(8.0),
                          right: ScreenUtil.instance.setHeight(8.0),
                          top: ScreenUtil.instance.setHeight(100.0)),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          new Row(
                            children: <Widget>[
                              new Expanded(
                                child: new ListTile(
                                  leading: const Icon(
                                    Icons.person,
                                  ),
                                  title: new TextFormField(
                                    showCursor: true,
                                    initialValue: firstName,
                                    validator: (val) => val.isEmpty ? '' : null,
                                    onSaved: (val) => firstName = val,
                                    decoration: new InputDecoration(
                                      hintText: "First Name",
                                    ),
                                  ),
                                ),
                              ),
                              new Expanded(
                                child: new TextFormField(
                                  initialValue: lastName,
                                  validator: (val) => val.isEmpty ? '' : null,
                                  onSaved: (val) => lastName = val,
                                  decoration: new InputDecoration(
                                    hintText: "Last Name",
                                  ),
                                ),
                              )
                            ],
                          ),
                          new Row(
                            children: <Widget>[
                              new Expanded(
                                child: new ListTile(
                                  leading: const Icon(
                                    Icons.email,
                                  ),
                                  title: new TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    initialValue: email,
                                    validator: (val) => val.isEmpty
                                        ? ''
                                        : !EmailValidator.validate(val)
                                            ? ''
                                            : null,
                                    onSaved: (val) => email = val,
                                    decoration: new InputDecoration(
                                      hintText: "Email",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          new Row(
                            children: <Widget>[
                              new Expanded(
                                child: new ListTile(
                                  leading: const Icon(
                                    Icons.phone,
                                  ),
                                  title: new TextFormField(
                                    keyboardType: TextInputType.phone,
                                    initialValue: phoneNumber,
                                    validator: (val)=>phoneNumberValidation(val),
                                    onSaved: (val) => phoneNumber = val,
                                    decoration: new InputDecoration(
                                      hintText: "+91 Phone",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          new Row(
                            children: <Widget>[
                              new Expanded(
                                child: new ListTile(
                                  leading: const Icon(
                                    Icons.date_range,
                                  ),
                                  title: DateTimeField(
                                      showCursor: true,
                                      readOnly: true,
                                      initialValue: DateTime(year, month, day),
                                      onSaved: (val) =>
                                          dateOfBirth = val.toString(),
                                          validator: (val)=>val.toString()=='null'?'':null,
                                      decoration: new InputDecoration(
                                        hintText: "Date of Birth",
                                      ),
                                      format: DateFormat("dd-MM-yyyy"),
                                      onShowPicker:
                                          (context, currentValue) async {
                                        return await showDatePicker(
                                            context: context,
                                            firstDate: DateTime(1900),
                                            initialDate:
                                                currentValue ?? DateTime.now(),
                                            lastDate: DateTime(2100));
                                      }),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              new Expanded(
                                  child: new ListTile(
                                leading: const Icon(
                                  Icons.group,
                                ),
                                title: DropdownButtonFormField(
                                  items: gList,
                                  onChanged: (val) {
                                    setState(() {
                                      this.gender = val;
                                    });
                                  },
                                  value: this.gender,
                                  onSaved: (val) => gender = val,
                                  validator: (val) => val =='Select' ? '' : null,
                                ),
                              ))
                            ],
                          ),
                          new Padding(
                            padding: EdgeInsets.all(
                                ScreenUtil.instance.setHeight(10.0)),
                          ),
                          new Container(
                            width: 100.0,
                            height: 50.0,
                            child: new RaisedButton(
                              onPressed: updateProfile,
                              child: new Text("Update",
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

  String phoneNumberValidation(String value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10}$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return '';
    } else if (!regExp.hasMatch(value)) {
      return '';
    }
    return null;
  }
}
