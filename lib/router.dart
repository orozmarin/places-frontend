// private navigators
import 'package:flutter/material.dart';
import 'package:gastrorate/screens/home_page.dart';
import 'package:gastrorate/screens/new_place_page.dart';
import 'package:gastrorate/screens/places_page.dart';
import 'package:gastrorate/screens/settings_page.dart';
import 'package:gastrorate/screens/wishlist_page.dart';
import 'package:gastrorate/widgets/scaffold_nested_navigation.dart';
import 'package:go_router/go_router.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'homeShellKey');
final shellNavigatorPlacesKey = GlobalKey<NavigatorState>(debugLabel: 'placesShellKey');
final shellNavigatorWishlistKey = GlobalKey<NavigatorState>(debugLabel: 'wishlistShellKey');
final shellNavigatorSettingsKey = GlobalKey<NavigatorState>(debugLabel: 'settingsShellKey');

// the one and only GoRouter instance
final goRouter = GoRouter(
  initialLocation: '/home',
  navigatorKey: rootNavigatorKey,
  routes: [
    // Stateful nested navigation based on:
    // https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // the UI shell
        return ScaffoldWithNestedNavigation(
            navigationShell: navigationShell);
      },
      branches: [
        // first branch (A)
        StatefulShellBranch(
          navigatorKey: shellNavigatorHomeKey,
          routes: [
            // top route inside branch
            GoRoute(
              path: '/home',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: HomePage(),
              ),
              routes: [
                // child route
                GoRoute(
                  path: 'details',
                  builder: (context, state) =>
                  const NewPlacePage(),
                ),
              ],
            ),
          ],
        ),
        // second branch (B)
        StatefulShellBranch(
          navigatorKey: shellNavigatorPlacesKey,
          routes: [
            // top route inside branch
            GoRoute(
              path: '/places',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: PlacesPage(),
              ),
              routes: [
                // child route
                GoRoute(
                  path: 'details',
                  builder: (context, state) =>
                  const NewPlacePage(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: shellNavigatorWishlistKey,
          routes: [
            // top route inside branch
            GoRoute(
              path: '/wishlist',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: WishlistPage(),
              ),
              routes: [
                // child route
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: shellNavigatorSettingsKey,
          routes: [
            // top route inside branch
            GoRoute(
              path: '/settings',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: SettingsPage(),
              ),
              routes: [
                // child route
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

// use like this:
// MaterialApp.router(routerConfig: goRouter, ...)