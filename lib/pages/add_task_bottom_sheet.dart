import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/constants/app_constants.dart';
import '../providers/task_provider.dart';
import '../providers/ai_provider.dart';

/// Bottom sheet for adding tasks — matches the "add_task_sheet" design.
/// Glassmorphism background, drag handle, two action cards.
class AddTaskBottomSheet extends ConsumerStatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  ConsumerState<AddTaskBottomSheet> createState() =>
      _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends ConsumerState<AddTaskBottomSheet> {
  /// null = choice screen, 'manual' = form, 'ai-results' = AI results
  String? _mode;
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
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFBF9F5),
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        child: Container(
          color: Colors.white.withValues(alpha: 0.85),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Drag Handle ────────────────────────
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 32),
                child: Container(
                  width: 48,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.outlineVariant.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),

              // ── Content ────────────────────────────
              Flexible(child: _buildContent()),

              // Safe area bottom
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_mode == null) return _buildChoiceScreen();
    if (_mode == 'manual') return _buildManualForm();
    if (_mode == 'ai-results') return _buildAIResults();
    return const SizedBox.shrink();
  }

  // ── Choice Screen (two action cards) ────────────────
  Widget _buildChoiceScreen() {
    final aiState = ref.watch(aiAnalysisProvider);

    // If AI is analyzing, show loading
    if (aiState.isAnalyzing) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add to Sanctuary',
                    style: AppTypography.headlineLg.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '正在分析图片...',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(color: AppColors.primary),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '添加到清单',
                  style: AppTypography.headlineLg.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '选择记录这个瞬间的方式。',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Card 1: Identify from Photos
          _ActionCard(
            icon: Icons.photo_camera,
            sparkle: true,
            iconBgGradient: true,
            title: '从照片识别',
            subtitle: 'AI 智能提取任务详情。',
            onTap: () => _showImageSourcePicker(),
          ),
          const SizedBox(height: 16),

          // Card 2: Manual Entry
          _ActionCard(
            icon: Icons.edit,
            sparkle: false,
            iconBgGradient: false,
            title: '手动输入',
            subtitle: '自己填写任务详情。',
            onTap: () => setState(() => _mode = 'manual'),
          ),
        ],
      ),
    );
  }

  // ── Manual Form ─────────────────────────────────────
  Widget _buildManualForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button + title
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _mode = null),
                child: Icon(Icons.arrow_back, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Text(
                '手动输入',
                style: AppTypography.headlineSm.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: '任务标题',
              hintText: '例如：一起看日出',
            ),
            style: AppTypography.bodyLg,
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _descController,
            decoration: const InputDecoration(
              labelText: '描述（可选）',
              hintText: '添加活动的详细信息...',
            ),
            style: AppTypography.bodyMd,
            maxLines: 3,
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _categoryController,
            decoration: const InputDecoration(
              labelText: '分类（可选）',
              hintText: '例如：冒险、美食、旅行',
            ),
            style: AppTypography.bodyMd,
          ),
          const SizedBox(height: 32),

          // Save button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _saveTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusDefault),
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
                  : const Text('保存任务'),
            ),
          ),
        ],
      ),
    );
  }

  // ── AI Results ──────────────────────────────────────
  Widget _buildAIResults() {
    final aiState = ref.watch(aiAnalysisProvider);

    if (aiState.error != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    ref.read(aiAnalysisProvider.notifier).clearSuggestions();
                    setState(() => _mode = null);
                  },
                  child: Icon(Icons.arrow_back, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Text('Error', style: AppTypography.headlineSm),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              aiState.error!,
              style: AppTypography.bodyMd.copyWith(color: AppColors.error),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  ref.read(aiAnalysisProvider.notifier).clearSuggestions();
                  setState(() => _mode = null);
                },
                child: Icon(Icons.arrow_back, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '发现了 ${aiState.suggestedTasks.length} 个任务',
                  style: AppTypography.headlineSm.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: _importAllSuggested,
                icon: const Icon(Icons.playlist_add, size: 18),
                label: const Text('全部导入'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Suggested tasks list
          ...aiState.suggestedTasks.map((task) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Material(
                  color: AppColors.surfaceContainerLow,
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusDefault),
                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusDefault),
                    onTap: () {
                      _titleController.text = task['title'] ?? '';
                      _descController.text = task['description'] ?? '';
                      _categoryController.text = task['category'] ?? '';
                      ref
                          .read(aiAnalysisProvider.notifier)
                          .clearSuggestions();
                      setState(() => _mode = 'manual');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
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
                                  style: AppTypography.bodyMd.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
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
              )),
        ],
      ),
    );
  }

  // ── Image source picker ─────────────────────────────
  void _showImageSourcePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Container(
                width: 48,
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.outlineVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined,
                    color: AppColors.primary),
                title: const Text('从相册选择'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined,
                    color: AppColors.primary),
                title: const Text('拍照'),
                onTap: () {
                  Navigator.pop(ctx);
                  _takePhoto();
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      ref.read(aiAnalysisProvider.notifier).analyzeImage(image.path);
      setState(() => _mode = 'ai-results');
    }
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      ref.read(aiAnalysisProvider.notifier).analyzeImage(image.path);
      setState(() => _mode = 'ai-results');
    }
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
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('已导入 ${aiState.suggestedTasks.length} 个任务'),
        ),
      );
    }
  }

  Future<void> _saveTask() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入任务标题')),
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
    if (!mounted) return;

    final error = ref.read(taskListProvider).error;
    if (error != null) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: $error')),
      );
      return;
    }
    Navigator.pop(context);
  }
}

/// Private action card widget matching the add_task_sheet design.
class _ActionCard extends StatelessWidget {
  final IconData icon;
  final bool sparkle;
  final bool iconBgGradient;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.sparkle,
    required this.iconBgGradient,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF31332F).withValues(alpha: 0.03),
              blurRadius: 30,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: iconBgGradient
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primaryFixed,
                          AppColors.surfaceContainerLowest,
                        ],
                      )
                    : null,
                color: iconBgGradient
                    ? null
                    : AppColors.surfaceContainerLow,
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(icon,
                        size: 28,
                        color: AppColors.primary),
                  ),
                  if (sparkle)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(Icons.auto_awesome,
                          size: 16,
                          color: AppColors.primary.withValues(alpha: 0.5)),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 20),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleMd.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
