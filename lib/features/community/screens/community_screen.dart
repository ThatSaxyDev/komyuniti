// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:komyuniti/features/auth/controller/auth_controller.dart';
import 'package:komyuniti/features/community/controller/communtiy_controller.dart';
import 'package:komyuniti/shared/app_texts.dart';
import 'package:komyuniti/shared/widgets/error_text.dart';
import 'package:komyuniti/shared/widgets/loader.dart';
import 'package:komyuniti/shared/widgets/spacer.dart';
import 'package:routemaster/routemaster.dart';

class CommnunityScreen extends ConsumerWidget {
  final String name;
  const CommnunityScreen({
    super.key,
    required this.name,
  });

  void navigateToModTools(BuildContext context) {
    Routemaster.of(context).push('/mod-tools');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    String member;
    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(name)).when(
            data: (community) {
              if (community.members.length == 1) {
                member = 'member';
              } else {
                member = 'members';
              }
              return NestedScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      floating: true,
                      snap: true,
                      expandedHeight: 150.h,
                      flexibleSpace: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              community.banner,
                              fit: BoxFit.cover,
                            ),
                          )
                        ],
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.all(16.h),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(community.avatar),
                                radius: 33.w,
                              ),
                            ),
                            Spc(h: 15.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'kom/${community.name}',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                community.mods.contains(user.uid)
                                    ? OutlinedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.r),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 25.w)),
                                        onPressed: () => navigateToModTools(context),
                                        child: const Text(AppTexts.modTools),
                                      )
                                    : OutlinedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.r),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 25.w)),
                                        onPressed: () {},
                                        child: Text(
                                            community.members.contains(user.uid)
                                                ? AppTexts.joined
                                                : AppTexts.join),
                                      ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.h),
                              child:
                                  Text('${community.members.length} $member'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                body: const Center(
                  child: Text('Displaying community posts'),
                ),
              );
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
