import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Task {
  final String id;
  final String name;
  final String description;
  final String priority;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Task({
    required this.id,
    required this.name,
    this.description = '',
    this.priority = 'Medium',
    this.isCompleted = false,
    required this.createdAt,
    this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      priority: json['priority'] as String? ?? 'Medium',
      isCompleted: json['is_completed'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'priority': priority,
      'is_completed': isCompleted,
      // created_at and updated_at are handled by Supabase
    };
  }

  Task copyWith({
    String? id,
    String? name,
    String? description,
    String? priority,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;

  late final SupabaseClient _client;
  final String _tableName = 'to-do-list';

  SupabaseService._internal() {
    _client = Supabase.instance.client;
  }

  // Initialize Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );
  }

  // Get Supabase client
  SupabaseClient get client => _client;

  // Task CRUD operations will be added here

  // Example method to fetch tasks
  Future<List<Task>> getTasks() async {
    final response = await _client
        .from(_tableName)
        .select()
        .order('created_at', ascending: false);
    return (response as List)
        .map((task) => Task.fromJson(task as Map<String, dynamic>))
        .toList();
  }

  // Pull a task using ID only
  Future<Task?> getTask(String id) async {
    final response = await _client
        .from(_tableName)
        .select()
        .eq('id', id)
        .single();
    return Task.fromJson(response as Map<String, dynamic>);
  }

  // Create a new task
  Future<Task> createTask({
    required String name,
    String description = '',
    required String priority,
  }) async {
    final task = {
      // Create a task object
      'name': name,
      'description': description,
      'priority': priority,
      'is_completed': false,
    };
    final response = await _client
        .from(_tableName)
        .insert(task)
        .select()
        .single();
    return Task.fromJson(response as Map<String, dynamic>);
  }

  // Update a task
  Future<Task> updateTask(Task task) async {
    final updates = {
      'name': task.name,
      'description': task.description,
      'is_completed': task.isCompleted,
      'updated_at': DateTime.now().toIso8601String(),
    };
    final response = await _client
        .from(_tableName)
        .update(updates)
        .eq('id', task.id)
        .select()
        .single();

    return Task.fromJson(response as Map<String, dynamic>);
  }

  // Toggle task completion status
  Future<Task> toggleTaskCompletion(String taskID, bool isCompleted) async {
    final response = await _client
        .from(_tableName)
        .update({
          'is_completed': isCompleted,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', taskID)
        .select()
        .single();
    return Task.fromJson(response as Map<String, dynamic>);
  }

  // Delete a task
  Future<void> deleteTask(String taskID) async {
    await _client.from(_tableName).delete().eq('id', taskID);
  }

  // Subscribe to task changes
  Stream<List<Map<String, dynamic>>> getTasksStream() {
    return _client
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .order('created_at');
  }
}
