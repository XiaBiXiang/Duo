import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../services/database_service.dart';
import 'appwrite_provider.dart';
import 'auth_provider.dart';
import 'couple_provider.dart';

/// Filter for the task list view.
enum TaskFilter { all, pending, completed }

/// State holder for the task list.
class TaskListState {
  final List<Task> tasks;
  final bool isLoading;
  final String? error;
  final TaskFilter filter;

  const TaskListState({
    this.tasks = const [],
    this.isLoading = false,
    this.error,
    this.filter = TaskFilter.all,
  });

  List<Task> get filteredTasks {
    switch (filter) {
      case TaskFilter.all:
        return tasks;
      case TaskFilter.pending:
        return tasks.where((t) => t.status == TaskStatus.pending).toList();
      case TaskFilter.completed:
        return tasks.where((t) => t.status == TaskStatus.completed).toList();
    }
  }

  int get completedCount =>
      tasks.where((t) => t.status == TaskStatus.completed).length;
  int get totalCount => tasks.length;

  TaskListState copyWith({
    List<Task>? tasks,
    bool? isLoading,
    String? error,
    TaskFilter? filter,
  }) {
    return TaskListState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      filter: filter ?? this.filter,
    );
  }
}

class TaskNotifier extends StateNotifier<TaskListState> {
  final DatabaseService _db;
  final String? _coupleId;
  final String? _userId;

  TaskNotifier(this._db, this._coupleId, this._userId)
      : super(const TaskListState()) {
    if (_coupleId != null) loadTasks();
  }

  Future<void> loadTasks() async {
    if (_coupleId == null) return;
    state = state.copyWith(isLoading: true);
    try {
      final tasks = await _db.getTasks(_coupleId!);
      state = state.copyWith(tasks: tasks, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addTask({
    required String title,
    String? description,
    String? category,
  }) async {
    if (_coupleId == null || _userId == null) {
      state = state.copyWith(error: '未登录或未配对，无法创建任务');
      return;
    }
    try {
      final task = await _db.createTask(
        coupleId: _coupleId!,
        createdBy: _userId!,
        title: title,
        description: description,
        category: category,
      );
      state = state.copyWith(tasks: [task, ...state.tasks]);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> toggleTaskStatus(Task task) async {
    final newStatus = task.status == TaskStatus.pending
        ? TaskStatus.completed
        : TaskStatus.pending;
    final updated = task.copyWith(
      status: newStatus,
      completedAt: newStatus == TaskStatus.completed ? DateTime.now() : null,
    );
    try {
      await _db.updateTask(updated);
      state = state.copyWith(
        tasks: state.tasks.map((t) => t.id == task.id ? updated : t).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _db.deleteTask(taskId);
      state = state.copyWith(
        tasks: state.tasks.where((t) => t.id != taskId).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void setFilter(TaskFilter filter) {
    state = state.copyWith(filter: filter);
  }
}

/// Database service provider — depends on Appwrite client.
final databaseProvider = Provider<DatabaseService>((ref) {
  return DatabaseService(
    ref.watch(databasesProvider),
    ref.watch(storageProvider),
  );
});

/// Task list provider — scoped to current couple.
final taskListProvider =
    StateNotifierProvider<TaskNotifier, TaskListState>((ref) {
  final coupleId = ref.watch(coupleProvider).coupleId;
  final userId = ref.watch(authProvider).user?.$id;
  return TaskNotifier(ref.watch(databaseProvider), coupleId, userId);
});
