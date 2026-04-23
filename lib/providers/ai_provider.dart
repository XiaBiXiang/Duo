import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ai_service.dart';

/// State for AI image analysis.
class AIAnalysisState {
  final bool isAnalyzing;
  final List<Map<String, String>> suggestedTasks;
  final String? error;

  const AIAnalysisState({
    this.isAnalyzing = false,
    this.suggestedTasks = const [],
    this.error,
  });

  AIAnalysisState copyWith({
    bool? isAnalyzing,
    List<Map<String, String>>? suggestedTasks,
    String? error,
  }) {
    return AIAnalysisState(
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      suggestedTasks: suggestedTasks ?? this.suggestedTasks,
      error: error,
    );
  }
}

class AIAnalysisNotifier extends StateNotifier<AIAnalysisState> {
  AIAnalysisNotifier() : super(const AIAnalysisState());

  Future<void> analyzeImage(String imagePath) async {
    state = state.copyWith(isAnalyzing: true, error: null);
    try {
      final tasks = await AIService.analyzeImage(imagePath);
      state = state.copyWith(isAnalyzing: false, suggestedTasks: tasks);
    } catch (e) {
      state = state.copyWith(isAnalyzing: false, error: e.toString());
    }
  }

  void clearSuggestions() {
    state = const AIAnalysisState();
  }
}

final aiAnalysisProvider =
    StateNotifierProvider<AIAnalysisNotifier, AIAnalysisState>(
  (ref) => AIAnalysisNotifier(),
);
