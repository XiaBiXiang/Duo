import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/constants/app_constants.dart';
import '../providers/task_provider.dart';
import '../providers/ai_provider.dart';

/// Add Task page — manual input or AI-powered image recognition.
class AddTaskPage extends ConsumerStatefulWidget {
  const AddTaskPage({super.key});

  @override
  ConsumerState<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends ConsumerState<AddTaskPage> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _categoryController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final aiState = ref.watch(aiAnalysisProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('New Task'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingLg,
          vertical: AppConstants.spacingMd,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── AI Photo Recognition ─────────────────
            _buildAISection(aiState),

            const SizedBox(height: AppConstants.spacingXl),

            // ── Manual Input ─────────────────────────
            Text(
              'Or add manually',
              style: AppTypography.titleMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppConstants.spacingMd),

            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task title',
                hintText: 'e.g., Watch the sunrise together',
              ),
              style: AppTypography.bodyLg,
            ),
            const SizedBox(height: AppConstants.spacingMd),

            TextField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'Add details about this activity...',
              ),
              style: AppTypography.bodyMd,
              maxLines: 3,
            ),
            const SizedBox(height: AppConstants.spacingMd),

            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Category (optional)',
                hintText: 'e.g., Adventure, Food, Travel',
              ),
              style: AppTypography.bodyMd,
            ),
            const SizedBox(height: AppConstants.spacingXl),

            // ── Save Button ──────────────────────────
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAISection(AIAnalysisState aiState) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppConstants.ghostBorderColor, width: 1),
        boxShadow: AppConstants.ambientShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome,
                  color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'AI Recognition',
                style: AppTypography.titleMd.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            'Take a photo or choose from gallery — AI will extract tasks automatically.',
            style: AppTypography.bodySm.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: aiState.isAnalyzing ? null : _pickFromGallery,
                  icon: const Icon(Icons.photo_library_outlined, size: 18),
                  label: const Text('Gallery'),
                ),
              ),
              const SizedBox(width: AppConstants.spacingSm),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: aiState.isAnalyzing ? null : _takePhoto,
                  icon: const Icon(Icons.camera_alt_outlined, size: 18),
                  label: const Text('Camera'),
                ),
              ),
            ],
          ),
          if (aiState.isAnalyzing) ...[
            const SizedBox(height: AppConstants.spacingMd),
            const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
            const SizedBox(height: AppConstants.spacingSm),
            Center(
              child: Text(
                'Analyzing image...',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ],
          if (aiState.suggestedTasks.isNotEmpty) ...[
            const SizedBox(height: AppConstants.spacingMd),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Found ${aiState.suggestedTasks.length} tasks',
                  style: AppTypography.labelMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                TextButton.icon(
                  onPressed: _importAllSuggested,
                  icon: const Icon(Icons.playlist_add, size: 18),
                  label: const Text('Import All'),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingSm),
            ...aiState.suggestedTasks.map(
              (task) => _buildSuggestedTask(task),
            ),
          ],
          if (aiState.error != null) ...[
            const SizedBox(height: AppConstants.spacingMd),
            Text(
              'Error: ${aiState.error}',
              style: AppTypography.bodySm.copyWith(
                color: AppColors.error,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSuggestedTask(Map<String, String> task) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingSm),
      child: Material(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppConstants.radiusDefault),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppConstants.radiusDefault),
          onTap: () {
            _titleController.text = task['title'] ?? '';
            _descController.text = task['description'] ?? '';
            _categoryController.text = task['category'] ?? '';
            ref.read(aiAnalysisProvider.notifier).clearSuggestions();
          },
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            child: Row(
              children: [
                const Icon(Icons.add_circle_outline,
                    color: AppColors.primary, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task['title'] ?? '',
                        style: AppTypography.bodyMd,
                      ),
                      if ((task['category'] ?? '').isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          task['category']!,
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios,
                    size: 14, color: AppColors.outlineVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: _isSaving ? null : _saveTask,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusDefault),
          ),
        ),
        child: _isSaving
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.onPrimary,
                ),
              )
            : const Text('Save Task'),
      ),
    );
  }

  Future<void> _importAllSuggested() async {
    final aiState = ref.read(aiAnalysisProvider);
    if (aiState.suggestedTasks.isEmpty) return;

    setState(() => _isSaving = true);
    for (final task in aiState.suggestedTasks) {
      await ref.read(taskListProvider.notifier).addTask(
            title: task['title'] ?? '',
            description: (task['description'] ?? '').isEmpty
                ? null
                : task['description'],
            category: (task['category'] ?? '').isEmpty
                ? null
                : task['category'],
          );
    }
    ref.read(aiAnalysisProvider.notifier).clearSuggestions();
    setState(() => _isSaving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Imported ${aiState.suggestedTasks.length} tasks'),
        ),
      );
    }
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      ref.read(aiAnalysisProvider.notifier).analyzeImage(image.path);
    }
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      ref.read(aiAnalysisProvider.notifier).analyzeImage(image.path);
    }
  }

  Future<void> _saveTask() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a task title')),
      );
      return;
    }

    setState(() => _isSaving = true);
    await ref.read(taskListProvider.notifier).addTask(
          title: _titleController.text.trim(),
          description: _descController.text.trim().isEmpty
              ? null
              : _descController.text.trim(),
          category: _categoryController.text.trim().isEmpty
              ? null
              : _categoryController.text.trim(),
        );
    if (mounted) context.pop();
  }
}
