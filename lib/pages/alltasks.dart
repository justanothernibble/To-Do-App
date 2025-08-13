import 'package:flutter/material.dart';

class AllTasks extends StatefulWidget {
  final List<List<String>> allTasksList;

  const AllTasks({super.key, required this.allTasksList});

  @override
  State<AllTasks> createState() => _AllTasksState();
}

class _AddTaskDialog extends StatefulWidget {
  final Function(String name, String description, String priority) onTaskAdded;
  const _AddTaskDialog({Key? key, required this.onTaskAdded}) : super(key: key);

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<_AddTaskDialog> {
  bool isNameDone = false;
  bool isPriorityDone = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedPriority;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 200,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: 200,
                child: TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.task),
                    hintText: "Name",
                  ),
                  onChanged: (value) {
                    setState(() {
                      isNameDone = value.trim().isNotEmpty;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 200,
                child: TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.description),
                    hintText: "Description",
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 200,
                child: DropdownButtonFormField<String>(
                  onChanged: (value) {
                    setState(() {
                      _selectedPriority = value;
                      isPriorityDone = value != null && value.trim().isNotEmpty;
                    });
                  },
                  hint: const Text("Priority"),
                  items: [
                    DropdownMenuItem(
                      value: "Low",
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Text("Low"),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: "Medium",
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.amber,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Text("Medium"),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: "High",
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Text("High"),
                        ],
                      ),
                    ),
                  ],
                  value: null,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Close"),
                  ),
                  const SizedBox(width: 10),
                  AbsorbPointer(
                    absorbing: !(isNameDone && isPriorityDone),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          widget.onTaskAdded(
                            _nameController.text,
                            _descriptionController.text,
                            _selectedPriority ?? '',
                          );
                        });
                        Navigator.pop(context);
                      },
                      child: const Text("Submit"),
                    ),
                  ),
                ],
              ),
              // Debug info
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Name: $isNameDone"),
                  const SizedBox(width: 10),
                  Text("Priority: $isPriorityDone"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AllTasksState extends State<AllTasks> {
  final _scrollController = ScrollController();
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
                child: const Icon(Icons.playlist_add_rounded),
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => _AddTaskDialog(
                    onTaskAdded: (name, description, priority) {
                      setState(() {
                        widget.allTasksList.add([
                          name,
                          description,
                          priority,
                          "incomplete",
                        ]);
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(200.0),
            child: ListView.builder(
              controller: _scrollController,
              itemExtent: 20,
              itemCount: widget.allTasksList.length,
              itemBuilder: (context, index) {
                final task = widget.allTasksList[index];
                return Row(
                  children: [
                    SizedBox(width: 50, child: Text("${index + 1}")),
                    SizedBox(width: 100, child: Text("Title: ${task[0]}")),
                    Expanded(
                      child: Text(
                        "Desc: ${task[1]}",
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 80, child: Text("Priority: ${task[2]}")),
                    SizedBox(width: 80, child: Text("Status: ${task[3]}")),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
