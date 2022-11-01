// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:routemaster/routemaster.dart';

import 'package:komyuniti/shared/app_texts.dart';

class ModToolsScreen extends StatelessWidget {
  final String name;
  const ModToolsScreen({
    Key? key,
    required this.name,
  }) : super(key: key);

  void navigateToEditCommunity(BuildContext context) {
    Routemaster.of(context).push('/edit-komyuniti/$name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppTexts.modTools),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(PhosphorIcons.userPlus),
              title: const Text(AppTexts.addModerators),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(PhosphorIcons.pen),
              title: const Text(AppTexts.editCommunity),
              onTap: () => navigateToEditCommunity(context),
            ),
          ],
        ),
      ),
    );
  }
}
