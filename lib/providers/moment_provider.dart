import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/moment.dart';
import '../services/database_service.dart';
import 'task_provider.dart';
import 'auth_provider.dart';
import 'couple_provider.dart';

/// State for moments of a specific task.
class MomentListState {
  final List<Moment> moments;
  final bool isLoading;
  final String? error;

  const MomentListState({
    this.moments = const [],
    this.isLoading = false,
    this.error,
  });

  MomentListState copyWith({
    List<Moment>? moments,
    bool? isLoading,
    String? error,
  }) {
    return MomentListState(
      moments: moments ?? this.moments,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class MomentNotifier extends StateNotifier<MomentListState> {
  final DatabaseService _db;
  final String _taskId;
  final String? _coupleId;
  final String? _userId;

  MomentNotifier(this._db, this._taskId, this._coupleId, this._userId)
      : super(const MomentListState()) {
    if (_coupleId != null) loadMoments();
  }

  Future<void> loadMoments() async {
    if (_coupleId == null) return;
    state = state.copyWith(isLoading: true);
    try {
      final moments = await _db.getMoments(_coupleId!, _taskId);
      state = state.copyWith(moments: moments, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addMoment({
    String? reflection,
    String? photoUrl,
    String? localPhotoPath,
  }) async {
    if (_coupleId == null || _userId == null) return;
    try {
      final moment = await _db.createMoment(
        coupleId: _coupleId!,
        taskId: _taskId,
        createdBy: _userId!,
        reflection: reflection,
        photoUrl: photoUrl,
        localPhotoPath: localPhotoPath,
      );
      state = state.copyWith(moments: [...state.moments, moment]);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateReflection(String momentId, String reflection) async {
    final idx = state.moments.indexWhere((m) => m.id == momentId);
    if (idx == -1) return;
    final updated = state.moments[idx].copyWith(reflection: reflection);
    try {
      await _db.updateMoment(updated);
      state = state.copyWith(
        moments: [...state.moments]..[idx] = updated,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteMoment(String momentId) async {
    try {
      await _db.deleteMoment(momentId);
      state = state.copyWith(
        moments: state.moments.where((m) => m.id != momentId).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<String?> uploadAndAddPhoto(String filePath) async {
    if (_coupleId == null || _userId == null) return null;
    try {
      final fileId = await _db.uploadPhoto(filePath);
      final photoUrl = _db.getPhotoUrl(fileId);
      await addMoment(photoUrl: photoUrl);
      return photoUrl;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }
}

/// Moments for a specific task.
final momentListProvider =
    StateNotifierProvider.family<MomentNotifier, MomentListState, String>(
  (ref, taskId) {
    final coupleId = ref.watch(coupleProvider).coupleId;
    final userId = ref.watch(authProvider).user?.$id;
    return MomentNotifier(
      ref.watch(databaseProvider),
      taskId,
      coupleId,
      userId,
    );
  },
);
