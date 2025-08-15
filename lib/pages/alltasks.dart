import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/supabase_service.dart';

class AllTasks extends StatefulWidget {
  final List<List<String>> allTasksList;

  const AllTasks({super.key, required this.allTasksList});

  @override
  State<AllTasks> createState() => _AllTasksState();
}

class _AddTaskDialog extends StatefulWidget {
  final Function(String name, String description, String priority) onTaskAdded;
  const _AddTaskDialog({super.key, required this.onTaskAdded});

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
  bool _isLoading = true;
  final List<Map<String, dynamic>> _tasks = [];
  late final SupabaseService _supabaseService;

  @override
  void initState() {
    super.initState();
    _supabaseService = SupabaseService();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);
    try {
      final tasks = await _supabaseService.getTasks();
      setState(() {
        _tasks.clear();
        _tasks.addAll(
          tasks.map(
            (task) => {
              'id': task.id,
              'name': task.name,
              'description': task.description,
              'priority': task.priority,
              'status': task.isCompleted ? 'completed' : 'incomplete',
            },
          ),
        );
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error loading tasks: $e")));
        print(e);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _addTask(String name, String description, String prioity) async {
    try {
      await _supabaseService.createTask(
        name: name,
        description: description,
        priority: prioity,
      );
      await _loadTasks();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error adding task: $e")));
        print(e);
      }
    }
  }

  Future<void> _toggleTaskStatus(int index) async {
    try {
      final task = _tasks[index];
      final isComplete = task['status'] == 'completed';
      await _supabaseService.toggleTaskCompletion(task['id'], !isComplete);
      setState(() {
        // Update the task status
        _tasks[index]['status'] = isComplete ? 'incomplete' : 'completed';
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error toggling task status: $e")),
        );
      }
    }
  }

  @override
  void dispose() {
    // Dispose of the scroll controller
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Loading indicator
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Add Task"),
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) =>
                      _AddTaskDialog(onTaskAdded: _addTask),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: _tasks.isEmpty
              ? const Center(child: Text("No tasks. Add your first"))
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      final bool hasDescription =
                          task['description'].isNotEmpty;
                      final bool isComplete = task['status'] == 'completed';
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 50,
                                  child: Center(child: Text("${index + 1}")),
                                ),
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    task['name'],
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                    "Priority: ${task['priority']}",
                                    style: TextStyle(
                                      color: task['priority'] == "Low"
                                          ? Colors.green
                                          : task['priority'] == "Medium"
                                          ? Colors.amber
                                          : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 25,
                                  child: Checkbox(
                                    value: isComplete,
                                    onChanged: (_) {
                                      _toggleTaskStatus(index);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            if (hasDescription)
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 4.0,
                                  left: 50,
                                ),
                                child: Text(
                                  task['description'],
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
