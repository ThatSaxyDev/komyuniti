import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:komyuniti/shared/app_constants.dart';
import 'package:komyuniti/shared/app_icons.dart';
import 'package:komyuniti/shared/app_images.dart';
import 'package:komyuniti/shared/app_texts.dart';
import 'package:komyuniti/shared/widgets/button.dart';
import 'package:komyuniti/shared/widgets/spacer.dart';
import 'package:komyuniti/theme/palette.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          children: [
            Spc(h: 50.h),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {},
                child: Text(
                  AppTexts.skip,
                  style: TextStyle(
                    color: Pallete.whiteColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Spc(h: 15.h),
            SizedBox(
              height: width(context),
              width: double.infinity,
              child: Image.asset(AppImages.appLogo),
            ),
            Spc(h: 60.h),
            GButton(
              padding: 60,
              onTap: () {},
              color: Pallete.greyColor,
              item: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 30,
                    child: Hero(
                      tag: 'hero',
                      child: Image.asset(AppIcons.googleIcon),
                    ),
                  ),
                  const Text(
                    'Sign up with google',
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
