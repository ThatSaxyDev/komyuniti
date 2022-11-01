// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:komyuniti/features/user_profile/controller/user_profile_controller.dart';
import 'package:komyuniti/shared/app_constants.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:komyuniti/core/constants/constants.dart';
import 'package:komyuniti/core/utils.dart';
import 'package:komyuniti/features/auth/controller/auth_controller.dart';
import 'package:komyuniti/shared/widgets/button.dart';
import 'package:komyuniti/shared/widgets/error_text.dart';
import 'package:komyuniti/shared/widgets/loader.dart';
import 'package:komyuniti/shared/widgets/spacer.dart';
import 'package:komyuniti/theme/palette.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const EditProfileScreen({
    super.key,
    required this.uid,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? bannerFile;
  File? profileFile;
  late TextEditingController usernameController;

  @override
  void initState() {
    super.initState();
    usernameController =
        TextEditingController(text: ref.read(userProvider)!.name);
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  void save() {
    ref.read(userProfileControllerProvider.notifier).editUserProfile(
          context: context,
          profileFile: profileFile,
          bannerFile: bannerFile,
          name: usernameController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    final currenTheme = ref.watch(themeNotifierProvider);
    return ref.watch(getUserProvider(widget.uid)).when(
          data: (user) => Scaffold(
            backgroundColor: currenTheme.backgroundColor,
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: const Text('Edit Profile'),
            ),
            body: SingleChildScrollView(
              child: SizedBox(
                height: height(context),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Column(
                    children: [
                      Spc(h: 20.h),
                      SizedBox(
                        height: 185.h,
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: selectBannerImage,
                              child: DottedBorder(
                                borderType: BorderType.RRect,
                                radius: Radius.circular(15.r),
                                dashPattern: const [10, 4],
                                strokeCap: StrokeCap.round,
                                color: currenTheme.textTheme
                                    .bodyText2!.color!,
                                child: Container(
                                  width: double.infinity,
                                  height: 150.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: bannerFile != null
                                      ? Image.file(bannerFile!)
                                      : user.banner.isEmpty ||
                                              user.banner ==
                                                  Constants.bannerDefault
                                          ? Center(
                                              child: Icon(
                                                PhosphorIcons.camera,
                                                size: 40.h,
                                              ),
                                            )
                                          : Image.network(user.banner),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 15.w,
                              child: GestureDetector(
                                onTap: selectProfileImage,
                                child: profileFile != null
                                    ? CircleAvatar(
                                        backgroundImage:
                                            FileImage(profileFile!),
                                        radius: 32.r,
                                      )
                                    : CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(user.profilePic),
                                        radius: 32.r,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spc(h: 20.h),
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                            hintText: 'Username',
                            hintStyle: TextStyle(fontSize: 13.sp),
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            contentPadding: EdgeInsets.all(18.w)),
                        maxLength: 16,
                      ),
                      Spc(h: 250.h),
                      isLoading
                          ? const Loader()
                          : BButton(
                              height: 60.h,
                              width: double.infinity,
                              radius: 10.r,
                              onTap: () => save(),
                              color: Pallete.greyColor,
                              item: const Text('Save'),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
