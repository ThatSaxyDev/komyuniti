import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:komyuniti/features/auth/controller/auth_controller.dart';
import 'package:komyuniti/shared/widgets/spacer.dart';
import 'package:komyuniti/theme/palette.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logOut();
  }

  void navigateToUserProfile(BuildContext context, String uid) {
    Routemaster.of(context).push('/user-profile/$uid');
  }

  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              Spc(h: 20.h),
              CircleAvatar(
                backgroundImage: NetworkImage(user.profilePic),
                radius: 60.r,
              ),
              Spc(h: 20.h),
              Text(
                'yu/${user.name}',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
              ),
              Spc(h: 10.h),
              Divider(
                thickness: 2.h,
              ),
              Spc(h: 10.h),
              ListTile(
                leading: const Icon(PhosphorIcons.person),
                title: const Text('My Profile 👨🏾‍💻'),
                onTap: () {
                  Navigator.of(context).pop();
                  navigateToUserProfile(context, user.uid);
                },
              ),
              Spc(h: 20.h),
              Row(
                children: [
                  Spc(w: 17.w),
                  const Icon(PhosphorIcons.moonStars),
                  Spc(w: 17.w),
                  Switch.adaptive(
                    value: ref.watch(themeNotifierProvider.notifier).mode == ThemeMode.dark,
                    onChanged: (val) => toggleTheme(ref),
                  ),
                ],
              ),
              const Spacer(),
              ListTile(
                leading: Icon(
                  PhosphorIcons.signOut,
                  color: Pallete.redColor,
                ),
                title: const Text('Log out 😥'),
                onTap: () => logOut(ref),
              ),
              Spc(h: 60.h),
            ],
          ),
        ),
      ),
    );
  }
}
