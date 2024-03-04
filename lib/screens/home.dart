import 'package:flutter/material.dart';
import 'package:gastrorate/models/restaurant.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.restaurants, required this.onFindAllRestaurants});

  final Function() onFindAllRestaurants;
  final List<Restaurant>? restaurants;

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
          child: widget.restaurants != null && widget.restaurants!.isNotEmpty
              ? Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          Restaurant restaurant = widget.restaurants![index];
                          return Card(
                            elevation: 3,
                            child: ListTile(
                              title: Text(
                                restaurant.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Text(
                                "${restaurant.address}, ${restaurant.city}, ${restaurant.country}",
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              onTap: () {
                                // Add any onTap functionality here
                              },
                            ),
                          );
                        },
                        itemCount: widget.restaurants!.length,
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      'assets/logo.png',
                      height: 500,
                      width: 500,
                    ),
                    SizedBox(
                      height: 50,
                      width: 200,
                      child: ElevatedButton(
                        onPressed: widget.onFindAllRestaurants,
                        child: const Text("Proceed", style: TextStyle(fontSize: 18),),
                      ),
                    )
                  ],
                )),
    );
  }
}
