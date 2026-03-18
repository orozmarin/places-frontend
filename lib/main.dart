import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:permission_handler/permission_handler.dart';

import 'app.dart';

late final Store<AppState> store;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Must be called before runApp — renderer must be initialized
  // before any map widget is created
  final mapsImpl = GoogleMapsFlutterPlatform.instance;
  if (mapsImpl is GoogleMapsFlutterAndroid) {
    await mapsImpl.initializeWithRenderer(AndroidMapRenderer.latest);
    mapsImpl.useAndroidViewSurface = true; // SurfaceView = full resolution
  }

  await dotenv.load();
  AppState? initialState = await AppState.init();
  store = Store<AppState>(initialState: initialState);

  requestLocationPermission();
  runApp(
    const App(),
  );
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