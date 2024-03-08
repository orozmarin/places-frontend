import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceInputForm extends StatefulWidget {
  const PlaceInputForm({super.key});

  @override
  State<StatefulWidget> createState() => _PlaceInputFormState();
}

class _PlaceInputFormState extends State<PlaceInputForm> {
  @override
  Widget build(BuildContext context) {
    Completer<GoogleMapController> _controller = Completer();

    return const Scaffold(
      //appBar: AppBar(title: const Text("Add new Place"),),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
              target: LatLng(10, 10),
              zoom: 12,
            ),
          ),
          Positioned(top: 40, left: 20, right: 20,child: LocationSearchBox(),)
        ],
      ),
    );
  }
}

class LocationSearchBox extends StatelessWidget {
  const LocationSearchBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Search your Place',
            suffixIcon: const Icon(Icons.search),
            contentPadding: const EdgeInsets.only(left: 20, bottom: 5, right: 5),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.white),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.white),
            )),
      ),
    );
  }
}
