import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/constants/app_constants.dart';
import '../providers/auth_provider.dart';
import '../providers/couple_provider.dart';
import '../providers/settings_provider.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final _nameController = TextEditingController();
  bool _isEditingName = false;
  bool _isSavingName = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final coupleState = ref.watch(coupleProvider);
    final settings = ref.watch(settingsProvider);
    final user = auth.user;
    final couple = coupleState.couple;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _SectionTitle(title: '个人资料'),
            const SizedBox(height: 12),
            _ProfileCard(
              user: user,
              isDark: isDark,
              nameController: _nameController,
              isEditingName: _isEditingName,
              isSavingName: _isSavingName,
              onEditName: () {
                _nameController.text = user?.name ?? '';
                setState(() => _isEditingName = true);
              },
              onSaveName: _saveName,
              onCancelEdit: () => setState(() => _isEditingName = false),
            ),
            const SizedBox(height: 32),

            if (couple != null) ...[
              _SectionTitle(title: '情侣空间'),
              const SizedBox(height: 12),
              _CoupleCard(couple: couple, currentUserId: user?.$id, isDark: isDark),
              const SizedBox(height: 32),
            ],

            _SectionTitle(title: '偏好设置'),
            const SizedBox(height: 12),
            _SettingsTile(
              icon: Icons.dark_mode_outlined,
              title: '深色模式',
              isDark: isDark,
              trailing: Switch(
                value: settings.isDarkMode,
                onChanged: (v) => ref.read(settingsProvider.notifier).setDarkMode(v),
                activeColor: AppColors.primaryFixed,
              ),
            ),
            const SizedBox(height: 8),
            _SettingsTile(
              icon: Icons.notifications_outlined,
              title: '消息通知',
              isDark: isDark,
              trailing: Switch(
                value: settings.isNotificationEnabled,
                onChanged: (v) => ref.read(settingsProvider.notifier).setNotificationEnabled(v),
                activeColor: AppColors.primaryFixed,
              ),
            ),
            const SizedBox(height: 32),

            if (couple != null) ...[
              _SectionTitle(title: '危险操作'),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: _showUnpairDialog,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.error.withValues(alpha: 0.5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusDefault),
                    ),
                  ),
                  child: Text('解除配对', style: TextStyle(color: AppColors.error)),
                ),
              ),
              const SizedBox(height: 16),
            ],

            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: () => ref.read(authProvider.notifier).logout(),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.error.withValues(alpha: 0.5)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusDefault),
                  ),
                ),
                child: Text('退出登录', style: TextStyle(color: AppColors.error)),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Future<void> _saveName() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    setState(() => _isSavingName = true);
    await ref.read(authProvider.notifier).updateName(name);
    if (mounted) setState(() {
      _isEditingName = false;
      _isSavingName = false;
    });
  }

  void _showUnpairDialog() {
    final confirmController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final canConfirm = confirmController.text == '解除配对';
            return AlertDialog(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: AppColors.error),
                  const SizedBox(width: 8),
                  const Text('解除配对'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '这将删除你们的情侣空间，双方都将失去共享的任务和回忆。此操作不可撤销。',
                    style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '请输入「解除配对」以确认：',
                    style: AppTypography.labelMd.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: confirmController,
                    autofocus: true,
                    onChanged: (_) => setDialogState(() {}),
                    decoration: const InputDecoration(
                      hintText: '解除配对',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.pop(dialogContext),
                  child: const Text('取消'),
                ),
                ElevatedButton(
                  onPressed: (isLoading || !canConfirm)
                      ? null
                      : () async {
                          setDialogState(() => isLoading = true);
                          try {
                            await ref.read(coupleProvider.notifier).unpair();
                            if (dialogContext.mounted) Navigator.pop(dialogContext);
                          } catch (e) {
                            setDialogState(() => isLoading = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('操作失败: $e')),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canConfirm ? AppColors.error : AppColors.outlineVariant,
                    foregroundColor: AppColors.onError,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 16, height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onError),
                        )
                      : const Text('确认解除'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      title,
      style: AppTypography.labelSm.copyWith(
        color: isDark ? AppColors.darkOnSurfaceVariant : AppColors.onSurfaceVariant,
        letterSpacing: 1.5,
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final dynamic user;
  final bool isDark;
  final TextEditingController nameController;
  final bool isEditingName;
  final bool isSavingName;
  final VoidCallback onEditName;
  final VoidCallback onSaveName;
  final VoidCallback onCancelEdit;

  const _ProfileCard({
    required this.user, required this.isDark,
    required this.nameController, required this.isEditingName, required this.isSavingName,
    required this.onEditName, required this.onSaveName, required this.onCancelEdit,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? AppColors.darkSurfaceContainerLow : AppColors.surfaceContainerLowest;
    final textColor = isDark ? AppColors.darkOnSurface : AppColors.onSurface;
    final subColor = isDark ? AppColors.darkOnSurfaceVariant : AppColors.onSurfaceVariant;
    final initial = (user?.name as String?)?.isNotEmpty == true
        ? (user!.name as String)[0].toUpperCase() : '?';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppConstants.ambientShadow,
      ),
      child: Column(
        children: [
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryFixed,
              border: Border.all(color: AppColors.primaryFixed, width: 3),
            ),
            child: Center(
              child: Text(initial, style: const TextStyle(
                color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 28,
              )),
            ),
          ),
          const SizedBox(height: 16),
          if (isEditingName) ...[
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nameController,
                    autofocus: true,
                    style: AppTypography.bodyLg.copyWith(color: textColor),
                    decoration: const InputDecoration(
                      hintText: '输入你的昵称',
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (isSavingName)
                  const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                else ...[
                  IconButton(icon: Icon(Icons.check, color: AppColors.primary), onPressed: onSaveName),
                  IconButton(icon: Icon(Icons.close, color: AppColors.outline), onPressed: onCancelEdit),
                ],
              ],
            ),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(user?.name ?? '未知', style: AppTypography.titleLg.copyWith(
                  fontWeight: FontWeight.w700, color: textColor,
                )),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onEditName,
                  child: Icon(Icons.edit_outlined, size: 18, color: AppColors.primary),
                ),
              ],
            ),
          ],
          const SizedBox(height: 4),
          Text(user?.email ?? '', style: AppTypography.bodySm.copyWith(color: subColor)),
        ],
      ),
    );
  }
}

class _CoupleCard extends StatelessWidget {
  final dynamic couple;
  final String? currentUserId;
  final bool isDark;

  const _CoupleCard({required this.couple, required this.currentUserId, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? AppColors.darkSurfaceContainerLow : AppColors.surfaceContainerLowest;
    final textColor = isDark ? AppColors.darkOnSurface : AppColors.onSurface;
    final subColor = isDark ? AppColors.darkOnSurfaceVariant : AppColors.onSurfaceVariant;
    final inviteCode = (couple as dynamic).inviteCode as String;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor, borderRadius: BorderRadius.circular(20),
        boxShadow: AppConstants.ambientShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.favorite, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text('我们的空间', style: AppTypography.titleMd.copyWith(
                fontWeight: FontWeight.w700, color: textColor,
              )),
              const Spacer(),
              if ((couple as dynamic).isPaired as bool)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryFixed.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('已配对', style: AppTypography.labelSm.copyWith(
                    color: AppColors.primary, fontWeight: FontWeight.w600,
                  )),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text('邀请码', style: AppTypography.bodySm.copyWith(color: subColor)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceContainer : AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(inviteCode, style: AppTypography.headlineSm.copyWith(
                    color: AppColors.primary, letterSpacing: 4, fontWeight: FontWeight.w800,
                  )),
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: inviteCode));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('邀请码已复制')),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixed.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.copy, size: 18, color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isDark;
  final Widget trailing;

  const _SettingsTile({required this.icon, required this.title, required this.isDark, required this.trailing});

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? AppColors.darkSurfaceContainerLow : AppColors.surfaceContainerLowest;
    final textColor = isDark ? AppColors.darkOnSurface : AppColors.onSurface;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor, borderRadius: BorderRadius.circular(16),
        boxShadow: AppConstants.ambientShadow,
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: AppColors.primary),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: AppTypography.bodyLg.copyWith(
            fontWeight: FontWeight.w500, color: textColor,
          ))),
          trailing,
        ],
      ),
    );
  }
}
