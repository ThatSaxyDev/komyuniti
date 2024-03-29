import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:komyuniti/features/auth/controller/auth_controller.dart';
import 'package:komyuniti/features/community/controller/communtiy_controller.dart';
import 'package:komyuniti/models/community_model.dart';
import 'package:komyuniti/shared/app_icons.dart';
import 'package:komyuniti/shared/app_images.dart';
import 'package:komyuniti/shared/app_texts.dart';
import 'package:komyuniti/shared/widgets/button.dart';
import 'package:komyuniti/shared/widgets/error_text.dart';
import 'package:komyuniti/shared/widgets/loader.dart';
import 'package:komyuniti/shared/widgets/spacer.dart';
import 'package:komyuniti/theme/palette.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  void navigateToCommunity(BuildContext context, Community community) {
    Routemaster.of(context).push('/kom/${community.name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.width / 2.5,
                width: MediaQuery.of(context).size.width / 2.5,
                child: Image.asset(AppImages.appLogo),
              ),
              Spc(h: 10.h),
              isGuest
                  ? GButton(
                      padding: 17.h,
                      color: Pallete.greyColor,
                      item: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 30.w,
                            child: Image.asset(AppIcons.googleIcon),
                          ),
                          Text(
                            AppTexts.continuWithG,
                            style: TextStyle(fontSize: 17.sp),
                          ),
                        ],
                      ),
                    )
                  : ListTile(
                      leading: const Icon(PhosphorIcons.plus),
                      title: const Text(AppTexts.createACommunity),
                      onTap: () {
                        Navigator.of(context).pop();
                        navigateToCreateCommunity(context);
                      },
                    ),
              if (!isGuest)
                ref.watch(userCommunitiesProvider).when(
                      data: (communities) => Expanded(
                        child: ListView.builder(
                          itemCount: communities.length,
                          itemBuilder: (context, index) {
                            final community = communities[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(community.avatar),
                              ),
                              title: Text('kom/${community.name}'),
                              onTap: () {
                                Navigator.of(context).pop();
                                navigateToCommunity(context, community);
                              },
                            );
                          },
                        ),
                      ),
                      error: (error, stackTrace) =>
                          ErrorText(error: error.toString()),
                      loading: () => const Loader(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
