// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:komyuniti/core/constants/constants.dart';
import 'package:komyuniti/core/utils.dart';
import 'package:komyuniti/features/community/controller/communtiy_controller.dart';
import 'package:komyuniti/models/community_model.dart';
import 'package:komyuniti/shared/app_texts.dart';
import 'package:komyuniti/shared/widgets/button.dart';
import 'package:komyuniti/shared/widgets/error_text.dart';
import 'package:komyuniti/shared/widgets/loader.dart';
import 'package:komyuniti/shared/widgets/spacer.dart';
import 'package:komyuniti/theme/palette.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;
  const EditCommunityScreen({
    super.key,
    required this.name,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerFile;
  File? profileFile;

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

  void save(Community community) {
    ref.read(communityControllerProvider.notifier).editCommunity(
          context: context,
          profileFile: profileFile,
          community: community,
          bannerFile: bannerFile,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    final currenTheme = ref.watch(themeNotifierProvider);
    return ref.watch(getCommunityByNameProvider(widget.name)).when(
          data: (community) => Scaffold(
            backgroundColor: currenTheme.backgroundColor,
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: Text(
                AppTexts.editCommunity,
                style: TextStyle(
                  color: currenTheme.textTheme.bodyText2!.color!,
                ),
              ),
            ),
            body: Padding(
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
                            color: currenTheme.textTheme.bodyText2!.color!,
                            child: Container(
                              width: double.infinity,
                              height: 150.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: bannerFile != null
                                  ? Image.file(bannerFile!)
                                  : community.banner.isEmpty ||
                                          community.banner ==
                                              Constants.bannerDefault
                                      ? Center(
                                          child: Icon(
                                            PhosphorIcons.image,
                                            size: 40.h,
                                          ),
                                        )
                                      : Image.network(community.banner),
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
                                    backgroundImage: FileImage(profileFile!),
                                    radius: 32.r,
                                  )
                                : CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(community.avatar),
                                    radius: 32.r,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  isLoading
                      ? const Loader()
                      : BButton(
                          height: 60.h,
                          width: double.infinity,
                          radius: 10.r,
                          onTap: () => save(community),
                          color: Pallete.greyColor,
                          item: const Text('Save'),
                        ),
                  Spc(h: 60.h),
                ],
              ),
            ),
          ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
