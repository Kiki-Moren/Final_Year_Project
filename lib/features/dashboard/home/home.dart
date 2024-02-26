import 'package:final_year_project_kiki/routes.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final _savings = Supabase.instance.client
      .from('savings')
      .stream(primaryKey: ['id']).eq(
          'user_id', Supabase.instance.client.auth.currentUser!.id);

  final _user = Supabase.instance.client
      .from('users')
      .stream(primaryKey: ['id']).eq(
          'user_id', Supabase.instance.client.auth.currentUser!.id);
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  Widget _buildBody() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            StreamBuilder(
              stream: _user,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                }
                final user = snapshot.data!.first;
                return Text(
                  "Hello ${user['username']},",
                  style: TextStyle(
                    fontSize: 24.0.sp,
                    fontWeight: FontWeight.w400,
                  ),
                );
              },
            ),
            SizedBox(height: 20.0.h),
            _buildTotalSavingsContainer(),
            SizedBox(height: 20.0.h),
            _buildCreateNewBudgetButton(),
            SizedBox(height: 20.0.h),
            _buildRecentActivities(),
            SizedBox(height: 20.0.h),
            _buildExchangeRate(),
            SizedBox(height: 20.0.h),
            Text(
              "Did You Know?",
              style: TextStyle(
                fontSize: 24.0.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            Container(
              color: const Color(0xff165A4A),
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Did you know that NGN fell more than 50% against GBP last year",
                style: TextStyle(
                  fontSize: 14.0.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExchangeRate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Exchange Rate",
          style: TextStyle(
            fontSize: 24.0.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        _buildChart(),
      ],
    );
  }

  Widget _buildChart() {
    return SizedBox(
      width: double.infinity,
      height: 200.h,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 3),
                FlSpot(1, 4),
                FlSpot(2, 3.5),
                FlSpot(3, 5),
                FlSpot(4, 4),
                FlSpot(5, 6),
              ],
              isCurved: true,
              barWidth: 4,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recent Activies",
          style: TextStyle(
            fontSize: 24.0.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        _buildRecentItem(
          leadingIcon: SvgPicture.asset("assets/icons/budget.svg"),
          title: "Add New Budget",
          description: "08:00am",
          onPressed: () {},
        ),
        SizedBox(height: 5.0.h),
        _buildRecentItem(
          leadingIcon: SvgPicture.asset("assets/icons/profile.svg"),
          title: "Profile Information",
          description: "1 day ago",
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildRecentItem({
    required String title,
    required String description,
    required Function() onPressed,
    required Widget leadingIcon,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: const Color(0xff165A4A),
          borderRadius: BorderRadius.circular(8.0.r),
          border: Border.all(color: Colors.grey),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              leadingIcon,
              SizedBox(width: 10.0.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                    Text(
                      description,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreateNewBudgetButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.addBudget);
      },
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage("assets/images/create.png"),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(20.0.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Create New Budget",
                    style: TextStyle(
                      fontSize: 24.0.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10.0.h),
                  Text(
                    "Create a new budget to start saving",
                    style: TextStyle(
                      fontSize: 14.0.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 20.0.w),
            SvgPicture.asset("assets/icons/money_bag.svg"),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSavingsContainer() {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(AppRoutes.topUpSaving),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage("assets/images/total_savings_bg.png"),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(20.0.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total Savings",
              style: TextStyle(
                fontSize: 24.0.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20.0.h),
            StreamBuilder(
              stream: _savings,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                }
                final saving = snapshot.data!.first;
                return Text(
                  '₦${saving['amount'].toString()}',
                  style: TextStyle(
                    fontSize: 24.0.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                );
              },
            ),
            SizedBox(height: 10.0.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Edit',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
