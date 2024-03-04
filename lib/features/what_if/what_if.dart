import 'package:cached_network_image/cached_network_image.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:final_year_project_kiki/routes.dart';
import 'package:final_year_project_kiki/services/app.dart';
import 'package:final_year_project_kiki/state/app_state.dart';
import 'package:final_year_project_kiki/widgets/drop_down_field.dart';
import 'package:final_year_project_kiki/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WhatIfScreen extends ConsumerStatefulWidget {
  const WhatIfScreen({super.key});

  @override
  ConsumerState<WhatIfScreen> createState() => _WhatIfScreenState();
}

class _WhatIfScreenState extends ConsumerState<WhatIfScreen> {
  final _percentageController = TextEditingController();
  double _remainingAmount = 0;
  String? bottomPart;
  String? _selectedCurrency;
  String? _selectedChoice;
  bool _isLoading = false;
  double? _rate;
  final _budgets = Supabase.instance.client
      .from('budgets')
      .stream(primaryKey: ['id'])
      .eq('user_id', Supabase.instance.client.auth.currentUser!.id)
      .order('amount', ascending: true);

  final _savings = Supabase.instance.client
      .from('savings')
      .stream(primaryKey: ['id']).eq(
          'user_id', Supabase.instance.client.auth.currentUser!.id);

  @override
  void dispose() {
    _percentageController.dispose();
    super.dispose();
  }

  // Get exchange rate
  void _getExchangeRate() async {
    if (_percentageController.text.isEmpty || _selectedCurrency == null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final appService = ref.read(appApiProvider);
    final rate = await appService.getExchangeRate(
      fromCurrency: _selectedCurrency!,
      toCurrency: "NGN",
      ref: ref,
      onError: (String message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
        );
      },
    );

    setState(() {
      _isLoading = false;
      _rate = _selectedChoice == "Up"
          ? rate / double.parse(_percentageController.text)
          : rate * double.parse(_percentageController.text);
    });
  }

  // Calculate percentage
  double _calculatePercentage({
    required double amount,
    required double total,
  }) {
    if (amount > total) return 1.0;

    return amount / total;
  }

  // Spread savings
  List<double> _spreadSavings({
    required List<double> budgets,
    required double totalSavings,
    required int index,
  }) {
    double remainingAmount = totalSavings;
    List<double> remainingBudgets = [];

    // Iterate through each budget
    for (double budget in budgets) {
      // Check if there's enough savings to cover the budget
      if (remainingAmount >= budget) {
        remainingBudgets.add(budget);
        remainingAmount -= budget;
      } else {
        remainingBudgets.add(remainingAmount);
        remainingAmount = 0;
      }
    }
    if (index == budgets.length - 1) {
      _calculateTotalAmountLeft(
          total: totalSavings, remaining: remainingAmount);
    }

    return remainingBudgets;
  }

  // Calculate current amount in saved currency
  Future<double> _calculateCurrentAmountInSavedCurrency({
    required double amount,
    required String currency,
  }) async {
    final rate = await ref.read(appApiProvider).getExchangeRate(
          fromCurrency: "NGN",
          toCurrency: currency,
          ref: ref,
          onError: (_) {},
        );

    if (_selectedCurrency == currency) {
      return amount *
          rate /
          double.parse(_percentageController.text.isEmpty
              ? "1"
              : _percentageController.text);
    } else {
      return amount * rate;
    }
  }

  // Convert to NGN
  Future<double> _convertToNGN({
    required double amount,
    required String currency,
  }) async {
    final rate = await ref.read(appApiProvider).getExchangeRate(
          fromCurrency: currency,
          toCurrency: "NGN",
          ref: ref,
          onError: (_) {},
        );

    return amount * rate;
  }

  // Calculate remaining amount
  Future<String> _calculateRemainingAmount({
    required double amount,
    required double total,
    required String currency,
  }) async {
    double remaining = await _convertToNGN(
      amount: total - amount,
      currency: currency,
    );

    if (total - amount <= 0) {
      return "Well done you have enough for your budget!";
    }

    _remainingAmount += remaining;

    return "You need ${NumberFormat.currency(locale: "en_US", symbol: "NGN").format(remaining)} more to reach your goal";
  }

  // Calculate total amount left
  Future<String> _calculateTotalAmountLeft({
    required double total,
    required double? remaining,
  }) async {
    return "You will need a total of ${NumberFormat.currency(locale: "en_US", symbol: "NGN").format(_remainingAmount)} more - that's ${NumberFormat.currency(locale: "en_US", symbol: "NGN").format(total - _remainingAmount)} less than you need today";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffD8EBE9),
        title: const Text(
          "What If?",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  // Build the body of the screen
  Widget _buildBody() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            DropDownField(
              data: const ["Up", "Down"],
              hint: "Select Base Currency",
              selected: _selectedChoice,
              label: "Choice",
              onChanged: (String? value) {
                setState(() {
                  _selectedChoice = value;
                });
                _getExchangeRate();
              },
            ),
            SizedBox(height: 20.0.h),
            InputField(
              controller: _percentageController,
              hint: "percentage",
              validator: (String? value) => null,
              textInputType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              formatters: [
                CurrencyTextInputFormatter(
                  decimalDigits: 2,
                  symbol: '',
                ),
              ],
              onChanged: (String? value) => _getExchangeRate(),
              label:
                  "What if rate is ${_selectedChoice == "Up" ? "up by (in percentage)" : "down by (in percentage)"}",
            ),
            SizedBox(height: 20.0.h),
            DropDownField(
              data: ref.watch(currencies).map((e) => e.currency!).toList(),
              hint: "Select Base Currency",
              selected: _selectedCurrency,
              label: "Base Currency",
              onChanged: (String? value) {
                setState(() {
                  _selectedCurrency = value;
                });
                _getExchangeRate();
              },
            ),
            SizedBox(height: 20.0.h),
            _isLoading
                ? Center(
                    child: LoadingAnimationWidget.discreteCircle(
                      color: const Color(0xff165A4A),
                      size: 30.0.w,
                    ),
                  )
                : _rate == null
                    ? const SizedBox()
                    : Row(
                        children: [
                          Text(
                            "Rate will be: 1 ${_selectedCurrency ?? ""} = ${NumberFormat.currency(locale: "en_US", symbol: "NGN").format(_rate)}",
                            style: TextStyle(
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(width: 10.0.w),
                          SvgPicture.asset("assets/icons/sad.svg"),
                        ],
                      ),
            SizedBox(height: 20.0.h),
            Expanded(
              child: StreamBuilder(
                stream: _budgets,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  }
                  final budgets = snapshot.data!;
                  return StreamBuilder(
                    stream: _savings,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox();
                      }
                      final savings = snapshot.data!.first;

                      return ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (ctx, idx) {
                          return FutureBuilder(
                            future: _calculateCurrentAmountInSavedCurrency(
                              amount:
                                  double.parse(savings['amount'].toString()),
                              currency: budgets[idx]['currency'],
                            ),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const SizedBox();
                              }

                              final amount = snapshot.data as double;

                              final remainingBudgets = _spreadSavings(
                                budgets: budgets
                                    .map((e) =>
                                        double.parse(e['amount'].toString()))
                                    .toList(),
                                totalSavings: amount,
                                index: idx,
                              );

                              return _buildBudgetItem(
                                budget: budgets[idx],
                                index: idx,
                                spent: remainingBudgets[idx],
                                savings: savings,
                                total: budgets.length,
                              );
                            },
                          );
                        },
                        separatorBuilder: (ctx, idx) =>
                            SizedBox(height: 10.0.h),
                        itemCount: budgets.length,
                      );
                    },
                  );
                },
              ),
            ),
            // FutureBuilder(
            //   future: _calculateTotalAmountLeft(
            //     total: _remainingAmount,
            //     remaining: _remainingAmount,
            //   ),
            //   builder: (context, snapshot) {
            //     if (!snapshot.hasData) {
            //       return const SizedBox();
            //     }

            //     bottomPart = snapshot.data as String;

            //     return Text(
            //       bottomPart ?? '',
            //       style: TextStyle(
            //         color: Colors.black,
            //         fontSize: 16.0.sp,
            //         fontWeight: FontWeight.w400,
            //       ),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  // Build the budget item
  Widget _buildBudgetItem({
    required Map<String, dynamic> budget,
    required int index,
    required int total,
    required double spent,
    required Map<String, dynamic> savings,
  }) {
    final String publicUrl = Supabase.instance.client.storage
        .from('public-bucket')
        .getPublicUrl(budget['image']);

    // Split the URL based on '/'
    List<String> parts = publicUrl.split('/');

    // Iterate through the parts and remove 'public-bucket'
    List<String> updatedParts = [];
    for (String part in parts) {
      if (part != "public-bucket") {
        updatedParts.add(part);
      }
    }

    // Reconstruct the URL
    String updatedUrl = updatedParts.join('/');

    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).pushNamed(
          AppRoutes.editBudget,
          arguments: budget,
        );
        setState(() {});
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0.r),
          color: index % 2 != 0
              ? const Color(0xff82B9AE)
              : const Color(0xff165A4A),
        ),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: updatedUrl,
              imageBuilder: (context, imageProvider) => Container(
                width: 80.w,
                height: 100.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0.r),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: 80.w,
                height: 100.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0.r),
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(width: 20.0.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        budget['name'],
                        style: TextStyle(
                          color: index % 2 != 0 ? Colors.black : Colors.white,
                          fontSize: 20.0.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Icon(Icons.navigate_next, color: Colors.white),
                    ],
                  ),
                  SizedBox(height: 10.0.h),
                  Text(
                    "${NumberFormat.currency(locale: "en_US", symbol: budget['currency']).format(spent)} / ${NumberFormat.currency(locale: "en_US", symbol: budget['currency']).format(budget['amount'])}",
                    style: TextStyle(
                      color: index % 2 != 0 ? Colors.black : Colors.white,
                      fontSize: 14.0.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 10.0.h),
                  LinearPercentIndicator(
                    width: 180.0.w,
                    lineHeight: 8.0.w,
                    percent: _calculatePercentage(
                      amount: spent,
                      total: double.parse(budget['amount'].toString()),
                    ),
                    barRadius: Radius.circular(10.0.r),
                    backgroundColor: Colors.grey,
                    progressColor: Colors.blue,
                  ),
                  SizedBox(height: 10.0.h),
                  FutureBuilder(
                    future: _calculateRemainingAmount(
                      amount: spent,
                      total: double.parse(budget['amount'].toString()),
                      currency: budget['currency'],
                    ),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox();
                      }

                      final remaining = snapshot.data as String;

                      return Text(
                        remaining,
                        style: TextStyle(
                          color: index % 2 != 0 ? Colors.black : Colors.white,
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
