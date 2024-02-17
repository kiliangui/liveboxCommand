

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Télécommande sans pubs pour ma maman',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Télécommande sans pubs pour ma maman'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String _url = "http://192.168.1.10:8080/remoteControl/cmd?operation=01&mode=0&key=";
  void press(code){
    http.get(Uri.parse(_url+code));
    developer.log(_url+code);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FilledButton(onPressed: ()=>{press("158")}, child: const Text("Back")),
            ElevatedButton(onPressed: () =>{press("352")}, child: const Text("Ok")),
            Row(
              children: [
                FilledButton(onPressed: ()=>{press("105")}, child: const Text("Left")),
                FilledButton(onPressed: ()=>{press("103")}, child: const Text("Up")),
                FilledButton(onPressed: ()=>{press("108")}, child: const Text("Down")),
                FilledButton(onPressed: ()=>{press("106")}, child: const Text("Right")),
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    FilledButton(onPressed: ()=>{press("513")}, child: const Text("1")),
                    FilledButton(onPressed: ()=>{press("514")}, child: const Text("2")),
                    FilledButton(onPressed: ()=>{press("515")}, child: const Text("3")),
                  ],
                ),
                Row(
                  children: [
                    FilledButton(onPressed: ()=>{press("516")}, child: const Text("4")),
                    FilledButton(onPressed: ()=>{press("517")}, child: const Text("5")),
                    FilledButton(onPressed: ()=>{press("518")}, child: const Text("6")),
                  ],),
                Row(
                  children: [
                    FilledButton(onPressed: ()=>{press("519")}, child: const Text("7")),
                    FilledButton(onPressed: ()=>{press("520")}, child: const Text("8")),
                    FilledButton(onPressed: ()=>{press("521")}, child: const Text("9")),
                  ],),
                Row(
                  children: [
                    FilledButton(onPressed: ()=>{press("512")}, child: const Text("0")),
                  ],),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
