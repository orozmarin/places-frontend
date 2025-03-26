import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:gastrorate/router.dart';
import 'package:gastrorate/store/app_state.dart';

import 'main.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(store: store, child: MaterialApp.router(
      title: 'Places App',
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
              brightness: Brightness.light,
              // Ensures a light theme base
              primaryColor: Colors.black,
              scaffoldBackgroundColor: Colors.white,

              // AppBar styling
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.white), // Ensures icons are visible
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Text styling
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Colors.black),
                bodyMedium: TextStyle(color: Colors.black),
                titleLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),

              cardTheme: const CardTheme(
                surfaceTintColor: Colors.transparent,
                color: Colors.white,
                shadowColor: Colors.black12,
                elevation: 1,
                margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  side: BorderSide(color: Colors.black12, width: 1),
                ),
              ),

              // Button styling
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),

              // Input field styling
              inputDecorationTheme: const InputDecorationTheme(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
              ),

              // Slider styling
              sliderTheme: const SliderThemeData(
                showValueIndicator: ShowValueIndicator.always,
                activeTrackColor: Colors.black,
                inactiveTrackColor: Colors.black26,
                thumbColor: Colors.black,
                overlayColor: Colors.black12,
              ),

              // Icon styling
              iconTheme: const IconThemeData(color: Colors.black),

              // Divider styling
              dividerColor: Colors.black54,

              // Other settings
              visualDensity: VisualDensity.adaptivePlatformDensity,
              fontFamily: 'Open Sans',
            )));
  }

}