import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_year_project_kiki/widgets/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../../../widgets/more_items_widgets.dart';

class AccountTab extends StatefulWidget {
  const AccountTab({super.key});

  @override
  State<AccountTab> createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  bool _notificationEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  Widget _buildBody() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Center(
              child: Text(
                "Account",
                style: TextStyle(
                  fontSize: 24.0.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 10.0.h),
            CachedNetworkImage(
              imageUrl: 'https://picsum.photos/200',
              imageBuilder: (context, imageProvider) => CircleAvatar(
                radius: 60.r,
                backgroundImage: imageProvider,
                backgroundColor: Colors.transparent,
              ),
              placeholder: (context, url) => CircleAvatar(
                radius: 60.r,
                child: const Icon(
                  CupertinoIcons.profile_circled,
                  size: 130,
                ),
              ),
              errorWidget: (context, url, error) => CircleAvatar(
                radius: 60.r,
                child: const Icon(
                  CupertinoIcons.profile_circled,
                  size: 130,
                ),
              ),
            ),
            Center(
              child: Text(
                "Kiki_2024",
                style: TextStyle(
                  fontSize: 24.0.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 20.0.h),
            PrimaryButton(
              onPressed: () {},
              buttonText: "Edit Profile",
            ),
            SizedBox(height: 20.0.h),
            Text(
              "ACCOUNT SETTINGS",
              style: TextStyle(
                fontSize: 24.0.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 20.0.h),
            MoreItemsWidget(
              leadingIcon: SvgPicture.asset("assets/icons/profile.svg"),
              text: "Profile Information",
              suffix: const Icon(Icons.navigate_next, color: Colors.white),
              onPressed: () {},
            ),
            SizedBox(height: 3.0.h),
            MoreItemsWidget(
              leadingIcon: SvgPicture.asset("assets/icons/converter.svg"),
              text: "Currency",
              suffix: Row(
                children: [
                  Text(
                    "NGN #",
                    style: TextStyle(
                      fontSize: 12.0.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Icon(Icons.navigate_next, color: Colors.white)
                ],
              ),
              onPressed: () {},
            ),
            SizedBox(height: 3.0.h),
            MoreItemsWidget(
              leadingIcon: SvgPicture.asset("assets/icons/notification.svg"),
              text: "Notification",
              suffix: FlutterSwitch(
                width: 45,
                height: 25,
                toggleSize: 12,
                value: _notificationEnabled,
                onToggle: (value) {
                  setState(() {
                    _notificationEnabled = value;
                  });
                },
              ),
              onPressed: () {},
            ),
            SizedBox(height: 3.0.h),
            MoreItemsWidget(
              leadingIcon: SvgPicture.asset("assets/icons/delete.svg"),
              text: "Delete Account",
              suffix: const SizedBox(),
              onPressed: () {},
            ),
            SizedBox(height: 3.0.h),
            MoreItemsWidget(
              leadingIcon: SvgPicture.asset("assets/icons/signout.svg"),
              text: "Sign Out",
              suffix: const SizedBox(),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
