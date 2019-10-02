import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracking06/services/firebase_auth_service.dart';
import 'package:tracking06/services/firebase_database.dart';
import 'utils/router.dart';
import 'package:intl/intl.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  FirebaseAuthService service = FirebaseAuthService();
  List<DropdownMenuItem<String>> genderList = [
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

  Future<void> signUp() async {
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
        if (exists) {
          Navigator.of(context).pop();
          alertMessage('User with this email address is already exists!');
          return false;
        }
        String child = email.replaceAll('@', '').replaceAll('.', '');
        var user = await service.createAccountFirebase(email, password);
        if (user != null) {
          var posted = await database.createUserInfo(firstName, lastName, email,
              phoneNumber, dateOfBirth, gender, password, child);
          if (posted) {
            Router.goToHome(this.context);
          }
        } else {
          Navigator.of(context).pop();
          alertMessage('Something went wrong!K');
        }
      }
    } catch (e) {
      Navigator.of(context).pop();
      alertMessage('Something went wrong!' + e.toString());
    }
  }

  String firstName = '';
  String lastName = '';
  String phoneNumber = '';
  String gender = 'Select';
  String dateOfBirth = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  bool _obscureText = true;
  bool _confObscureText = true;

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
                                  leading: Icon(
                                    Icons.phone,
                                       ),                                  
                                  title: new TextFormField(
                                    keyboardType: TextInputType.phone,
                                    validator: (val) => phoneNumberValidation(val),
                                    onSaved: (val) => phoneNumber = val,
                                    decoration: new InputDecoration(
                                      //prefixText: '+91 ',
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
                                    onSaved: (val) =>
                                        dateOfBirth = val.toString(),
                                        validator: (val)=>val.toString()=='null'?'':null,
                                    decoration: new InputDecoration(
                                      hintText: "Date of Birth",
                                    ),
                                    format: DateFormat("dd-MM-yyyy"),
                                    onShowPicker: (context, currentValue) {
                                      return showDatePicker(
                                          context: context,
                                          firstDate: DateTime(1900),
                                          initialDate:
                                              currentValue ?? DateTime.now(),
                                          lastDate: DateTime(2100));
                                    },
                                  ),
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
                                  items: genderList,
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
                          new Row(
                            children: <Widget>[
                              new Expanded(
                                child: new ListTile(
                                  leading: const Icon(
                                    Icons.lock,
                                  ),
                                  title: new TextFormField(
                                    validator: (val) {
                                      var mediumRegex = new RegExp(
                                          "^(((?=.*[a-z])(?=.*[A-Z]))|((?=.*[a-z])(?=.*[0-9]))|((?=.*[A-Z])(?=.*[0-9])))(?=.{6,})");
                                      if (val.isEmpty) {
                                        return '';
                                      } else if (!mediumRegex.hasMatch(val)) {
                                        return 'weak!';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (val) => password = val,
                                    key: _key,
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
                              ),
                            ],
                          ),
                          new Row(
                            children: <Widget>[
                              new Expanded(
                                child: new ListTile(
                                  leading: const Icon(
                                    Icons.lock,
                                  ),
                                  title: new TextFormField(
                                    validator: (val) =>
                                        _key.currentState.value != val
                                            ? 'Password does not match'
                                            : null,
                                    onSaved: (val) => confirmPassword = val,
                                    obscureText: _confObscureText,
                                    decoration: new InputDecoration(
                                        hintText: "Confirm Password",
                                        suffixIcon: GestureDetector(
                                          child: Icon(
                                            Icons.remove_red_eye,
                                          ),
                                          onTap: () {
                                            setState(() {
                                              _confObscureText =
                                                  !_confObscureText;
                                            });
                                          },
                                        )),
                                  ),
                                ),
                              ),
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
                              onPressed: signUp,
                              child: new Text("Register",
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
