

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'dart:io';

class IpAddress {
  final String ip;
  final String name;

  IpAddress(this.ip, this.name);
}

Future<String> checkLiveBox(String ip) async {

  var res = await http.get(Uri.parse("http://$ip:8080/remoteControl/cmd?operation=10"));
  if (res.statusCode == 200) {
    var json = jsonDecode(res.body);
    return json['result']["data"]['friendlyName'];
  }   

  return "false";
}

Future<List<IpAddress>> scanNetwork() async {
  print('Scanning network');
  List<IpAddress> ListIp = [];
  await (NetworkInfo().getWifiIP()).then(
    (ip) async {
      print("IP FOUND: $ip");
      final String subnet = ip!.substring(0, ip.lastIndexOf('.'));
      const port = 8080;
      for (var i = 0; i < 256; i++) {
        String ip = '$subnet.$i';
        await Socket.connect(ip, port, timeout: Duration(milliseconds: 50))
          .then((socket) async {
            await InternetAddress(socket.address.address)
              .reverse()
              .then((value) {
                print("FOUND DEVICE");
                //ListIp.add({
                //  'ip': socket.address.address,
                //  'name': value.host ?? socket.address.address
                //});
                checkLiveBox(ip).then((value) {
                  if (value != "false") {
                    ListIp.add(IpAddress(socket.address.address, value));
                  }
                });
                print("IP : ${socket.address.address}");
                socket.destroy();
                
              }).catchError((error) {
                print(socket.address.address);
                // http://IP:8080/remoteControl/cmd?operation=10
                checkLiveBox(ip).then((value) {
                  if (value != "false") {
                    ListIp.add(IpAddress(socket.address.address, value));
                  }
                  socket.destroy();
                });

              });
          }).catchError((error) => null);
      }
    },
  );
  print('Done , found ${ListIp.length} devices, returning list');
  return ListIp;
}

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
  String UsedIp = "";
  String _url = "/remoteControl/cmd?operation=01&mode=0&key=";
  void press(code){
    print("http://"+UsedIp+":8080"+_url+code);
    http.get(Uri.parse("http://"+UsedIp+":8080"+_url+code));
    developer.log(_url+code);
  }


  List<IpAddress> ListIp = [];

  @override
  void initState() {
    super.initState();
    //scan();
    scanNetwork().then((value) {
      print("VALUE, ${value}");
      print("VALUE, ${value.length}, ${value[0].ip}");
      setState(() {
        ListIp = value;
        UsedIp = value.length > 0 ? value[0].ip : "";
      });
    });
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
            ElevatedButton(onPressed: () =>{press("116")}, child: const Text("Power")),
            // select ip from the list

            DropdownButton(
              value: UsedIp,
              onChanged: (value) {
                setState(() {
                  UsedIp = value as String ;
                });
              },
              items: ListIp.map((value) {
                return DropdownMenuItem(
                  value: value.ip,
                  child: Text(value.name),
                );
              }).toList(),
              
            ),

            Column(
              children: [


                FilledButton(onPressed: ()=>{press("103")}, child: const Text("Up")),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(onPressed: ()=>{press("105")}, child: const Text("Left")),
                    ElevatedButton(onPressed: () =>{press("352")}, child: const Text("Ok")),
                    FilledButton(onPressed: ()=>{press("106")}, child: const Text("Right")),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(onPressed: ()=>{press("104")}, child: const Text("Back")),
                    FilledButton(onPressed: ()=>{press("107")}, child: const Text("Home")),
                    FilledButton(onPressed: ()=>{press("102")}, child: const Text("Menu")),
                  ],
                )

              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    ElevatedButton(onPressed: () =>{press("114")}, child: const Text("+")),
                    ElevatedButton(onPressed: () =>{press("115")}, child: const Text("-")),
                    ElevatedButton(onPressed: () =>{press("113")}, child: const Text("Mute")),
                  ],
                ),
                Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(onPressed: ()=>{press("513")}, child: const Text("1")),
                    FilledButton(onPressed: ()=>{press("514")}, child: const Text("2")),
                    FilledButton(onPressed: ()=>{press("515")}, child: const Text("3")),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(onPressed: ()=>{press("516")}, child: const Text("4")),
                    FilledButton(onPressed: ()=>{press("517")}, child: const Text("5")),
                    FilledButton(onPressed: ()=>{press("518")}, child: const Text("6")),
                  ],),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(onPressed: ()=>{press("519")}, child: const Text("7")),
                    FilledButton(onPressed: ()=>{press("520")}, child: const Text("8")),
                    FilledButton(onPressed: ()=>{press("521")}, child: const Text("9")),
                  ],),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(onPressed: ()=>{press("512")}, child: const Text("0")),
                  ],),

              ],
            ),
                
                Column(
                  children: [
                    //next / previous
                        ElevatedButton(onPressed: ()=>{press("403")}, child: const Text("Next")),
                        ElevatedButton(onPressed: ()=>{press("402")}, child: const Text("Previous")),

                    
                  ],
                )
              ],
            ),
            
            
          ],
        ),
      ),
    );
  }
}
