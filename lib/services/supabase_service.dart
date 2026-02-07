import 'package:supabase_flutter/supabase_flutter.dart';
import '../dashboard/task_model.dart';

class SupabaseService {
  final _client = Supabase.instance.client;

  // Get current user ID
  String? get currentUserId => _client.auth.currentUser?.id;

  // Fetch all tasks for current user
  Future<List<Task>> fetchTasks() async {
    final user = _client.auth.currentUser;

    if (user == null) return [];

    final response = await _client
        .from('tasks')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => Task.fromJson(json))
        .toList();
  }


  // Add a new task
  Future<void> addTask(String title) async {
    final user = _client.auth.currentUser;

    if (user == null) return;

    await _client.from('tasks').insert({
      'title': title,
      'user_id': user.id,
      'is_completed': false,
    });
  }


  // Update task (mark as completed or edit title)
  Future<Task> updateTask(String taskId, {String? title, bool? isCompleted}) async {
    try {
      final updateData = <String, dynamic>{};
      if (title != null) updateData['title'] = title;
      if (isCompleted != null) updateData['is_completed'] = isCompleted;

      final response = await _client
          .from('tasks')
          .update(updateData)
          .eq('id', taskId)
          .select()
          .single();

      return Task.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  // Delete task
  Future<void> deleteTask(String taskId) async {
    try {
      await _client.from('tasks').delete().eq('id', taskId);
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

}
