// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:komyuniti/core/constants/constants.dart';
import 'package:komyuniti/core/utils.dart';
import 'package:komyuniti/features/auth/controller/auth_controller.dart';
import 'package:komyuniti/features/community/controller/communtiy_controller.dart';
import 'package:komyuniti/features/posts/controller/post_controller.dart';

import 'package:komyuniti/models/post_model.dart';
import 'package:komyuniti/shared/widgets/error_text.dart';
import 'package:komyuniti/shared/widgets/loader.dart';
import 'package:komyuniti/shared/widgets/spacer.dart';
import 'package:komyuniti/theme/palette.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:routemaster/routemaster.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({
    super.key,
    required this.post,
  });

  void deletePost(WidgetRef ref, BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Please Confirm'),
            content: const Text('Are you sure you want to delete this post'),
            actions: [
              TextButton(
                onPressed: () {
                  Routemaster.of(context).pop();
                  ref
                      .read(postControllerProvider.notifier)
                      .deletePost(post, context);
                },
                child: Text(
                  'Yes',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ref
                        .watch(themeNotifierProvider)
                        .textTheme
                        .bodyText2!
                        .color!,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Routemaster.of(context).pop();
                },
                child: Text(
                  'No',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ref
                        .watch(themeNotifierProvider)
                        .textTheme
                        .bodyText2!
                        .color!,
                  ),
                ),
              ),
            ],
          );
        });
  }

  void upvotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).upvote(post);
  }

  void downvotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).downvote(post);
  }

  void awardPost(WidgetRef ref, String award, BuildContext context) async {
    ref.read(postControllerProvider.notifier).awardPost(
          post: post,
          award: award,
          context: context,
        );
  }

  void navigateToUser(BuildContext context) {
    Routemaster.of(context).push('/user-profile/${post.uid}');
  }

  void navigateToCommunity(BuildContext context) {
    Routemaster.of(context).push('/kom/${post.communityName}');
  }

  void navigateToComments(BuildContext context) {
    Routemaster.of(context).push('/post/${post.id}/comments');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final isTypeLink = post.type == 'link';
    final isTypeText = post.type == 'text';
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;

    final isGuest = !user.isAuthenticated;
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
                      ).copyWith(right: 15.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => navigateToCommunity(context),
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(post.communityProfilePic),
                                  radius: 16.w,
                                ),
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
                                    GestureDetector(
                                      onTap: () => navigateToUser(context),
                                      child: Text(
                                        'yu/${post.username}',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              if (post.uid == user.uid)
                                IconButton(
                                  onPressed: () => deletePost(ref, context),
                                  icon: Icon(
                                    PhosphorIcons.trash,
                                    color: Pallete.redColor,
                                  ),
                                ),
                            ],
                          ),
                          if (post.awards.isNotEmpty) ...[
                            Spc(h: 5.h),
                            SizedBox(
                              height: 25.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: post.awards.length,
                                itemBuilder: (context, index) {
                                  final award = post.awards[index];
                                  return Image.asset(
                                    Constants.awards[award]!,
                                    height: 23.h,
                                  );
                                },
                              ),
                            ),
                          ],
                          Padding(
                            padding: EdgeInsets.only(top: 10.h, bottom: 15.h),
                            child: Text(
                              post.title,
                              style: TextStyle(
                                fontSize: 19.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (isTypeImage)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    post.link!,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              height: MediaQuery.of(context).size.height * 0.35,
                              width: double.infinity,
                            ),
                          if (isTypeLink)
                            Container(
                              height: 150.h,
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
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
                          Spc(h: 5.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: isGuest
                                        ? () {
                                            showSnackBar(context,
                                                'Sign in with google to upvote');
                                          }
                                        : () => upvotePost(ref),
                                    icon: Icon(
                                      PhosphorIcons.arrowFatUpBold,
                                      color: post.upvotes.contains(user.uid)
                                          ? Pallete.blueColor
                                          : null,
                                    ),
                                  ),
                                  Text(
                                    '${post.upvotes.length - post.downvotes.length == 0 ? 'Vote' : post.upvotes.length - post.downvotes.length}',
                                    style: TextStyle(
                                      fontSize: 17.sp,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: isGuest
                                        ? () {
                                            showSnackBar(context,
                                                'Sign in with google to downvote');
                                          }
                                        : () => downvotePost(ref),
                                    icon: Icon(
                                      PhosphorIcons.arrowFatDownBold,
                                      color: post.downvotes.contains(user.uid)
                                          ? Pallete.redColor
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () =>
                                        navigateToComments(context),
                                    icon: const Icon(
                                      PhosphorIcons.chatCircleDotsBold,
                                    ),
                                  ),
                                  Text(
                                    '${post.commentCount == 0 ? 'Comment' : post.commentCount}',
                                    style: TextStyle(
                                      fontSize: 17.sp,
                                    ),
                                  ),
                                ],
                              ),
                              ref
                                  .watch(getCommunityByNameProvider(
                                      post.communityName))
                                  .when(
                                    data: (data) {
                                      if (data.mods.contains(user.uid)) {
                                        return IconButton(
                                          onPressed: () =>
                                              deletePost(ref, context),
                                          icon: const Icon(
                                            PhosphorIcons.gearSix,
                                          ),
                                        );
                                      } else {
                                        return const Spc();
                                      }
                                    },
                                    error: (error, stackTrace) =>
                                        ErrorText(error: error.toString()),
                                    loading: () => const Loader(),
                                  ),
                              IconButton(
                                onPressed: isGuest
                                    ? () {
                                        showSnackBar(context,
                                            'Sign in with google to award posts');
                                      }
                                    : () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                            child: Padding(
                                              padding: EdgeInsets.all(20.w),
                                              child: GridView.builder(
                                                shrinkWrap: true,
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 4,
                                                ),
                                                itemCount: user.awards.length,
                                                itemBuilder: (context, index) {
                                                  final award =
                                                      user.awards[index];
                                                  return GestureDetector(
                                                    onTap: () => awardPost(
                                                        ref, award, context),
                                                    child: Padding(
                                                        padding: EdgeInsets.all(
                                                            10.w),
                                                        child: Image.asset(
                                                            Constants.awards[
                                                                award]!)),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                icon: const Icon(PhosphorIcons.gift),
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
        Spc(h: 10.h),
      ],
    );
  }
}
