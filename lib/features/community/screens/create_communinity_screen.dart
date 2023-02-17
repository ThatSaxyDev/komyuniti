import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:komyuniti/core/providers/firebase_provider.dart';
import 'package:komyuniti/core/providers/storage_repository_provider.dart';
import 'package:komyuniti/features/community/controller/communtiy_controller.dart';
import 'package:komyuniti/features/community/repository/community_repository.dart';
import 'package:komyuniti/shared/app_texts.dart';
import 'package:komyuniti/shared/widgets/button.dart';
import 'package:komyuniti/shared/widgets/loader.dart';
import 'package:komyuniti/shared/widgets/spacer.dart';
import 'package:komyuniti/theme/palette.dart';

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  final communityRepository = ref.watch(communityRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return CommunityController(
    communityRepository: communityRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final communityNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    communityNameController.dispose();
  }

  void createCommunity() {
    ref.read(communityControllerProvider.notifier).createCommunity(
          communityNameController.text.trim(),
          context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '${AppTexts.createACommunity} 👨🏾‍💻',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: isLoading
            ? const Loader()
            : Column(
                children: [
                  Spc(h: 20.h),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      AppTexts.communityName,
                      style: TextStyle(fontSize: 15.sp),
                    ),
                  ),
                  Spc(h: 15.h),
                  TextField(
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(' '))
                    ],
                    controller: communityNameController,
                    onChanged: (value) {
                      communityNameController.value = TextEditingValue(
                          text: value.toLowerCase(),
                          selection: communityNameController.selection);
                    },
                    decoration: InputDecoration(
                        prefixText: 'kom/',
                        hintText: AppTexts.communityHintText,
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
                    maxLength: 21,
                  ),
                  const Spacer(),
                  BButton(
                    height: 50.h,
                    width: double.infinity,
                    radius: 10.r,
                    onTap: createCommunity,
                    color: Pallete.greyColor,
                    item: Text(
                      AppTexts.createCommunity,
                      style: TextStyle(fontSize: 15.sp),
                    ),
                  ),
                  Spc(h: 50.h),
                ],
              ),
      ),
    );
  }
}
