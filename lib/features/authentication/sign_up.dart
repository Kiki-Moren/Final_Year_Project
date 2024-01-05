import 'package:final_year_project_kiki/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/input_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  Widget _buildBody() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            SizedBox(height: 10.0.h),
            Image.asset(
              "assets/images/app_icon1.png",
              width: 180.0.w,
              height: 180.0.w,
            ),
            SizedBox(height: 30.0.h),
            Text(
              "SIGN UP",
              style: TextStyle(
                fontSize: 32.0.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "Please sign up to enjoy all trakit features",
              style: TextStyle(
                fontSize: 16.0.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 20.0.h),
            InputField(
              controller: TextEditingController(),
              hint: "john",
              label: "Username",
              validator: (value) => null,
            ),
            SizedBox(height: 15.0.h),
            InputField(
              controller: TextEditingController(),
              hint: "johndoe@gmail.com",
              label: "Email Address",
              validator: (value) => null,
            ),
            SizedBox(height: 15.0.h),
            InputField(
              controller: TextEditingController(),
              hint: "**********",
              label: "Password",
              validator: (value) => null,
            ),
            SizedBox(height: 15.0.h),
            InputField(
              controller: TextEditingController(),
              hint: "**********",
              label: "Confirm Password",
              validator: (value) => null,
            ),
            SizedBox(height: 15.0.h),
            PrimaryButton(
              onPressed: () {},
              buttonText: "SIGN UP",
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "Have An Account? Sign In",
                style: TextStyle(
                  fontSize: 16.0.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
