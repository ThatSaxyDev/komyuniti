// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:komyuniti/core/constants/constants.dart';
import 'package:komyuniti/features/auth/controller/auth_controller.dart';

import 'package:komyuniti/models/post_model.dart';
import 'package:komyuniti/theme/palette.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final isTypeLink = post.type == 'link';
    final isTypeText = post.type == 'text';
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;
    // final isLoading = ref.watch(postControllerProvider);

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: currentTheme.drawerTheme.backgroundColor,
          ),
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 4.h,
                        horizontal: 16.w,
                      ).copyWith(right: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(post.communityProfilePic),
                                radius: 16.w,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'kom/${post.communityName}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    Text(
                                      'yu/${post.username}',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              if (post.uid == user.uid)
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    PhosphorIcons.trash,
                                    color: Pallete.redColor,
                                  ),
                                ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: Text(
                              post.title,
                              style: TextStyle(
                                fontSize: 19.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (isTypeImage)
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.35,
                              width: double.infinity,
                              child: Image.network(
                                post.link!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          if (isTypeLink)
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: double.infinity,
                              child: AnyLinkPreview(
                                displayDirection:
                                    UIDirection.uiDirectionHorizontal,
                                link: post.link!,
                              ),
                            ),
                          if (isTypeText)
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              child: Text(
                                post.description!,
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  IconButton(onPressed: () {}, icon: Icon(PhosphorIcons.arrowFatUp))
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
