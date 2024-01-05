import 'package:flutter/material.dart';

import 'features/authentication/authentication.dart';
import 'features/authentication/sign_in.dart';
import 'features/authentication/sign_up.dart';
import 'features/dashboard/dashboard.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    authentication: (context) => const AuthenticationScreen(),
    signIn: (context) => const SignInScreen(),
    signUp: (context) => const SignUpScreen(),
    dashboard: (context) => const DashboardScreen(),
  };

  static String authentication = '/';
  static String signIn = '/sign-in';
  static String signUp = '/sign-up';
  static String dashboard = '/dashboard';
}
