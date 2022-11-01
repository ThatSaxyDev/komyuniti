import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:komyuniti/features/auth/controller/auth_controller.dart';
import 'package:komyuniti/features/home/delegates/search_community_delegate.dart';
import 'package:komyuniti/features/home/drawers/community_list_drawer.dart';
import 'package:komyuniti/shared/app_texts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text(AppTexts.appName),
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(PhosphorIcons.list),
                onPressed: () => displayDrawer(context),
              );
            }
          ),
          actions: [
            IconButton(
              icon: const Icon(PhosphorIcons.magnifyingGlass),
              onPressed: () {
                showSearch(context: context, delegate: SearchCommunityDelegate(ref));
              },
            ),
            IconButton(
              icon: CircleAvatar(
                backgroundImage: NetworkImage(user.profilePic),
              ),
              onPressed: () {},
            )
          ],
        ),
        drawer: const CommunityListDrawer(),
        body: const SizedBox());
  }
}
