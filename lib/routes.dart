import 'package:flutter/material.dart';

import 'features/authentication/authentication.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    authentication: (context) => const AuthenticationScreen(),
  };

  static String authentication = '/';
}
