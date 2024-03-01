// ignore_for_file: use_build_context_synchronously

import 'package:final_year_project_kiki/services/app.dart';
import 'package:final_year_project_kiki/widgets/drop_down_field.dart';
import 'package:final_year_project_kiki/widgets/input_field.dart';
import 'package:final_year_project_kiki/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddBudgetScreen extends ConsumerStatefulWidget {
  const AddBudgetScreen({super.key});

  @override
  ConsumerState<AddBudgetScreen> createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends ConsumerState<AddBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  String? _currency;
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _saveBudget() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });
      // Save budget to database

      final user = Supabase.instance.client.auth.currentUser;

      await Supabase.instance.client.from('budgets').insert({
        'user_id': user!.id,
        'name': _nameController.text,
        'currency': _currency,
        'amount': _amountController.text,
      });

      setState(() {
        _loading = false;
      });

      ref
          .read(appApiProvider)
          .addActivity(title: "Added budget ${_nameController.text}");

      // show success message and clear form
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Budget saved successfully"),
          backgroundColor: Colors.green,
        ),
      );
      _amountController.clear();
      _nameController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffD8EBE9),
        title: const Text(
          "Add Budget",
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
                controller: _nameController,
                hint: "Enter Budget Name",
                validator: (String? name) {
                  if (name!.isEmpty) {
                    return "Budget name is required";
                  }
                  return null;
                },
                label: "Budget Name",
              ),
              SizedBox(height: 20.0.h),
              DropDownField(
                data: const ["USD", "NGN", "GBP"],
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
              InputField(
                controller: _amountController,
                hint: "Enter Amount",
                textInputType: TextInputType.number,
                validator: (String? name) {
                  if (name!.isEmpty) {
                    return "Amount is required";
                  }
                  return null;
                },
                label: "Amount",
              ),
              SizedBox(height: 20.0.h),
              PrimaryButton(
                onPressed: _saveBudget,
                isLoading: _loading,
                buttonText: "Save",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
