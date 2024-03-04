import 'package:flutter/material.dart';
import 'package:gastrorate/models/restaurant.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.restaurants});

  final List<Restaurant>? restaurants;

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String message = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Example"),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

              ],
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [Flexible(child: Text(widget.restaurants!.isNotEmpty ? widget.restaurants![0].name : "empty", maxLines: 20, style: const TextStyle(fontSize: 18.0)))])
          ],
        )));
  }

}
