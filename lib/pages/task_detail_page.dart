import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/constants/app_constants.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../providers/moment_provider.dart';
import '../widgets/moment_photo.dart';

/// Task Detail & Memory page.
/// Based on the design HTML: task info at top, reflection area, photo grid.
class TaskDetailPage extends ConsumerStatefulWidget {
  final String taskId;

  const TaskDetailPage({super.key, required this.taskId});

  @override
  ConsumerState<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends ConsumerState<TaskDetailPage> {
  late TextEditingController _reflectionController;

  @override
  void initState() {
    super.initState();
    _reflectionController = TextEditingController();
  }

  @override
  void dispose() {
    _reflectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(taskListProvider);
    final task = taskState.tasks.where((t) => t.id == widget.taskId).firstOrNull;
    final momentsState = ref.watch(momentListProvider(widget.taskId));

    if (task == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(child: Text('Task not found')),
      );
    }

    final isCompleted = task.status == TaskStatus.completed;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Glass Header ──────────────────────────
          SliverAppBar(
            floating: true,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            title: Text(
              'Memory',
              style: AppTypography.titleLg.copyWith(
                fontFamily: 'Inter',
                color: AppColors.primary,
              ),
            ),
          ),

          // ── Task Info ─────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingLg,
                vertical: AppConstants.spacingSm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Status
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          task.title,
                          style: AppTypography.headlineLg.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.onSurface,
                            letterSpacing: -0.02,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildStatusChip(isCompleted),
                    ],
                  ),
                  if (task.description != null &&
                      task.description!.isNotEmpty) ...[
                    const SizedBox(height: AppConstants.spacingMd),
                    Text(
                      task.description!,
                      style: AppTypography.bodyLg.copyWith(
                        color: AppColors.onSurfaceVariant,
                        height: 1.6,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // ── Reflection Area ───────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingLg,
                vertical: AppConstants.spacingXl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: AppConstants.spacingSm),
                    child: Text(
                      'Our Reflections',
                      style: AppTypography.labelMd.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingSm),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusMd),
                      border: Border.all(
                        color: AppConstants.ghostBorderColor,
                        width: 1,
                      ),
                      boxShadow: AppConstants.ambientShadow,
                    ),
                    child: TextField(
                      controller: _reflectionController,
                      maxLines: 6,
                      style: AppTypography.bodyMd,
                      decoration: InputDecoration(
                        hintText:
                            'Write about the cold breeze, the colors in the sky, or just how it felt...',
                        hintStyle: AppTypography.bodyMd.copyWith(
                          color: AppColors.outlineVariant,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(
                            AppConstants.spacingLg),
                      ),
                      onChanged: (value) {
                        _saveReflection(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Photo Grid Header ─────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingLg,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: AppConstants.spacingSm),
                    child: Text(
                      'Moments Captured',
                      style: AppTypography.headlineSm.copyWith(
                        fontFamily: 'Inter',
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _addPhoto,
                    icon: const Icon(Icons.add_photo_alternate, size: 18),
                    label: const Text('Add'),
                  ),
                ],
              ),
            ),
          ),

          // ── Photo Grid ────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: AppConstants.photoGridColumns,
                mainAxisSpacing: AppConstants.spacingMd,
                crossAxisSpacing: AppConstants.spacingMd,
                mainAxisExtent: 200,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final photos = momentsState.moments
                      .where((m) => m.photoUrl != null || m.localPhotoPath != null)
                      .toList();

                  if (index < photos.length) {
                    return MomentPhoto(
                      photoUrl: photos[index].photoUrl,
                      localPath: photos[index].localPhotoPath,
                      onTap: () => _viewPhoto(context, photos[index].photoUrl),
                    );
                  }
                  // Last item is the upload placeholder
                  return MomentPhoto(
                    isPlaceholder: true,
                    onTap: _addPhoto,
                  );
                },
                childCount: momentsState.moments
                        .where((m) =>
                            m.photoUrl != null || m.localPhotoPath != null)
                        .length +
                    1,
              ),
            ),
          ),

          // ── Toggle Status Button ──────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingLg,
                vertical: AppConstants.spacingMd,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    ref
                        .read(taskListProvider.notifier)
                        .toggleTaskStatus(task);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCompleted
                        ? AppColors.surfaceContainerHigh
                        : AppColors.primary,
                    foregroundColor: isCompleted
                        ? AppColors.onSurfaceVariant
                        : AppColors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          AppConstants.radiusDefault),
                    ),
                  ),
                  child: Text(
                    isCompleted ? 'Mark as Pending' : 'Mark as Completed',
                  ),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: AppConstants.spacingXxl),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(bool isCompleted) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 14,
            color: isCompleted ? AppColors.primary : AppColors.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            isCompleted ? 'Completed' : 'Pending',
            style: AppTypography.labelSm.copyWith(
              color: AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _viewPhoto(BuildContext context, String? url) {
    if (url == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: InteractiveViewer(
              child: _buildPhotoViewer(url),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoViewer(String url) {
    if (url.startsWith('/') || url.startsWith('file://')) {
      return Image.file(
        File(url.startsWith('file://') ? url.substring(7) : url),
        fit: BoxFit.contain,
      );
    }
    return Image.network(url, fit: BoxFit.contain);
  }

  Future<void> _addPhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );
    if (image == null) return;

    await ref
        .read(momentListProvider(widget.taskId).notifier)
        .uploadAndAddPhoto(image.path);
  }

  void _saveReflection(String value) {
    // Debounced save would be better in production
    // For MVP, we create/update a moment with reflection text
    final momentsState = ref.read(momentListProvider(widget.taskId));
    final textMoments = momentsState.moments
        .where((m) => m.reflection != null && m.reflection!.isNotEmpty)
        .toList();

    if (textMoments.isEmpty && value.trim().isNotEmpty) {
      ref.read(momentListProvider(widget.taskId).notifier).addMoment(
            reflection: value.trim(),
          );
    } else if (textMoments.isNotEmpty) {
      ref.read(momentListProvider(widget.taskId).notifier).updateReflection(
            textMoments.first.id,
            value.trim(),
          );
    }
  }
}
