import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/firstpage.dart';
import 'package:flutter_application_2/pages/profile.dart';
import 'package:flutter_application_2/pages/settings.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirstPage(),
      routes: {
        '/firstpage': (context) => FirstPage(),
        '/settingspage': (context) => SettingsPage(),
        'profilepage:': (context) => ProfilePage()
        },
    );
  }
}