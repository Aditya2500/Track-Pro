import 'package:flutter/material.dart';

import 'screens/common/splash/screen.dart';
import 'screens/common/auth/screen.dart';
import 'screens/common/home/screen.dart';

final routes = {
  '/': (BuildContext context) => SplashScreen(),
  '/auth': (BuildContext context) => AuthScreen(),
  '/home': (BuildContext context) => HomeScreen(),
};
