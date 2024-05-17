import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:gastrorate/screens/home_page.dart';
import 'package:gastrorate/store/app_state.dart';
import 'main.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(store: store, child: MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        sliderTheme: const SliderThemeData(
          showValueIndicator: ShowValueIndicator.always,
        ),
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Open Sans',
      ),
      home: const HomePage(),
    ));

  }
}