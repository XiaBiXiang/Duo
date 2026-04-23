import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/constants/app_constants.dart';
import '../providers/task_provider.dart';

/// Filter chip bar for filtering tasks by status.
class StatusChipBar extends StatelessWidget {
  final TaskFilter selectedFilter;
  final ValueChanged<TaskFilter> onFilterChanged;

  const StatusChipBar({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: TaskFilter.values.map((filter) {
          final isSelected = filter == selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(right: AppConstants.spacingSm),
            child: GestureDetector(
              onTap: () => onFilterChanged(filter),
              child: AnimatedContainer(
                duration: AppConstants.animNormal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.surfaceContainerHigh,
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusFull),
                ),
                child: Text(
                  _label(filter),
                  style: AppTypography.labelMd.copyWith(
                    color: isSelected
                        ? AppColors.onPrimary
                        : AppColors.onSurfaceVariant,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _label(TaskFilter filter) {
    switch (filter) {
      case TaskFilter.all:
        return 'All';
      case TaskFilter.pending:
        return 'Pending';
      case TaskFilter.completed:
        return 'Done';
    }
  }
}
