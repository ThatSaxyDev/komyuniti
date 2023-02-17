import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:komyuniti/features/auth/controller/auth_controller.dart';
import 'package:komyuniti/responsive/responsive.dart';
import 'package:komyuniti/shared/app_constants.dart';
import 'package:komyuniti/shared/app_icons.dart';
import 'package:komyuniti/shared/app_images.dart';
import 'package:komyuniti/shared/app_texts.dart';
import 'package:komyuniti/shared/widgets/button.dart';
import 'package:komyuniti/shared/widgets/loader.dart';
import 'package:komyuniti/shared/widgets/spacer.dart';
import 'package:komyuniti/theme/palette.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signInAsGuest(
    WidgetRef ref,
    BuildContext context,
  ) {
    ref.read(authControllerProvider.notifier).signInAsGuest(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: isLoading
            ? const Loader()
            : Column(
                children: [
                  Spc(h: 100.h),
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: GestureDetector(
                  //     onTap: () => signInAsGuest(ref, context),
                  //     child: Text(
                  //       AppTexts.skip,
                  //       style: TextStyle(
                  //         // color: Pallete.whiteColor,
                  //         fontSize: 18.sp,
                  //         fontWeight: FontWeight.w600,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Spc(h: 15.h),
                  SizedBox(
                    height: 300.h,
                    width: 250.w,
                    child: Image.asset(AppImages.appLogo),
                  ),
                  Spc(h: 60.h),
                  GButton(
                    padding: 10.h,
                    color: Pallete.greyColor,
                    item: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 30.w,
                          child: Image.asset(AppIcons.googleIcon),
                        ),
                        Text(
                          AppTexts.continuWithG,
                          style: TextStyle(fontSize: 14.sp),
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
