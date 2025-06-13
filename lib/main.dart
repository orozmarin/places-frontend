import 'dart:io';

import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:permission_handler/permission_handler.dart';

import 'app.dart';

late final Store<AppState> store;

void main() async {
  AppState? initialState = await AppState.init();
  store = Store<AppState>(initialState: initialState);
  await dotenv.load();
  requestLocationPermission();
  runApp(const App());
}

Future<void> requestLocationPermission() async {
  var status = await Permission.location.request();
  if (status.isGranted) {
    print("Location permission granted");
  } else if (status.isDenied) {
    print("Location permission denied");
  } else if (status.isPermanentlyDenied) {
    openAppSettings();
  }
}