import 'dart:io';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/constants/app_constants.dart';

/// Photo item in the moment grid.
class MomentPhoto extends StatelessWidget {
  final String? photoUrl;
  final String? localPath;
  final VoidCallback? onTap;
  final bool isPlaceholder;

  const MomentPhoto({
    super.key,
    this.photoUrl,
    this.localPath,
    this.onTap,
    this.isPlaceholder = false,
  });

  bool get _isLocalPath {
    final path = localPath ?? photoUrl ?? '';
    return path.startsWith('/') || path.startsWith('file://');
  }

  @override
  Widget build(BuildContext context) {
    if (isPlaceholder) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(AppConstants.radiusDefault),
            border: Border.all(
              color: AppConstants.ghostBorderColor,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, size: 32, color: AppColors.outlineVariant),
              const SizedBox(height: 4),
              Text(
                'Upload',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.outlineVariant,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.radiusDefault),
          border: Border.all(
            color: AppConstants.ghostBorderColor,
            width: 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    final path = localPath ?? photoUrl;

    if (path != null && _isLocalPath) {
      return Image.file(
        File(path.startsWith('file://') ? path.substring(7) : path),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }

    if (photoUrl != null && photoUrl!.startsWith('http')) {
      return Image.network(
        photoUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => _placeholder(),
        loadingBuilder: (_, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      );
    }

    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.surfaceContainerLow,
      child: const Icon(
        Icons.image_outlined,
        color: AppColors.outlineVariant,
      ),
    );
  }
}
