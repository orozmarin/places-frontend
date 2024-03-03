import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

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
                ElevatedButton(onPressed: handleFetchTap, child: const Text("Fetch Data")),
                ElevatedButton(onPressed: handleResetTap, child: const Text("Reset")),
              ],
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [Flexible(child: Text(message, maxLines: 20, style: const TextStyle(fontSize: 18.0)))])
          ],
        )));
  }

  handleFetchTap() async {
    var someData = await fetch();

    setState(() {
      message = someData;
    });
  }

  handleResetTap() {
    setState(() {
      message = "";
    });
  }

  Future<String> fetch() async {
    try {
      var client = http.Client();
      Uri apiUrl = Uri.parse("${dotenv.env['API_BASE_URI']}/restaurants/find");
      var response = await client.get(apiUrl);
      return response.body;
    } catch (error) {
      print("Error during API request: $error");
      return "Error during API request: $error";
    }
  }
}
