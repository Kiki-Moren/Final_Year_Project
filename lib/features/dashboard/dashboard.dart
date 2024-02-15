import 'package:final_year_project_kiki/features/dashboard/budgets/budgets.dart';
import 'package:final_year_project_kiki/features/dashboard/converter/converter.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'account/account.dart';
import 'home/home.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: _buildNavBar(),
    );
  }

  Widget _buildBody() {
    return _selectedIndex == 0
        ? const HomeTab()
        : _selectedIndex == 1
            ? const BudgetTab()
            : _selectedIndex == 2
                ? const CurrencyConverterTab()
                : const AccountTab();
  }

  Widget _buildNavBar() {
    return FlashyTabBar(
      selectedIndex: _selectedIndex,
      showElevation: true,
      onItemSelected: (index) => setState(() {
        _selectedIndex = index;
      }),
      items: [
        FlashyTabBarItem(
          icon: const Icon(CupertinoIcons.home),
          title: const Text('Home'),
        ),
        FlashyTabBarItem(
          icon: const Icon(CupertinoIcons.chart_bar_circle),
          title: const Text('Budgets'),
        ),
        FlashyTabBarItem(
          icon: const Icon(CupertinoIcons.money_dollar_circle),
          title: const Text('Convert'),
        ),
        FlashyTabBarItem(
          icon: const Icon(CupertinoIcons.profile_circled),
          title: const Text('Profile'),
        ),
      ],
    );
  }
}
