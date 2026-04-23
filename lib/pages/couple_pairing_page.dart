import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/constants/app_constants.dart';
import '../providers/couple_provider.dart';

class CouplePairingPage extends ConsumerStatefulWidget {
  const CouplePairingPage({super.key});

  @override
  ConsumerState<CouplePairingPage> createState() =>
      _CouplePairingPageState();
}

class _CouplePairingPageState extends ConsumerState<CouplePairingPage> {
  final _inviteController = TextEditingController();
  bool _showJoinForm = false;

  @override
  void dispose() {
    _inviteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final coupleState = ref.watch(coupleProvider);

    // If we have a couple with invite code, show it
    if (coupleState.couple != null && !coupleState.couple!.isPaired) {
      return _buildWaitingForPartner(coupleState.couple!.inviteCode);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),

              Center(
                child: Icon(Icons.favorite,
                    size: 48, color: AppColors.primary.withValues(alpha: 0.6)),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  '连接你的另一半',
                  style: AppTypography.headlineLg.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  '创建情侣空间或加入对方的',
                  style: AppTypography.bodyMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Create button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: coupleState.isLoading
                      ? null
                      : () => ref.read(coupleProvider.notifier).createCouple(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusDefault),
                    ),
                  ),
                  child: coupleState.isLoading
                      ? const CircularProgressIndicator(
                          color: AppColors.onPrimary, strokeWidth: 2)
                      : const Text('创建我们的空间',
                          style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 24),

              // Divider
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.outlineVariant)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('或',
                        style: AppTypography.bodySm.copyWith(
                            color: AppColors.outlineVariant)),
                  ),
                  const Expanded(child: Divider(color: AppColors.outlineVariant)),
                ],
              ),
              const SizedBox(height: 24),

              // Join section
              if (!_showJoinForm)
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () => setState(() => _showJoinForm = true),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusDefault),
                      ),
                    ),
                    child: const Text('用邀请码加入',
                        style: TextStyle(fontSize: 16)),
                  ),
                )
              else ...[
                TextField(
                  controller: _inviteController,
                  textCapitalization: TextCapitalization.characters,
                  maxLength: 6,
                  decoration: const InputDecoration(
                    labelText: '邀请码',
                    hintText: '例如 AB3K7M',
                    prefixIcon: Icon(Icons.link),
                    counterText: '',
                  ),
                  style: AppTypography.headlineMd.copyWith(
                    letterSpacing: 4,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: coupleState.isLoading
                        ? null
                        : _joinCouple,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                    ),
                    child: coupleState.isLoading
                        ? const CircularProgressIndicator(
                            color: AppColors.onPrimary, strokeWidth: 2)
                        : const Text('加入'),
                  ),
                ),
              ],

              // Error
              if (coupleState.error != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.errorContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    coupleState.error!,
                    style: AppTypography.bodySm.copyWith(color: AppColors.error),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWaitingForPartner(String inviteCode) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite, size: 64,
                  color: AppColors.primary.withValues(alpha: 0.6)),
              const SizedBox(height: 32),
              Text(
                '把这个邀请码分享给你的另一半',

                style: AppTypography.headlineSm.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Invite code display
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primaryFixedDim, width: 2),
                  boxShadow: AppConstants.ambientShadow,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        inviteCode,
                        style: AppTypography.headlineLg.copyWith(
                          color: AppColors.primary,
                          letterSpacing: 6,
                          fontWeight: FontWeight.w800,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.copy, color: AppColors.primary),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: inviteCode));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('邀请码已复制！')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                '等待你的另一半加入...',
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              const CircularProgressIndicator(color: AppColors.primary),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => ref.read(coupleProvider.notifier).reload(),
                child: const Text('刷新'),
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () => ref.read(coupleProvider.notifier).unpair(),
                icon: const Icon(Icons.arrow_back, size: 18),
                label: const Text('返回重选'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _joinCouple() {
    final code = _inviteController.text.trim().toUpperCase();
    if (code.length != 6) return;
    ref.read(coupleProvider.notifier).joinCouple(code);
  }
}
