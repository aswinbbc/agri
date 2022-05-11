import 'dart:async';

import 'package:agri/thingspeak.dart';
import 'package:flutter/material.dart';

import 'network_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Timer? timer;
  String field1 = "10";
  String field2 = "10";
  String field3 = "10";
  String field4 = "10";
  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 15), (Timer t) => getThings());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Values from IOT',
              ),
              Text(
                '$field1\n$field2\n$field3\n$field4',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  getThings() async {
    final json = await getData(
            "https://api.thingspeak.com/channels/1723505/feeds.json?api_key=KK8AK4V7NOFHIOEW&results=2",
            post: false) ??
        [];
    print(json);
    final things = ThingSpeak.fromJson(json);
    setState(() {
      field1 = things.feeds!.first.field1.toString();
      field2 = things.feeds!.first.field2.toString();
      field3 = things.feeds!.first.field3.toString();
      field4 = things.feeds!.first.field4.toString();
    });
  }
}
