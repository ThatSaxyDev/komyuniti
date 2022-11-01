import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:komyuniti/features/auth/controller/auth_controller.dart';
import 'package:komyuniti/features/feed/screens/feed_screen.dart';
import 'package:komyuniti/features/home/delegates/search_community_delegate.dart';
import 'package:komyuniti/features/home/drawers/community_list_drawer.dart';
import 'package:komyuniti/features/home/drawers/profile_drawer.dart';
import 'package:komyuniti/shared/app_texts.dart';
import 'package:komyuniti/theme/palette.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void navigateToAddPost(BuildContext context) {
    Routemaster.of(context).push('/add-post');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final currenTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: Text(
          AppTexts.appName,
          style: TextStyle(
            color: currenTheme.textTheme.bodyText2!.color!,
          ),
        ),
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(PhosphorIcons.list),
            onPressed: () => displayDrawer(context),
          );
        }),
        actions: [
          IconButton(
            icon: const Icon(PhosphorIcons.magnifyingGlass),
            onPressed: () {
              showSearch(
                  context: context, delegate: SearchCommunityDelegate(ref));
            },
          ),
          Builder(builder: (context) {
            return IconButton(
              icon: CircleAvatar(
                backgroundImage: NetworkImage(user.profilePic),
              ),
              onPressed: () => displayEndDrawer(context),
            );
          })
        ],
      ),
      drawer: const CommunityListDrawer(),
      endDrawer: const ProfileDrawer(),
      body: const FeedScreen(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: currenTheme.textTheme.bodyText2!.color!,
        onPressed: () => navigateToAddPost(context),
        child: const Icon(PhosphorIcons.pen),
      ),
    );
  }
}
