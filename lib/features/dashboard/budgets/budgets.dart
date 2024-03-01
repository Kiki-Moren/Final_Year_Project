import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_year_project_kiki/routes.dart';
import 'package:final_year_project_kiki/services/app.dart';
import 'package:final_year_project_kiki/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BudgetTab extends ConsumerStatefulWidget {
  const BudgetTab({super.key});

  @override
  ConsumerState<BudgetTab> createState() => _BudgetTabState();
}

class _BudgetTabState extends ConsumerState<BudgetTab> {
  final _budgets =
      Supabase.instance.client.from('budgets').stream(primaryKey: ['id']);

  final _savings = Supabase.instance.client
      .from('savings')
      .stream(primaryKey: ['id']).eq(
          'user_id', Supabase.instance.client.auth.currentUser!.id);

  double _calculatePercentage({
    required double amount,
    required double total,
  }) {
    if (amount > total) return 1.0;

    return amount / total * 10;
  }

  double _calculateAmountLeft({
    required double amount,
    required double total,
  }) {
    if (amount > total) return 0;

    return total - amount;
  }

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

    return amount * rate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      floatingActionButton: IconButton(
        onPressed: () => Navigator.of(context).pushNamed(AppRoutes.addBudget),
        icon: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add),
        ),
        iconSize: 30.0,
      ),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Center(
              child: Text(
                "My Goals",
                style: TextStyle(
                  fontSize: 24.0.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 20.0.h),
            _buildTotalSavingsContainer(),
            SizedBox(height: 20.0.h),
            Text(
              "Your Budget Today:",
              style: TextStyle(
                fontSize: 24.0.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            FutureBuilder(
              future: ref.read(appApiProvider).getExchangeRate(
                    fromCurrency: "GBP",
                    toCurrency: "NGN",
                    ref: ref,
                    onError: (_) {},
                  ),
              builder: (ctx, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                }

                final rate = snapshot.data as double;

                return Text(
                  "Rate Now: 1 GBP = ${rate.toStringAsFixed(2)} NGN",
                  style: TextStyle(
                    fontSize: 16.0.sp,
                    fontWeight: FontWeight.w400,
                  ),
                );
              },
            ),
            SizedBox(height: 20.0.h),
            StreamBuilder(
              stream: _budgets,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                }
                final budgets = snapshot.data!;
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (ctx, idx) => _buildBudgetItem(
                    budget: budgets[idx],
                    index: idx,
                  ),
                  separatorBuilder: (ctx, idx) => SizedBox(height: 10.0.h),
                  itemCount: budgets.length,
                );
              },
            ),
            SizedBox(height: 20.0.h),
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color(0xff82B9AE),
        borderRadius: BorderRadius.circular(20.0.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "But the exchange can and this will affect your budget",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.0.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 20.0.h),
          PrimaryButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.whatIf);
            },
            buttonText: "Find Out More",
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetItem({
    required Map<String, dynamic> budget,
    required int index,
  }) {
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
              imageUrl: 'https://picsum.photos/200',
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
                  StreamBuilder(
                      stream: _savings,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox();
                        }
                        final saving = snapshot.data!.first;
                        final balance = _calculateCurrentAmountInSavedCurrency(
                          amount: double.parse(saving['amount'].toString()),
                          currency: budget['currency'],
                        );
                        return FutureBuilder(
                            future: balance,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const SizedBox();
                              }

                              final balanc = snapshot.data as double;

                              return Text(
                                "${balanc.toStringAsFixed(2)} / ${budget['amount']} ${budget['currency']}",
                                style: TextStyle(
                                  color: index % 2 != 0
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 14.0.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              );
                            });
                      }),
                  SizedBox(height: 10.0.h),
                  StreamBuilder(
                      stream: _savings,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox();
                        }

                        final saving = snapshot.data!.first;
                        final percentage = _calculatePercentage(
                          amount: double.parse(saving['amount'].toString()),
                          total: double.parse(budget['amount'].toString()),
                        );

                        return LinearPercentIndicator(
                          width: 180.0.w,
                          lineHeight: 8.0.w,
                          percent: percentage,
                          barRadius: Radius.circular(10.0.r),
                          backgroundColor: Colors.grey,
                          progressColor: Colors.blue,
                        );
                      }),
                  SizedBox(height: 10.0.h),
                  StreamBuilder(
                      stream: _savings,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox();
                        }

                        final saving = snapshot.data!.first;
                        final amountLeft = _calculateAmountLeft(
                          amount: double.parse(saving['amount'].toString()),
                          total: double.parse(budget['amount'].toString()),
                        );

                        final balance = _calculateCurrentAmountInSavedCurrency(
                          amount: amountLeft,
                          currency: budget['currency'],
                        );

                        return FutureBuilder(
                            future: balance,
                            builder: (context, snapshot) {
                              return Text(
                                "You need ${snapshot.data} ${budget['currency']} more for tuition",
                                style: TextStyle(
                                  color: index % 2 != 0
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 14.0.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              );
                            });
                      }),
                ],
              ),
            ),
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
                    fontWeight: FontWeight.w800,
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
