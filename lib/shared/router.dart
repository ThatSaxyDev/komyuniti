import 'package:flutter/material.dart';
import 'package:komyuniti/features/auth/screens/login_screen.dart';
import 'package:komyuniti/features/community/screens/community_screen.dart';
import 'package:komyuniti/features/community/screens/create_communinity_screen.dart';
import 'package:komyuniti/features/community/screens/mod_tools_screen.dart';
import 'package:komyuniti/features/home/screens/home_screen.dart';
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
    '/mod-tools': (_) => const MaterialPage(
          child: ModToolsScreen(),
        ),
  },
);
