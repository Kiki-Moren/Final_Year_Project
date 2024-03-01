// ignore_for_file: use_build_context_synchronously

import 'package:final_year_project_kiki/services/app.dart';
import 'package:final_year_project_kiki/widgets/input_field.dart';
import 'package:final_year_project_kiki/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SavingBudgetScreen extends ConsumerStatefulWidget {
  const SavingBudgetScreen({super.key});

  @override
  ConsumerState<SavingBudgetScreen> createState() => _SavingBudgetScreenState();
}

class _SavingBudgetScreenState extends ConsumerState<SavingBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _topUpSavings() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final savings = await Supabase.instance.client
          .from('savings')
          .select()
          .eq('user_id', Supabase.instance.client.auth.currentUser!.id)
          .single();

      await Supabase.instance.client.from('savings').upsert({
        'id': savings['id'],
        'amount': savings['amount'] + double.parse(_amountController.text),
      });

      setState(() {
        _isLoading = false;
      });

      ref.read(appApiProvider).addActivity(
          title: "Topped up savings with ${_amountController.text}");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Savings topped up successfully"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffD8EBE9),
        title: const Text(
          "Top Up Savings",
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
              InputField(
                controller: _amountController,
                hint: "Enter Amount to top up",
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "Amount is required";
                  }
                  return null;
                },
                label: "Amount",
              ),
              SizedBox(height: 20.0.h),
              PrimaryButton(
                onPressed: _topUpSavings,
                isLoading: _isLoading,
                buttonText: "Save",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
