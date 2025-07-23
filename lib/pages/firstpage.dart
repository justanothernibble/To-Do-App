import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/profile.dart';
import 'package:flutter_application_2/pages/settings.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {

  int chosenPage = 0;
  
  void navigateBottomBar(int pageIndex){
    setState(() {
      chosenPage = pageIndex;
    });
  }

  List pages = [
    SettingsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("1st Page")),
      body: pages[chosenPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: chosenPage,
        onTap: (value) {
          navigateBottomBar(value);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ]
      ),

    );
  }
}