import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'flavors.dart';
import 'routes.dart';
import 'utilities/methods.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: F.title,
          theme: ThemeData(
            fontFamily: "Kalam",
            scaffoldBackgroundColor: const Color(0xffD8EBE9),
            primarySwatch:
                AppMethods.createMaterialColor(const Color(0xFF165A4A)),
          ),
          initialRoute: AppRoutes.authentication,
          routes: AppRoutes.routes,
        );
      },
    );
  }
}
