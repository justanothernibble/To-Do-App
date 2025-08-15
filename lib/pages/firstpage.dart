import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/alltasks.dart';
import 'package:flutter_application_2/pages/completed.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  static const int allInt = 0;
  static const int completedInt = 1;
  static const int incompletedInt = 2;
  int? _selectedFilter = allInt;

  void _onFilterChanged(int? value) {
    setState(() {
      _selectedFilter = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentPage;
    if (_selectedFilter == allInt) {
      currentPage = const AllTasks(filter: 'All');
    } else if (_selectedFilter == completedInt) {
      currentPage = const AllTasks(filter: 'Completed');
    } else {
      currentPage = const AllTasks(filter: 'Incomplete');
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("To-Do App"),
        leading: PopupMenuButton<int>(
          tooltip: 'Filter',
          icon: const Icon(Icons.filter_list),
          initialValue: _selectedFilter,
          onSelected: _onFilterChanged,
          itemBuilder: (context) => const [
            PopupMenuItem(value: allInt, child: Text('All')),
            PopupMenuItem(value: completedInt, child: Text('Completed')),
            PopupMenuItem(value: incompletedInt, child: Text('Incomplete')),
          ],
        ),
      ),
      body: currentPage,
    );
  }
}
