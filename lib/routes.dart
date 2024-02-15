import 'package:final_year_project_kiki/features/budget/add.dart';
import 'package:final_year_project_kiki/features/budget/edit.dart';
import 'package:final_year_project_kiki/features/savings/savings.dart';
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
    addBudget: (context) => const AddBudgetScreen(),
    editBudget: (context) => const EditBudgetScreen(),
    topUpSaving: (context) => const SavingBudgetScreen(),
  };

  static String authentication = '/';
  static String signIn = '/sign-in';
  static String signUp = '/sign-up';
  static String dashboard = '/dashboard';
  static String addBudget = '/add-budget';
  static String editBudget = '/edit-budget';
  static String topUpSaving = '/top-up-saving';
}
