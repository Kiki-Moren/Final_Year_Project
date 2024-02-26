import 'package:final_year_project_kiki/routes.dart';
import 'package:final_year_project_kiki/widgets/drop_down_field.dart';
import 'package:final_year_project_kiki/widgets/input_field.dart';
import 'package:final_year_project_kiki/widgets/primary_button.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CurrencyConverterTab extends StatefulWidget {
  const CurrencyConverterTab({super.key});

  @override
  State<CurrencyConverterTab> createState() => _CurrencyConverterTabState();
}

class _CurrencyConverterTabState extends State<CurrencyConverterTab> {
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
            Center(
              child: Text(
                "Hello Kiki,",
                style: TextStyle(
                  fontSize: 24.0.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 20.0.h),
            _buildForm(),
            SizedBox(height: 20.0.h),
            _buildExchangeRate(),
            SizedBox(height: 20.0.h),
            PrimaryButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.addBudget),
              buttonText: 'Create A Budget',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        const DropDownField(
          data: ["USD", "NGN", "GBP"],
          hint: "Select From Currency",
          selected: "USD",
          label: "From",
        ),
        SizedBox(height: 20.0.h),
        const DropDownField(
          data: ["USD", "NGN", "GBP"],
          hint: "Select From Currency",
          selected: "USD",
          label: "To",
        ),
        SizedBox(height: 20.0.h),
        InputField(
          controller: TextEditingController(),
          hint: "Enter Amount to Convert",
          validator: (String? name) => null,
          label: "Amount",
        ),
        const Text("1 NGN = 0.50 GBP"),
      ],
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
              spots: const [
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
}
