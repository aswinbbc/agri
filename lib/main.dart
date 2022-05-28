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
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Agriculture'),
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
  String field1 = "loading...";
  String field2 = "loading...";
  String field3 = "loading...";
  String field4 = "0.0";
  @override
  void initState() {
    getThings();
    timer = Timer.periodic(Duration(seconds: 15), (Timer t) => getThings());
    // getThings();
    super.initState();
  }

  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: isLoading
              ? CircularProgressIndicator()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 60,
                    ),
                    const Text(
                      'Values from Sensors',
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Humidity',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Text(
                          field1,
                          style: Theme.of(context).textTheme.headline4,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Temperature',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Text(
                          field2,
                          style: Theme.of(context).textTheme.headline4,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Moisture',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Text(
                          field3,
                          style: Theme.of(context).textTheme.headline4,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'pH',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Text(
                          String.fromCharCode(
                              (double.parse(field4.trim()).toInt())),
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ],
                    ),
                    Expanded(child: Container())
                    // Text(
                    //   '$field1\n$field2\n$field3\n$field4',
                    //   style: Theme.of(context).textTheme.headline4,
                    // ),
                  ],
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isLoading = true;
          });
          getThings();
          // setState(() {});
        },
        child: Icon(Icons.restart_alt),
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
      isLoading = false;
    });
  }
}
