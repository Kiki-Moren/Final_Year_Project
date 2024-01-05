import 'package:flutter/material.dart';

import 'features/authentication/authentication.dart';
import 'features/authentication/sign_in.dart';
import 'features/authentication/sign_up.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    authentication: (context) => const AuthenticationScreen(),
    signIn: (context) => const SignInScreen(),
    signUp: (context) => const SignUpScreen(),
  };

  static String authentication = '/';
  static String signIn = '/sign-in';
  static String signUp = '/sign-up';
}
