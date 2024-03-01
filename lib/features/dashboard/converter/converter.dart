import 'package:final_year_project_kiki/routes.dart';
import 'package:final_year_project_kiki/services/app.dart';
import 'package:final_year_project_kiki/state/app_state.dart';
import 'package:final_year_project_kiki/state/data.dart';
import 'package:final_year_project_kiki/widgets/drop_down_field.dart';
import 'package:final_year_project_kiki/widgets/input_field.dart';
import 'package:final_year_project_kiki/widgets/primary_button.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logger/logger.dart';

class CurrencyConverterTab extends ConsumerStatefulWidget {
  const CurrencyConverterTab({super.key});

  @override
  ConsumerState<CurrencyConverterTab> createState() =>
      _CurrencyConverterTabState();
}

class _CurrencyConverterTabState extends ConsumerState<CurrencyConverterTab> {
  final _amountController = TextEditingController();
  String? _fromCurrency;
  String? _toCurrency;
  bool _isLoading = false;
  double? _convertedAmount;

  void _convertCurrency() async {
    if (_toCurrency == null ||
        _fromCurrency == null ||
        _amountController.text.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    double amount = await ref.read(appApiProvider).getConversionValue(
          fromCurrency: _fromCurrency!,
          toCurrency: _toCurrency!,
          amount: double.parse(_amountController.text),
          ref: ref,
          onError: (_) {},
        );
    setState(() {
      _isLoading = false;
      _convertedAmount = amount;
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropDownField(
          data: ref.watch(currencies).map((e) => e.currency!).toList(),
          hint: "Select From Currency",
          selected: _fromCurrency,
          label: "From",
          onChanged: (String? value) {
            setState(() {
              _fromCurrency = value;
            });
          },
        ),
        SizedBox(height: 20.0.h),
        DropDownField(
          data: ref.watch(currencies).map((e) => e.currency!).toList(),
          hint: "Select To Currency",
          selected: _toCurrency,
          label: "To",
          onChanged: (String? value) {
            setState(() {
              _toCurrency = value;
            });
          },
        ),
        SizedBox(height: 20.0.h),
        InputField(
          controller: _amountController,
          hint: "Enter Amount to Convert",
          textInputType: TextInputType.number,
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return "Amount is required";
            }
            return null;
          },
          suffixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _isLoading
                ? LoadingAnimationWidget.discreteCircle(
                    color: const Color(0xFF165A4A), size: 30.0)
                : null,
          ),
          onChanged: (String? value) {
            _convertCurrency();
          },
          label: "Amount",
        ),
        if (_convertedAmount != null)
          Text(
            "1 $_fromCurrency = $_convertedAmount $_toCurrency",
            style: TextStyle(
              fontSize: 16.0.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
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
        if (_convertedAmount != null) _buildChart(),
      ],
    );
  }

  Widget _buildChart() {
    var exchangeRates = Data.exchangeRates
        .firstWhere((element) => element["currency"] == _toCurrency)["rates"]
        .map((e) => e["rate"])
        .toList();
    Logger().d(exchangeRates);

    var spots = <FlSpot>[];

    for (int i = 0; i < exchangeRates.length; i++) {
      spots.add(FlSpot(i.toDouble(), exchangeRates[i].toDouble()));
    }

    return SizedBox(
      width: double.infinity,
      height: 200.h,
      child: LineChart(
        LineChartData(
          titlesData: const FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(
            border: const Border(
              left: BorderSide(
                color: Color(0xFF165A4A),
                width: 2,
              ),
              bottom: BorderSide(
                color: Color(0xFF165A4A),
                width: 2,
              ),
            ),
          ),
          gridData: const FlGridData(show: false),
          lineBarsData: [
            LineChartBarData(
              // spots: const [
              //   FlSpot(1, Data.exchangeRates),
              // ],
              spots: spots,
              isCurved: true,
              barWidth: 4,
              isStrokeCapRound: true,
              // belowBarData: BarAreaData(show: false),
              // dotData: const FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
