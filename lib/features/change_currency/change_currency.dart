// ignore_for_file: use_build_context_synchronously

import 'package:final_year_project_kiki/services/app.dart';
import 'package:final_year_project_kiki/state/app_state.dart';
import 'package:final_year_project_kiki/widgets/drop_down_field.dart';
import 'package:final_year_project_kiki/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChangeCurrencyScreen extends ConsumerStatefulWidget {
  const ChangeCurrencyScreen({super.key});

  @override
  ConsumerState<ChangeCurrencyScreen> createState() =>
      _ChangeCurrencyScreenState();
}

class _ChangeCurrencyScreenState extends ConsumerState<ChangeCurrencyScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _currency;
  bool _loading = false;

  Future<double> _calculateCurrentAmountInSavedCurrency({
    required double amount,
    required String fromCurrency,
    required String currency,
  }) async {
    final rate = await ref.read(appApiProvider).getExchangeRate(
          fromCurrency: fromCurrency,
          toCurrency: currency,
          ref: ref,
          onError: (_) {},
        );

    return amount * rate;
  }

  void _updateBaseCurrency() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });

      final savings = await Supabase.instance.client
          .from('savings')
          .select()
          .eq('user_id', Supabase.instance.client.auth.currentUser!.id)
          .single();

      final amount = await _calculateCurrentAmountInSavedCurrency(
        amount: double.parse(savings['amount'].toString()),
        currency: _currency!,
        fromCurrency: savings['base_currency'],
      );

      try {
        await Supabase.instance.client.from('users').update({
          'base_currency': _currency,
        }).match({'user_id': Supabase.instance.client.auth.currentUser!.id});

        await Supabase.instance.client.from('savings').update({
          'base_currency': _currency,
          'amount': amount,
        }).match({'user_id': Supabase.instance.client.auth.currentUser!.id});

        setState(() {
          _loading = false;
        });

        Navigator.pop(context);
      } catch (e) {
        setState(() {
          _loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred. Please try again.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffD8EBE9),
        title: const Text(
          "Change Currency",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropDownField(
                data: ref.watch(currencies).map((e) => e.currency!).toList(),
                hint: "Select Currency",
                label: "Currency",
                selected: _currency,
                onChanged: (String? value) {
                  setState(() {
                    _currency = value;
                  });
                },
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "Currency is required";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0.h),
              PrimaryButton(
                onPressed: _updateBaseCurrency,
                isLoading: _loading,
                buttonText: "Update Currency",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
