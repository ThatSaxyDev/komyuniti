import 'package:flutter/material.dart';
import 'package:komyuniti/features/auth/screens/login_screen.dart';
import 'package:komyuniti/features/community/screens/create_communinity_screen.dart';
import 'package:komyuniti/features/home/screens/home_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen())
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  '/create-community': (_) => const MaterialPage(child: CreateCommunityScreen())
});