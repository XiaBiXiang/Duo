import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/constants/app_constants.dart';
import '../models/task.dart';

/// Card widget for displaying a single task in the list.
/// Matches the bucket_list_home design: circular checkbox, task info,
/// 56x56 thumbnail placeholder, ambient shadow.
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback? onToggleStatus;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.status == TaskStatus.completed;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: AppConstants.animNormal,
        opacity: isCompleted ? 0.75 : 1.0,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isCompleted
                ? AppColors.surfaceContainerLow
                : AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF31332F).withValues(
                    alpha: isCompleted ? 0.03 : 0.06),
                blurRadius: 40,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            children: [
              // ── Circular Checkbox ────────────────────
              GestureDetector(
                onTap: onToggleStatus,
                child: AnimatedContainer(
                  duration: AppConstants.animNormal,
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? AppColors.primary
                        : AppColors.surfaceContainerLowest,
                    border: isCompleted
                        ? Border.all(color: AppColors.primary, width: 1.5)
                        : Border.all(
                            color: AppColors.outlineVariant
                                .withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                  ),
                  child: isCompleted
                      ? const Icon(Icons.check,
                          size: 16, color: AppColors.onPrimary)
                      : null,
                ),
              ),
              const SizedBox(width: 20),

              // ── Task Info ────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: AppTypography.bodyLg.copyWith(
                        fontWeight: FontWeight.w500,
                        color: isCompleted
                            ? AppColors.onSurfaceVariant
                            : AppColors.onSurface,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        decorationColor:
                            AppColors.outlineVariant.withValues(alpha: 0.5),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _subtitle(),
                      style: AppTypography.bodySm.copyWith(
                        color: isCompleted
                            ? AppColors.onSurfaceVariant.withValues(
                                alpha: 0.7)
                            : (task.status == TaskStatus.pending &&
                                    task.category != null
                                ? AppColors.primary
                                : AppColors.onSurfaceVariant),
                        fontWeight: task.category != null &&
                                !isCompleted
                            ? FontWeight.w500
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // ── 56x56 Thumbnail Placeholder ──────────
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF31332F).withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    _categoryIcon(),
                    size: 24,
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _subtitle() {
    if (task.status == TaskStatus.completed && task.completedAt != null) {
      return 'Completed ${_formatDate(task.completedAt!)}';
    }
    if (task.description != null && task.description!.isNotEmpty) {
      return task.description!;
    }
    if (task.category != null) {
      return task.category!;
    }
    return 'Planning Phase';
  }

  IconData _categoryIcon() {
    final cat = task.category?.toLowerCase() ?? '';
    if (cat.contains('adventure') || cat.contains('冒险')) {
      return Icons.terrain;
    } else if (cat.contains('food') || cat.contains('美食')) {
      return Icons.restaurant;
    } else if (cat.contains('travel') || cat.contains('旅行')) {
      return Icons.flight;
    } else if (cat.contains('movie') || cat.contains('电影')) {
      return Icons.movie;
    } else if (cat.contains('music') || cat.contains('音乐')) {
      return Icons.music_note;
    } else if (cat.contains('sport') || cat.contains('运动')) {
      return Icons.sports_soccer;
    }
    return Icons.favorite_border;
  }

  String _formatDate(DateTime date) {
    final months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month]} ${date.year}';
  }
}
