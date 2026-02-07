import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/dashboard/task_model.dart';
import '../main.dart';
import '../services/supabase_service.dart';

final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
});

final taskListProvider = FutureProvider<List<Task>>((ref) async {
  final authState = ref.watch(authStateProvider);

  final session = authState.value?.session;
  if (session == null) return [];

  final supabaseService = ref.watch(supabaseServiceProvider);
  return supabaseService.fetchTasks();
});

final taskOperationsProvider = Provider<TaskOperations>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return TaskOperations(ref, supabaseService);
});


class TaskOperations {
  final Ref ref;
  final SupabaseService _supabaseService;

  TaskOperations(this.ref, this._supabaseService);

  Future<void> addTask(String title) async {
    if (title.trim().isEmpty) return;
    await _supabaseService.addTask(title.trim());
    ref.invalidate(taskListProvider);
  }

  Future<void> toggleTaskCompletion(Task task) async {
    await _supabaseService.updateTask(
      task.id,
      isCompleted: !task.isCompleted,
    );
    ref.invalidate(taskListProvider);
  }

  Future<void> editTask(String taskId, String newTitle) async {
    if (newTitle.trim().isEmpty) return;
    await _supabaseService.updateTask(taskId, title: newTitle.trim());
    ref.invalidate(taskListProvider);
  }

  Future<void> deleteTask(String taskId) async {
    await _supabaseService.deleteTask(taskId);
    ref.invalidate(taskListProvider);
  }
}
