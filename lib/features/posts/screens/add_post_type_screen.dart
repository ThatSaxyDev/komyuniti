import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fpdart/fpdart.dart';
import 'package:komyuniti/core/utils.dart';
import 'package:komyuniti/features/community/controller/communtiy_controller.dart';
import 'package:komyuniti/models/community_model.dart';
import 'package:komyuniti/shared/app_constants.dart';
import 'package:komyuniti/shared/widgets/button.dart';
import 'package:komyuniti/shared/widgets/error_text.dart';
import 'package:komyuniti/shared/widgets/loader.dart';
import 'package:komyuniti/shared/widgets/spacer.dart';
import 'package:komyuniti/theme/palette.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;
  const AddPostTypeScreen({
    super.key,
    required this.type,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  final titleController = TextEditingController();
  final textPostController = TextEditingController();
  final linktController = TextEditingController();
  File? bannerFile;
  List<Community> communities = [];
  Community? selectedCommunity;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    textPostController.dispose();
    linktController.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == 'image';
    final isTypeLink = widget.type == 'link';
    final isTypeText = widget.type == 'text';
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Post ${widget.type}',
          style: TextStyle(
            color: currentTheme.textTheme.bodyText2!.color!,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: height(context),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 0),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                      hintText: 'Title',
                      hintStyle: TextStyle(fontSize: 14.sp),
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      contentPadding: EdgeInsets.all(18.w)),
                  maxLength: 30,
                ),
                Spc(h: 20.h),
                if (isTypeImage)
                  GestureDetector(
                    onTap: selectBannerImage,
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: Radius.circular(15.r),
                      dashPattern: const [10, 4],
                      strokeCap: StrokeCap.round,
                      color: currentTheme.textTheme.bodyText2!.color!,
                      child: Container(
                        width: double.infinity,
                        height: 200.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: bannerFile != null
                            ? Image.file(bannerFile!)
                            : Center(
                                child: Icon(
                                  PhosphorIcons.image,
                                  size: 40.h,
                                ),
                              ),
                      ),
                    ),
                  ),

                if (isTypeText)
                  TextField(
                    controller: textPostController,
                    decoration: InputDecoration(
                        hintText: 'Type something...',
                        hintStyle: TextStyle(fontSize: 14.sp),
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
                    // maxLength: 21,
                    maxLines: 7,
                  ),

                if (isTypeLink)
                  TextField(
                    controller: linktController,
                    decoration: InputDecoration(
                        hintText: 'Link',
                        hintStyle: TextStyle(fontSize: 14.sp),
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
                    // maxLength: 30,
                    maxLines: 3,
                  ),

                Spc(h: 30.h),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text('Selekt Komyuniti'),
                ),
                ref.watch(userCommunitiesProvider).when(
                      data: (data) {
                        communities = data;

                        if (data.isEmpty) {
                          return const SizedBox();
                        }

                        return DropdownButton(
                          value: selectedCommunity ?? data[0],
                          items: data
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.name),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              selectedCommunity = val;
                            });
                          },
                        );
                      },
                      error: (error, stackTrace) =>
                          ErrorText(error: error.toString()),
                      loading: () => const Loader(),
                    ),
                Spc(h: 100.h),
                BButton(
                  height: 60.h,
                  width: double.infinity,
                  radius: 10.r,
                  onTap: () {},
                  color: Pallete.greyColor,
                  item: const Text('Komyunikate!'),
                ),
                // Spc(h: 60.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
