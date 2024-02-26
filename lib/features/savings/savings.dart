import 'package:final_year_project_kiki/widgets/drop_down_field.dart';
import 'package:final_year_project_kiki/widgets/input_field.dart';
import 'package:final_year_project_kiki/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SavingBudgetScreen extends StatefulWidget {
  const SavingBudgetScreen({super.key});

  @override
  State<SavingBudgetScreen> createState() => _SavingBudgetScreenState();
}

class _SavingBudgetScreenState extends State<SavingBudgetScreen> {
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
        child: ListView(
          children: [
            InputField(
              controller: TextEditingController(),
              hint: "Enter Total Amount",
              validator: (String? name) => null,
              label: "Total Amount",
            ),
            SizedBox(height: 20.0.h),
            const DropDownField(
              data: ["USD", "NGN", "GBP"],
              hint: "Select Currency",
              selected: "USD",
              label: "Currency",
            ),
            SizedBox(height: 20.0.h),
            const DropDownField(
              data: ["USD", "NGN", "GBP"],
              selected: "USD",
              hint: "Select Local Currency",
              label: "Local Currency",
            ),
            SizedBox(height: 20.0.h),
            PrimaryButton(
              onPressed: () {},
              buttonText: "Save",
            ),
          ],
        ),
      ),
    );
  }
}
