import 'package:flutter/material.dart';

class AllTasks extends StatefulWidget {
  final int counter;
  final VoidCallback increment;
  final List<String> allTasksList;

  const AllTasks({
    super.key,
    required this.counter,
    required this.increment,
    required this.allTasksList,
  });

  @override
  State<AllTasks> createState() => _AllTasksState();
}

class _AllTasksState extends State<AllTasks> {
  String? priority = "";
  bool isPriorityDone = false; // priority is required
  bool isNameDone = false; // name is required
  // description is allowed to be empty

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ElevatedButton(
                // Add Task Button
                child: Icon(Icons.playlist_add_rounded),
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => Dialog(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(
                            // Name Input
                            width: 200,
                            child: TextFormField(
                              decoration: InputDecoration(
                                icon: Icon(Icons.task),
                                hintText: "Name",
                              ),
                              onChanged: (value) {
                                if (value.trim().isNotEmpty) {
                                  isNameDone = true;
                                } else {
                                  isNameDone = false;
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            // Description Input
                            width: 200,
                            child: TextFormField(
                              decoration: InputDecoration(
                                icon: Icon(Icons.description),
                                hintText: "Description",
                              ),
                            ),
                          ),
                          SizedBox(
                            // Priority Input
                            width: 200,
                            child: DropdownButtonFormField(
                              onChanged: (value) {
                                if (value?.isNotEmpty ?? false) {
                                  isPriorityDone = true;
                                } else {
                                  isPriorityDone = false;
                                }
                              },
                              hint: Text("Priority"),
                              items: [
                                // Low Priority Green
                                DropdownMenuItem(
                                  value: "Low",
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text("Low"),
                                    ],
                                  ),
                                ),
                                // Medium Priority Amber
                                DropdownMenuItem(
                                  value: "Medium",
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: Colors.amber,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text("Medium"),
                                    ],
                                  ),
                                ),
                                // High Priority Red
                                DropdownMenuItem(
                                  value: "High",
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text("High"),
                                    ],
                                  ),
                                ),
                              ],
                              value: null,
                            ),
                          ),
                          Row(
                            children: [Container(height: 10)],
                          ), // 10 pixel buffer
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("Close"),
                              ),
                              Container(width: 10),
                              AbsorbPointer(
                                absorbing:
                                    isNameDone == false &&
                                    isPriorityDone == false,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Submit"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
