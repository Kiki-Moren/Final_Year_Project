import 'package:final_year_project_kiki/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/input_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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
            Center(
              child: Container(
                width: 270.0.w,
                height: 240.0.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0.r),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 3.0),
                      blurRadius: 5.0,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "WELCOME\nBACK",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.0.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.0.h),
            Text(
              "SIGN IN",
              style: TextStyle(
                fontSize: 32.0.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 20.0.h),
            InputField(
              controller: TextEditingController(),
              hint: "johndoe@gmail.com",
              label: "Email",
              validator: (value) => null,
            ),
            SizedBox(height: 15.0.h),
            InputField(
              controller: TextEditingController(),
              hint: "**********",
              label: "Password",
              validator: (value) => null,
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontSize: 16.0.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0.h),
            PrimaryButton(
              onPressed: () {},
              buttonText: "SIGN IN",
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "Don't Have An Account? Sign Up",
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
