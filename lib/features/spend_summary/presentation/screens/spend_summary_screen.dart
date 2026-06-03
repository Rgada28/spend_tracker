import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../bloc/spend_summary_bloc.dart';
import '../bloc/spend_summary_event.dart';
import '../bloc/spend_summary_state.dart';
import '../widgets/header_summary_card.dart';
import '../widgets/category_scroll_row.dart';
import '../widgets/transaction_list.dart';
import '../widgets/add_transaction_fab.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';

class SpendSummaryScreen extends StatefulWidget {
  const SpendSummaryScreen({super.key});

  @override
  State<SpendSummaryScreen> createState() => _SpendSummaryScreenState();
}

class _SpendSummaryScreenState extends State<SpendSummaryScreen>
    with TickerProviderStateMixin {
  late AnimationController _animController;

  late Animation<double> _scaffoldFade;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late Animation<double> _categoryFade;
  late Animation<double> _fabScale;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _scaffoldFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: const Interval(0.0, 0.15, curve: Curves.easeIn)),
    );

    _headerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: const Interval(0.07, 0.4, curve: Curves.easeOut)),
    );

    _headerSlide = Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animController, curve: const Interval(0.07, 0.4, curve: Curves.easeOutCubic)),
    );

    _categoryFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: const Interval(0.28, 0.6, curve: Curves.easeOut)),
    );

    _fabScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: const Interval(0.43, 0.65, curve: Curves.easeOutBack)),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: BlocBuilder<SpendSummaryBloc, SpendSummaryState>(
        builder: (context, state) {
          if (state is! SpendSummaryLoaded) return const SizedBox.shrink();
          return AddTransactionFab(scaleAnimation: _fabScale);
        },
      ),
      body: FadeTransition(
        opacity: _scaffoldFade,
        child: BlocBuilder<SpendSummaryBloc, SpendSummaryState>(
          builder: (context, state) {
            if (state is SpendSummaryLoading || state is SpendSummaryInitial) {
              return _buildShimmer();
            }
            if (state is SpendSummaryError) {
              return _buildError(context, state.message);
            }
            if (state is SpendSummaryLoaded) {
              return _buildContent(context, state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, SpendSummaryLoaded state) {
    final filtered = state.filteredTransactions;
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.of(context).padding.top + 16),
        ),
        SliverToBoxAdapter(
          child: _buildScreenHeader(),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
        SliverToBoxAdapter(
          child: HeaderSummaryCard(
            summary: state.summary,
            fadeAnimation: _headerFade,
            slideAnimation: _headerSlide,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
        SliverToBoxAdapter(
          child: CategoryScrollRow(
            categories: state.categories,
            activeCategoryFilter: state.activeCategoryFilter,
            fadeAnimation: _categoryFade,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
        SliverToBoxAdapter(
          child: _buildTransactionHeader(filtered.length),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),
        TransactionList(
          transactions: filtered,
          categories: state.categories,
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: AppSpacing.fabClearance),
        ),
      ],
    );
  }

  Widget _buildScreenHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('My Spending', style: AppTextStyles.sectionHeading),
              const SizedBox(height: 2),
              Text(
                'Track every rupee',
                style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionHeader(int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Row(
        children: [
          const Text('Recent Transactions', style: AppTextStyles.sectionHeading),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count items',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 16,
            left: AppSpacing.screenPadding,
            right: AppSpacing.screenPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header placeholder
              _shimmerBox(width: 140, height: 24, radius: 8),
              const SizedBox(height: 4),
              _shimmerBox(width: 100, height: 16, radius: 6),
              const SizedBox(height: AppSpacing.lg),
              // Card placeholder
              _shimmerBox(
                width: double.infinity,
                height: 160,
                radius: AppSpacing.cardBorderRadius,
              ),
              const SizedBox(height: AppSpacing.lg),
              // Chips placeholder
              Row(
                children: List.generate(
                  5,
                  (i) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _shimmerBox(width: 76, height: 100, radius: AppSpacing.chipBorderRadius),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _shimmerBox(width: 180, height: 22, radius: 8),
              const SizedBox(height: AppSpacing.md),
              // Transaction placeholders
              ...List.generate(
                8,
                (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      _shimmerBox(width: 44, height: 44, radius: 14),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _shimmerBox(width: 160, height: 14, radius: 6),
                          const SizedBox(height: 6),
                          _shimmerBox(width: 100, height: 12, radius: 6),
                        ],
                      ),
                      const Spacer(),
                      _shimmerBox(width: 60, height: 16, radius: 6),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shimmerBox({
    required double width,
    required double height,
    required double radius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline_rounded,
              color: AppColors.danger, size: 48),
          const SizedBox(height: 16),
          Text(message,
              style: AppTextStyles.caption, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => context
                .read<SpendSummaryBloc>()
                .add(const SpendSummaryLoadRequested()),
            child: const Text('Retry',
                style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
