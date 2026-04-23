import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/constants/app_constants.dart';
import '../models/couple.dart';
import '../providers/task_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/couple_provider.dart';
import '../widgets/task_card.dart';
import 'add_task_bottom_sheet.dart';

/// Home page — the couple's bucket list overview.
/// Matches the "bucket_list_home" design: editorial header, task cards with
/// thumbnails, bottom nav bar, centered gradient FAB.
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(taskListProvider);
    final notifier = ref.read(taskListProvider.notifier);
    final userName = ref.watch(authProvider).user?.name ?? '';
    final coupleState = ref.watch(coupleProvider);
    final userId = ref.watch(authProvider).user?.$id;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Main scrollable content ─────────────────
          SafeArea(
            bottom: false,
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () => ref.read(taskListProvider.notifier).loadTasks(),
              child: CustomScrollView(
              slivers: [
                // ── Glass Header ───────────────────────
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.background.withValues(alpha: 0.8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Heart icon
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryFixed.withValues(
                                alpha: 0.3),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            Icons.favorite,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                        // Title
                        Text(
                          '我们的圣地',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: AppColors.primary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        // Avatar with user initial → tap to settings
                        GestureDetector(
                          onTap: () => context.push('/settings'),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryFixed,
                              border: Border.all(
                                  color: AppColors.primaryFixed, width: 2),
                            ),
                            child: Center(
                              child: Text(
                                userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Partner Bar ─────────────────────────
                if (coupleState.couple != null)
                  SliverToBoxAdapter(
                    child: _PartnerBar(
                      couple: coupleState.couple!,
                      currentUserId: userId,
                    ),
                  ),

                // ── Editorial Header ────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
                    child: Container(
                      padding: const EdgeInsets.only(left: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            width: 4,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '冒险在等待',
                            style: AppTypography.headlineLg.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.onSurface,
                              letterSpacing: -0.5,
                              fontSize: 36,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '记录属于我们的每一个瞬间。',
                            style: AppTypography.bodyLg.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Task list ───────────────────────────
                state.isLoading
                    ? const SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      )
                    : state.filteredTasks.isEmpty
                        ? SliverFillRemaining(
                            child: _buildEmptyState(context),
                          )
                        : SliverPadding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final task = state.filteredTasks[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 20),
                                    child: TaskCard(
                                      task: task,
                                      onTap: () => context
                                          .push('/task/${task.id}'),
                                      onToggleStatus: () =>
                                          notifier.toggleTaskStatus(task),
                                    ),
                                  );
                                },
                                childCount:
                                    state.filteredTasks.length,
                              ),
                            ),
                          ),

                // Bottom padding for nav bar + FAB
                const SliverToBoxAdapter(
                  child: SizedBox(height: 160),
                ),
              ],
            ),
            ),
          ),

          // ── Bottom Navigation Bar ──────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(40)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF31332F).withValues(alpha: 0.04),
                    blurRadius: 30,
                    offset: const Offset(0, -8),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _navItem(0, Icons.home_filled, '首页'),
                      _navItem(1, Icons.add_circle_outline, '添加'),
                      _navItem(2, Icons.auto_awesome, '回忆'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // ── Centered Gradient FAB ───────────────────────
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primaryDim],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(32),
            child: InkWell(
              borderRadius: BorderRadius.circular(32),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const AddTaskBottomSheet(),
                );
              },
              child: const Center(
                child: Icon(Icons.add, color: AppColors.onPrimary,
                    size: 32),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final isActive = _currentNavIndex == index;
    return GestureDetector(
      onTap: () {
        if (index == 1) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const AddTaskBottomSheet(),
          );
          return;
        }
        setState(() => _currentNavIndex = index);
      },
      child: AnimatedContainer(
        duration: AppConstants.animNormal,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 20,
                color: isActive ? AppColors.onPrimary : AppColors.outline),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
                color: isActive ? AppColors.onPrimary : AppColors.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingXxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border_rounded,
              size: 64,
              color: AppColors.outlineVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppConstants.spacingLg),
            Text(
              '清单还是空的',
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppConstants.spacingSm),
            Text(
              '点击 + 按钮开始你们的\n恋爱清单吧',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMd.copyWith(
                color: AppColors.outlineVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Partner info bar — shows who you're paired with.
class _PartnerBar extends StatelessWidget {
  final Couple couple;
  final String? currentUserId;

  const _PartnerBar({required this.couple, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    final isUser1 = currentUserId == couple.user1Id;
    final partnerName = isUser1
        ? (couple.user2Name ?? '等待加入...')
        : (couple.user1Name ?? '未知');
    final myName = isUser1
        ? (couple.user1Name ?? '我')
        : (couple.user2Name ?? '我');
    final isPaired = couple.isPaired;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: isPaired ? () => _showPartnerInfo(context, partnerName, myName) : null,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryFixed.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              // My avatar
              _Avatar(name: myName),
              const SizedBox(width: 8),
              Icon(Icons.favorite, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              // Partner avatar
              _Avatar(name: partnerName, isWaiting: !isPaired),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isPaired ? '和 $partnerName 一起' : '等待另一半加入',
                      style: AppTypography.bodyMd.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isPaired ? '点击查看详情' : '邀请码: ${couple.inviteCode}',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (isPaired)
                Icon(Icons.chevron_right, size: 20, color: AppColors.outline),
            ],
          ),
        ),
      ),
    );
  }

  void _showPartnerInfo(BuildContext context, String partnerName, String myName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48, height: 6,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ProfileColumn(name: myName, label: '我'),
                Icon(Icons.favorite, color: AppColors.primary, size: 28),
                _ProfileColumn(name: partnerName, label: '伴侣'),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.link, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text('邀请码: ${couple.inviteCode}',
                    style: AppTypography.bodyMd.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String name;
  final bool isWaiting;

  const _Avatar({required this.name, this.isWaiting = false});

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Container(
      width: 36, height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isWaiting
            ? AppColors.outlineVariant.withValues(alpha: 0.3)
            : AppColors.primaryFixed,
      ),
      child: Center(
        child: isWaiting
            ? Icon(Icons.hourglass_empty, size: 16, color: AppColors.outline)
            : Text(initial, style: TextStyle(
                color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 14,
              )),
      ),
    );
  }
}

class _ProfileColumn extends StatelessWidget {
  final String name;
  final String label;

  const _ProfileColumn({required this.name, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56, height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryFixed,
            border: Border.all(color: AppColors.primaryFixed, width: 2),
          ),
          child: Center(
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: const TextStyle(
                color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 22,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(name, style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.w600)),
        Text(label, style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
      ],
    );
  }
}
