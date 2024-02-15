import 'package:final_year_project_kiki/widgets/drop_down_field.dart';
import 'package:final_year_project_kiki/widgets/input_field.dart';
import 'package:final_year_project_kiki/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditBudgetScreen extends StatefulWidget {
  const EditBudgetScreen({super.key});

  @override
  State<EditBudgetScreen> createState() => _EditBudgetScreenState();
}

class _EditBudgetScreenState extends State<EditBudgetScreen> {
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
        child: ListView(
          children: [
            InputField(
              controller: TextEditingController(),
              hint: "Enter Budget Name",
              validator: (String? name) => null,
              label: "Budget Name",
            ),
            SizedBox(height: 20.0.h),
            const DropDownField(
              data: ["USD", "NGN", "GBP"],
              hint: "Select Currency",
              label: "Currency",
            ),
            SizedBox(height: 20.0.h),
            InputField(
              controller: TextEditingController(),
              hint: "Enter Amount",
              validator: (String? name) => null,
              label: "Amount",
            ),
            SizedBox(height: 20.0.h),
            PrimaryButton(
              onPressed: () {},
              buttonText: "Save",
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
    );
  }
}
