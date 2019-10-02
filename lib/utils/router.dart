import 'package:flutter/material.dart';
import 'package:tracking06/GoogleMapHome.dart';
import 'package:tracking06/Registration.dart';
import 'package:tracking06/Signin.dart';
import 'package:tracking06/Signup.dart';
import 'package:tracking06/Tab.dart/add_device.dart';
import 'package:tracking06/Tab.dart/list_devices.dart';
import 'package:tracking06/forgotpassword.dart';
import 'package:tracking06/profile.dart';
import 'package:tracking06/tabs.dart';

import 'page_transition.dart';
import '../screens/common/splash/screen.dart';

import '../screens/parent/diary/screen.dart';


class Router {
  static void goToSplash(BuildContext context) {
    Navigator.push(
      context,
      PageTransition(widget: SplashScreen()),
    );
  }

  static void goToAuth(BuildContext context) {
     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
    UserSignin()), (Route<dynamic> route) => false);
    // Navigator.push(
    //   context,
      
    //  // PageTransition(widget: AuthScreen()),
    //  PageTransition(widget: UserSignin()),
    //  // PageTransition(widget: Register()),
    // );
  }
  static void goToForgotPassword(BuildContext context) {
    Navigator.push(
      context,      
      PageTransition(widget: ForgotPassword()),
    );
  }
   static void goToAddDevice(BuildContext context) {
    Navigator.push(
      context,      
      PageTransition(widget: AddDevice()),
    );
  }
  static void goToRegister(BuildContext context) {
    Navigator.push(
      context,      
     PageTransition(widget: Register()),
    );
  }
static void goToProfile(BuildContext context) {
    Navigator.push(
      context,      
      PageTransition(widget: ShowProfile()),
    );
  }
  static void goToHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
    ListDevices()), (Route<dynamic> route) => false);
    // Navigator.push(
    //   context,
    //  // PageTransition(widget: HomeScreen()),
    //   //PageTransition(widget: AddTabs()),
    //   PageTransition(widget: AddTabs()),
    // );
  }
   static void goToMap(BuildContext context) {
    Navigator.push(
      context,
      PageTransition(widget: GoogleMapHome()),
    );
  }

  static void backToHome(BuildContext context) {
    Navigator.pop(context);
  }

  static void goToDiary(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DiaryScreen()),
    );
  }
  static void goToUserSignIn(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserSignin()),
    );
  }
}