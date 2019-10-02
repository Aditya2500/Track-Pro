import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracking06/services/firebase_auth_service.dart';


class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  FirebaseAuthService service = FirebaseAuthService();
  void resetPassword() async {
      final FormState form = _formKey.currentState;
       form.save();
      if (emails.isNotEmpty) {        
        if (!form.validate()) {
          alertMessage('form is not valid!');
        } else {         
          await service.resetPassword(emails);
          alertMessage('Reset link sent on email address ' + emails);
        }
      } else {
        alertMessage('Email Address is empty!');
      }    
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

  String emails = '';
  String passwords = '';

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
       // backgroundColor: Colors.blueGrey[900],
        appBar: AppBar(
          title: Text('Reset password'),
           automaticallyImplyLeading: true,
        leading: IconButton(icon:Icon(Icons.arrow_back),
          onPressed:() => Navigator.pop(context, false),
        )
        ),
       
         body: new Container(
        //              decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage("images/loginscreen.jpg"),
        //     fit: BoxFit.cover,
        //   ),
        // ),
            child: new Form(
                key: _formKey,
                autovalidate: true,
                child: new ListView(
                  children: <Widget>[                 
                    
                    new Padding(
                      padding:  EdgeInsets.only(
                          left: ScreenUtil.instance.setHeight(8.0),
                          right: ScreenUtil.instance.setHeight(8.0),
                          top: ScreenUtil.instance.setHeight(200.0)),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          new Container(
                             child: new ListTile(
                                leading: const Icon(Icons.email,
                                  ),
                                title: new TextFormField(
                                 
                                  validator: (val) => !EmailValidator.validate(
                                          val)
                                      ? 'Please enter a valid email address!'
                                      : null,
                                  onSaved: (val) => emails = val,
                                  decoration: new InputDecoration(
                                   
                                    hintText: "Email",
                                  
                                  ),
                                ),
                              ),
                          ),
                          new Padding(
                            padding:  EdgeInsets.all(
                           ScreenUtil.instance.setHeight(10.0)),
                          ),
                         
                          new Container(
                            width: 100.0,
                            height: 50.0,
                            child: new RaisedButton(
                              onPressed: resetPassword,
                              child: new Text("Reset Password",
                                  style: new TextStyle(
                                      color: Colors.white, fontSize: 15.0)),
                              color: Colors.green[600],
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(30.0)),
                            ),
                          ),
                          new Padding(padding: new EdgeInsets.only(top: 15.0)),
                         
                        ],
                      ),
                    ),
                  ],
                ))));
  }
}
