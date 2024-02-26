// ignore_for_file: use_build_context_synchronously

import 'package:final_year_project_kiki/widgets/drop_down_field.dart';
import 'package:final_year_project_kiki/widgets/input_field.dart';
import 'package:final_year_project_kiki/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditBudgetScreen extends StatefulWidget {
  const EditBudgetScreen({super.key});

  @override
  State<EditBudgetScreen> createState() => _EditBudgetScreenState();
}

class _EditBudgetScreenState extends State<EditBudgetScreen> {
  Map<String, dynamic>? budget;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  String? _currency;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialValues());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _loadInitialValues() async {
    budget = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _nameController.text = budget!['name'].toString();
    _amountController.text = budget!['amount'].toString();
    _currency = budget!['currency'].toString();
    setState(() {});
  }

  void _update() async {
    print('here');
    if (_formKey.currentState!.validate()) {
      print('here2');
      setState(() {
        _loading = true;
      });
      // update budget to database

      await Supabase.instance.client.from('budgets').update({
        'name': _nameController.text,
        'currency': _currency,
        'amount': _amountController.text,
      }).match({'id': budget!['id']});

      setState(() {
        _loading = false;
      });

      // show success message and clear form
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Budget updated successfully"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffD8EBE9),
        title: const Text(
          "Edit Budget",
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
                    return "Budget name cannot be empty";
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
                onPressed: _update,
                isLoading: _loading,
                buttonText: "Update Budget",
              ),
              SizedBox(height: 20.0.h),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Delete Budget",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
