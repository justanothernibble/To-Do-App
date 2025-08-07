import 'package:flutter/material.dart';

class AllTasks extends StatelessWidget {
  final int counter;
  final VoidCallback increment;
  
  
  const AllTasks({super.key, required this.counter, required this.increment});



  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text("Counter $counter"),
          ElevatedButton(onPressed: increment, child: Text("+"))
        ]
      ),
    );
  }
}