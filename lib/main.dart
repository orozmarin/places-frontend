import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrorate/store/app_state.dart';

import 'app.dart';

late final Store<AppState> store;

void main() async {
  AppState? initialState = AppState.init();
  store = Store<AppState>(initialState: initialState);
  await dotenv.load();
  runApp(const App());
}