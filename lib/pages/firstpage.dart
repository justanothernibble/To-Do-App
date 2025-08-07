import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/alltasks.dart';
import 'package:flutter_application_2/pages/completed.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int chosenPage = 0;
  int _counter = 0;
  List<String> allTasksList = [];

  void increment() {
    setState(() {
      _counter++;
    });
  }

  void navigateBottomBar(int pageIndex) {
    setState(() {
      chosenPage = pageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      Completed(),
      AllTasks(
        counter: _counter,
        increment: increment,
        allTasksList: allTasksList,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text("To-Do App")),
      body: pages[chosenPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: chosenPage,
        onTap: (value) {
          navigateBottomBar(value);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Completed',
          ),

          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'AllTasks'),
        ],
      ),
    );
  }
}
