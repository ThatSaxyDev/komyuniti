import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:komyuniti/shared/widgets/spacer.dart';
import 'package:komyuniti/theme/palette.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:routemaster/routemaster.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  void navigateToType(BuildContext context, String type) {
    Routemaster.of(context).push('/add-post/$type');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardDimension = 150.w;
    final iconSize = 50.w;
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Choose post type',
          style: TextStyle(
            color: currentTheme.textTheme.bodyText2!.color!,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spc(h: 20.h),
            GestureDetector(
              onTap: () => navigateToType(context, 'image'),
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: cardDimension,
                  width: cardDimension,
                  child: Card(
                    color: currentTheme.backgroundColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r)),
                    elevation: 16,
                    child: Center(
                      child: Icon(
                        PhosphorIcons.image,
                        size: iconSize,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Spc(h: 40.h),
            GestureDetector(
              onTap: () => navigateToType(context, 'text'),
              child: SizedBox(
                height: cardDimension,
                width: cardDimension,
                child: Card(
                  color: currentTheme.backgroundColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r)),
                  elevation: 16,
                  child: Center(
                    child: Icon(
                      PhosphorIcons.textAa,
                      size: iconSize,
                    ),
                  ),
                ),
              ),
            ),
            Spc(h: 40.h),
            GestureDetector(
              onTap: () => navigateToType(context, 'link'),
              child: SizedBox(
                height: cardDimension,
                width: cardDimension,
                child: Card(
                  color: currentTheme.backgroundColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r)),
                  elevation: 16,
                  child: Center(
                    child: Icon(
                      PhosphorIcons.linkSimpleHorizontal,
                      size: iconSize,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
