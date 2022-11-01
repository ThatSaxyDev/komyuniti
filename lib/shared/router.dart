import 'package:flutter/material.dart';
import 'package:komyuniti/features/auth/screens/login_screen.dart';
import 'package:komyuniti/features/community/screens/add_mods_screen.dart';
import 'package:komyuniti/features/community/screens/community_screen.dart';
import 'package:komyuniti/features/community/screens/create_communinity_screen.dart';
import 'package:komyuniti/features/community/screens/edit_community_screen.dart';
import 'package:komyuniti/features/community/screens/mod_tools_screen.dart';
import 'package:komyuniti/features/home/screens/home_screen.dart';
import 'package:komyuniti/features/posts/screens/add_post_screen.dart';
import 'package:komyuniti/features/user_profile/screens/edit_profile_screem.dart';
import 'package:komyuniti/features/user_profile/screens/user_profile_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute =
    RouteMap(routes: {'/': (_) => const MaterialPage(child: LoginScreen())});

final loggedInRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(
          child: HomeScreen(),
        ),
    '/create-community': (_) => const MaterialPage(
          child: CreateCommunityScreen(),
        ),
    '/kom/:name': (route) => MaterialPage(
          child: CommnunityScreen(
            name: route.pathParameters['name']!,
          ),
        ),
    '/mod-tools/:name': (routeDate) => MaterialPage(
          child: ModToolsScreen(
            name: routeDate.pathParameters['name']!,
          ),
        ),
    '/edit-komyuniti/:name': (routeData) => MaterialPage(
          child: EditCommunityScreen(
            name: routeData.pathParameters['name']!,
          ),
        ),
    '/add-mods/:name': (routeData) => MaterialPage(
          child: AddModsScreen(
            name: routeData.pathParameters['name']!,
          ),
        ),
    '/user-profile/:uid': (routeData) => MaterialPage(
          child: UserProfileScreen(
            uid: routeData.pathParameters['uid']!,
          ),
        ),
    '/edit-profile/:uid': (routeData) => MaterialPage(
          child: EditProfileScreen(
            uid: routeData.pathParameters['uid']!,
          ),
        ),
    '/add-post': (_) => const MaterialPage(
          child: AddPostScreen(),
        ),
  },
);
